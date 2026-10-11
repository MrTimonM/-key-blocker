"""Send one OEM-decoded LCD time packet; no ISP or flash/configuration write.

Volume and CPU display fields use zero placeholders. Memory load is queried
from Windows. The three host-stat fields are LCD data, not Windows controls.
Clock readback is unresolved: owner observation is required.
"""
import ctypes
import datetime
import hashlib
import json
import time
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import read_region

ROOT = Path(__file__).resolve().parent

class MemoryStatus(ctypes.Structure):
    _fields_ = [('length', ctypes.c_uint32), ('load', ctypes.c_uint32)] + [
        (name, ctypes.c_uint64) for name in [
            'total_phys', 'avail_phys', 'total_page', 'avail_page',
            'total_virtual', 'avail_virtual', 'avail_extended_virtual'
        ]
    ]

def main():
    h = w.open_device()
    evidence = {'physical_observation': 'pending', 'clock_getter_available': False}
    try:
        settings = w.read_settings(h)
        base = read_region(h, 'base')
        custom = read_region(h, 'custom')
        status = MemoryStatus()
        status.length = ctypes.sizeof(status)
        if not ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(status)):
            raise ctypes.WinError()
        now = datetime.datetime.now().astimezone()
        payload = bytes([
            0, 0, status.load, now.year & 255, now.year >> 8,
            now.month, now.day, now.hour, now.minute, now.second,
            (now.weekday() + 1) % 7
        ])
        packet = bytes.fromhex('09 0b 00 00 01 00 0b 00') + payload + bytes(501)
        evidence.update({'host_local_time': now.isoformat(), 'payload_hex': payload.hex(' '),
                         'volume_cpu_placeholders': [0, 0], 'memory_load': status.load,
                         'settings_before_sha256': hashlib.sha256(settings).hexdigest()})
        (ROOT / 'lcd-clock-sync-test.json').write_text(json.dumps(evidence, indent=2) + '\n')
        w.send(h, packet)
        print('Sent LCD time:', now.strftime('%H:%M:%S %Y-%m-%d'), flush=True)
        time.sleep(1)
        evidence['settings_unchanged'] = w.read_settings(h) == settings
        evidence['base_keymap_unchanged'] = read_region(h, 'base') == base
        evidence['custom_table_unchanged'] = read_region(h, 'custom') == custom
        if not all(evidence[k] for k in ['settings_unchanged', 'base_keymap_unchanged', 'custom_table_unchanged']):
            raise RuntimeError('Unexpected settings/table change after LCD packet')
        print(json.dumps(evidence, indent=2), flush=True)
    finally:
        h.close()
        (ROOT / 'lcd-clock-sync-test.json').write_text(json.dumps(evidence, indent=2) + '\n')

if __name__ == '__main__':
    main()
