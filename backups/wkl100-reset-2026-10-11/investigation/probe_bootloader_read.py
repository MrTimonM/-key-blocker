"""Enter ISP temporarily, read two pages twice, reboot in finally.

Allowed SET commands are only runtime ISP entry 75, read-address 52,
and reboot 5A. Does NOT send 55 (enable), 45 (erase), or 57/77 (write).
"""
import ctypes as c
import ctypes.wintypes as w
import hid, time, json, hashlib
import winreg
from pathlib import Path

ROOT = Path(__file__).resolve().parent
events = []
kernel = c.WinDLL('kernel32', use_last_error=True)
hiddll = c.WinDLL('hid', use_last_error=True)
kernel.CreateFileW.argtypes = [w.LPCWSTR,w.DWORD,w.DWORD,c.c_void_p,w.DWORD,w.DWORD,w.HANDLE]
kernel.CreateFileW.restype = w.HANDLE
kernel.CloseHandle.argtypes = [w.HANDLE]
hiddll.HidD_GetPreparsedData.argtypes = [w.HANDLE,c.POINTER(c.c_void_p)]
hiddll.HidD_FreePreparsedData.argtypes = [c.c_void_p]
hiddll.HidP_GetCaps.argtypes = [c.c_void_p,c.c_void_p]
hiddll.HidP_GetCaps.restype = c.c_long
hiddll.HidP_GetValueCaps.argtypes = [c.c_int,c.c_void_p,c.POINTER(w.USHORT),c.c_void_p]
hiddll.HidP_GetValueCaps.restype = c.c_long
class Caps(c.Structure):
    _fields_ = [('Usage',w.USHORT),('UsagePage',w.USHORT),
                ('InputReportByteLength',w.USHORT),('OutputReportByteLength',w.USHORT),
                ('FeatureReportByteLength',w.USHORT),('Reserved',w.USHORT*17)] + [
                (n,w.USHORT) for n in ['NumberLinkCollectionNodes',
                'NumberInputButtonCaps','NumberInputValueCaps','NumberInputDataIndices',
                'NumberOutputButtonCaps','NumberOutputValueCaps','NumberOutputDataIndices',
                'NumberFeatureButtonCaps','NumberFeatureValueCaps','NumberFeatureDataIndices']]

def metadata(dev):
    handle = kernel.CreateFileW(dev['path'].decode(),0,3,None,3,0,None)
    if handle == c.c_void_p(-1).value:
        raise OSError(c.get_last_error())
    pp = c.c_void_p()
    try:
        if not hiddll.HidD_GetPreparsedData(handle,c.byref(pp)):
            raise OSError(c.get_last_error())
        caps = Caps()
        if hiddll.HidP_GetCaps(pp,c.byref(caps)) < 0:
            raise RuntimeError('HidP_GetCaps failed')
        ids = []
        if caps.NumberFeatureValueCaps:
            buf = (c.c_ubyte*(72*caps.NumberFeatureValueCaps))()
            count = w.USHORT(caps.NumberFeatureValueCaps)
            if hiddll.HidP_GetValueCaps(2,buf,c.byref(count),pp) < 0:
                raise RuntimeError('HidP_GetValueCaps failed')
            ids = sorted(set(buf[72*i+2] for i in range(count.value)))
        return {'path':dev['path'].decode(),'report_ids':ids,
                'feature_length':caps.FeatureReportByteLength,
                'usage_page':dev['usage_page'],'usage':dev['usage'],
                'product':dev['product_string']}
    finally:
        if pp.value: hiddll.HidD_FreePreparsedData(pp)
        kernel.CloseHandle(handle)

def boot_devices():
    return [d for d in hid.enumerate() if d['vendor_id']==0x0603
            and d['product_id'] in (0x1020,0x1021)]

def ensure_no_interception_hotplug():
    """Refuse ISP reconnect cycles under the installed Interception filter.
    AHI documents that reconnect IDs can exceed 10 and stop Windows input.
    """
    key=r'SYSTEM\CurrentControlSet\Control\Class\{4d36e96b-e325-11ce-bfc1-08002be10318}'
    try:
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE,key) as handle:
            filters=winreg.QueryValueEx(handle,'UpperFilters')[0]
    except FileNotFoundError:
        return
    if 'keyboard' in [f.lower() for f in filters]:
        raise RuntimeError('Interception keyboard filter installed: ISP reconnect cycles can exhaust its IDs and stop Windows input until restart. Use a host without this filter for further ISP dumps. No USB command sent.')

def log(event):
    events.append(event)
    (ROOT/'bootloader-read-probe.json').write_text(json.dumps(events,indent=2))

def main():
    ensure_no_interception_hotplug()
    cmd = xfer = None
    try:
        if boot_devices(): raise RuntimeError('Preexisting bootloader device: refusing ambiguous target')
        original = [d for d in hid.enumerate(0x258a,0x019d)
                    if d['usage_page']==0xff00 and d['usage']==1 and b'Col05' in d['path']]
        if len(original)!=1: raise RuntimeError('Expected exactly one WKL command collection')
        runtime = hid.device()
        try:
            runtime.open_path(original[0]['path'])
            packet = bytes.fromhex('05 75 00 00 00 00')
            try: log({'op':'enter-isp','request':packet.hex(' '),'result':runtime.send_feature_report(packet)})
            except OSError as exc: log({'op':'enter-isp','disconnect_or_error':repr(exc)})
        finally: runtime.close()
        deadline = time.monotonic()+12
        while time.monotonic()<deadline:
            found = boot_devices()
            if found: break
            time.sleep(.25)
        else: raise RuntimeError('No expected bootloader identity appeared')
        metas = [metadata(d) for d in found]
        log({'op':'bootloader-enumeration','collections':metas})
        print('Bootloader collections:', metas, flush=True)
        commands = [m for m in metas if 5 in m['report_ids']]
        transfers = [m for m in metas if 6 in m['report_ids']]
        if len(commands)!=1 or len(transfers)!=1:
            raise RuntimeError('Ambiguous bootloader report collections')
        cmd = hid.device(); cmd.open_path(commands[0]['path'].encode())
        xfer = hid.device(); xfer.open_path(transfers[0]['path'].encode())
        for address in (0xbc00,0xf000):
            for attempt in (1,2):
                packet = bytes([5,0x52,address&255,address>>8,0,0])
                result = cmd.send_feature_report(packet)
                time.sleep(.05)
                data = bytes(xfer.get_feature_report(6,2050))
                log({'op':'read-page','address':hex(address),'attempt':attempt,
                     'request':packet.hex(' '),'send_result':result,
                     'length':len(data),'response':data.hex(' '),
                     'sha256':hashlib.sha256(data).hexdigest()})
                (ROOT/f'isp-no-enable-{address:04x}-{attempt}.bin').write_bytes(data)
                print(hex(address), attempt, 'length',len(data),'head',data[:48].hex(' '),flush=True)
    finally:
        if xfer: xfer.close()
        if cmd:
            try:
                packet = bytes.fromhex('05 5A 00 00 00 00')
                log({'op':'reboot','request':packet.hex(' '),'result':cmd.send_feature_report(packet)})
            except OSError as exc: log({'op':'reboot','disconnect_or_error':repr(exc)})
            finally: cmd.close()
        else:
            # If ISP appeared but validation failed, still attempt its documented reboot.
            for dev in boot_devices():
                if 5 in metadata(dev)['report_ids']:
                    recovery = hid.device()
                    try:
                        recovery.open_path(dev['path'])
                        recovery.send_feature_report(bytes.fromhex('05 5A 00 00 00 00'))
                        log({'op':'recovery-reboot','path':dev['path'].decode()})
                    except OSError as exc: log({'op':'recovery-reboot','error':repr(exc)})
                    finally: recovery.close()
        deadline = time.monotonic()+12
        while time.monotonic()<deadline:
            if hid.enumerate(0x258a,0x019d):
                log({'op':'runtime-recovered','success':True})
                print('WKL-100 runtime USB identity recovered.',flush=True)
                break
            time.sleep(.25)
        else: log({'op':'runtime-recovered','success':False})

if __name__ == "__main__":
    main()
