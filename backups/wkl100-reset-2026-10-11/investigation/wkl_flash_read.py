"""Stock WKL-100 ISP dump. NEVER erases or writes a firmware image.

--unlock explicitly permits command 55: upstream documents that it can
program the existing application-enable opcode at EFFB to 02. This is a
flash side effect, so it must not be described as a strictly read-only dump.
The keyboard must be connected by cable. Reboot is attempted in finally.
"""
import argparse, hashlib, json, time
from pathlib import Path
import hid
from probe_bootloader_read import metadata, boot_devices, ensure_no_interception_hotplug

ROOT = Path(__file__).resolve().parent
def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--unlock', action='store_true', help='Permit documented 55 enable/unlock side effect')
    parser.add_argument('--offline-check', action='store_true', help='Check packet allowlist without opening any device')
    args = parser.parse_args()
    if args.offline_check:
        print('Allowed commands: runtime 05:75; bootloader 05:52, 05:5A' + (' and 05:55' if args.unlock else ''))
        print('Forbidden commands: 05:45 erase, 05:57 write-address, 06:77 page-write')
        return
    ensure_no_interception_hotplug()
    events = []
    stamp = time.strftime('%Y%m%d-%H%M%S')
    log_path = ROOT/f'flash-dump-{stamp}.json'
    cmd = xfer = None
    def log(entry):
        events.append(entry)
        log_path.write_text(json.dumps(events,indent=2))
    def send(device, opcode, address=0, runtime=False):
        allowed = {0x75} if runtime else {0x52,0x5a}|({0x55} if args.unlock else set())
        if opcode not in allowed: raise RuntimeError('Command outside read/recovery allowlist')
        packet = bytes([5,opcode,address&255,address>>8,0,0])
        try:
            result=device.send_feature_report(packet)
            log({'op':'send','hex':packet.hex(' '),'result':result})
        except OSError as exc:
            log({'op':'send','hex':packet.hex(' '),'error':repr(exc)})
            if opcode not in (0x75,0x5a): raise
    try:
        if boot_devices(): raise RuntimeError('Preexisting bootloader device: ambiguous target')
        originals=[d for d in hid.enumerate(0x258a,0x019d) if d['usage_page']==0xff00
                   and d['usage']==1 and b'Col05' in d['path']]
        if len(originals)!=1: raise RuntimeError('Expected exactly one WKL-100 command collection')
        runtime=hid.device()
        try:
            runtime.open_path(originals[0]['path'])
            send(runtime,0x75,runtime=True)
        finally: runtime.close()
        deadline=time.monotonic()+12
        while time.monotonic()<deadline:
            found=boot_devices()
            if found: break
            time.sleep(.25)
        else: raise RuntimeError('Bootloader did not appear')
        metas=[metadata(d) for d in found]
        log({'op':'bootloader','collections':metas})
        commands=[m for m in metas if m['report_ids']==[5] and m['feature_length']==6]
        transfers=[m for m in metas if m['report_ids']==[6] and m['feature_length']==2050]
        if len(commands)!=1 or len(transfers)!=1: raise RuntimeError('Unexpected bootloader descriptor')
        cmd=hid.device(); cmd.open_path(commands[0]['path'].encode())
        xfer=hid.device(); xfer.open_path(transfers[0]['path'].encode())
        if args.unlock:
            send(cmd,0x55)
            time.sleep(.1)
        passes=[]
        for attempt in (1,2):
            image=bytearray()
            # Reset address for every page; do not rely on auto-increment.
            for address in range(0,0x10000,0x800):
                send(cmd,0x52,address)
                data=bytes(xfer.get_feature_report(6,2050))
                if len(data)!=2050 or data[:2]!=b'\x06\x72':
                    raise RuntimeError(f'Invalid page at {address:04X}: {len(data)} bytes {data[:8].hex()}')
                image.extend(data[2:])
                log({'op':'read','pass':attempt,'address':hex(address),
                     'sha256':hashlib.sha256(data[2:]).hexdigest(),'response':data.hex(' ')})
            path=ROOT/f'wkl100-isp-view-{stamp}-pass{attempt}.bin'
            path.write_bytes(image)
            passes.append(bytes(image))
            print(f'Pass {attempt}: {len(image)} bytes, SHA256 {hashlib.sha256(image).hexdigest()}',flush=True)
        if passes[0]!=passes[1]: raise RuntimeError('Repeated dumps differ: not a validated backup')
        pages=[passes[0][i:i+2048] for i in range(0,len(passes[0]),2048)]
        if len(set(pages))<4: raise RuntimeError('Too few distinct pages; read may be locked')
        if passes[0][0]!=2: raise RuntimeError('Expected 8051 LJMP at logical reset vector')
        log({'op':'validation','repeat_equal':True,'distinct_pages':len(set(pages)),
             'bootloader_md5':hashlib.md5(passes[0][0xf000:]).hexdigest(),
             'view':'ISP logical view; reset vector remapped by bootloader, not raw physical flash'})
        print('Repeated dump matches; bootloader MD5',hashlib.md5(passes[0][0xf000:]).hexdigest(),flush=True)
    finally:
        if xfer: xfer.close()
        if cmd:
            try: send(cmd,0x5a)
            finally: cmd.close()
        else:
            for dev in boot_devices():
                if 5 in metadata(dev)['report_ids']:
                    recovery=hid.device()
                    try:
                        recovery.open_path(dev['path'])
                        send(recovery,0x5a)
                    finally: recovery.close()
        deadline=time.monotonic()+12
        while time.monotonic()<deadline:
            if hid.enumerate(0x258a,0x019d):
                log({'op':'runtime-recovered','success':True})
                print('WKL-100 runtime identity recovered.',flush=True)
                break
            time.sleep(.25)
        else:
            log({'op':'runtime-recovered','success':False})
            print('Runtime did not recover; unplug/replug USB to exit ISP.',flush=True)

if __name__=='__main__': main()
