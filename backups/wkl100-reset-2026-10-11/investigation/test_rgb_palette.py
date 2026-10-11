"""Backed-up runtime palette test; no keymap, custom table, or ISP writes."""
from pathlib import Path
import json
import time
import wkl_control as w
from set_custom_eight_keys import read_region

ROOT = Path(__file__).resolve().parent
events = []
before = None
h = w.open_device()
try:
    before = w.read_settings(h)
    custom = read_region(h, 'custom')
    base = read_region(h, 'base')
    (ROOT / 'rgb-palette-test-settings-backup.bin').write_bytes(before)
    for index, name in [(0, 'RED'), (1, 'GREEN'), (7, 'MULTICOLOR')]:
        state = bytearray(before)
        state[10] = 1
        state[58] = 20
        state[59] = (state[59] & 0xf0) | index
        w.send(h, bytes.fromhex('09 04 00 00 01 00 80 00') + state + bytes(384))
        if w.read_settings(h) != state:
            raise RuntimeError('Palette settings readback mismatch')
        events.append({'index': index, 'expected': name, 'readback_matches': True})
        print(name, flush=True)
        time.sleep(12)
finally:
    try:
        if before is not None:
            w.send(h, bytes.fromhex('09 04 00 00 01 00 80 00') + before + bytes(384))
            restored = w.read_settings(h) == before
            events.append({'settings_restored': restored})
            print('ORIGINAL SETTINGS RESTORED:', restored, flush=True)
            if not restored:
                raise RuntimeError('Original settings restoration mismatch')
            if 'custom' in locals() and 'base' in locals():
                unchanged = read_region(h, 'custom') == custom and read_region(h, 'base') == base
                events.append({'custom_and_base_unchanged': unchanged})
                if not unchanged:
                    raise RuntimeError('Custom table or keymap changed unexpectedly')
    finally:
        h.close()
        (ROOT / 'rgb-palette-test.json').write_text(json.dumps({
            'events': events, 'physical_observation': 'pending'
        }, indent=2) + '\n')
