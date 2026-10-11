"""Controlled own-map macro test: top-row 8 emits 12 once.

Uses verified runtime backups and preserves all unrelated bytes. No ISP,
reconnect, reset, Fn-layer change, or firmware-image writes.
"""
import argparse
import json
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import read_region
from read_macro_pages import read_page

ROOT = Path(__file__).resolve().parent
PREFIX = 'macro-12-test-v2-'

def write_page(h, page, data):
    if page not in (0, 1) or len(data) != 512:
        raise ValueError('Invalid controlled macro page')
    w.send(h, bytes([9, 5, 0, 0, 1, page, 0, 2]) + data)
    if read_page(h, page) != data:
        raise RuntimeError('Macro page readback mismatch')

def write_base(h, data):
    w.send(h, bytes.fromhex('09 03 00 00 00 00 00 00') + data)
    if read_region(h, 'base') != data:
        raise RuntimeError('Full base readback mismatch')

def restore(h):
    base = (ROOT / (PREFIX + 'base-backup.bin')).read_bytes()
    write_base(h, base)
    for page in (0, 1):
        write_page(h, page, (ROOT / (PREFIX + f'page{page}-backup.bin')).read_bytes())

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('operation', choices=['apply', 'restore'])
    args = parser.parse_args()
    h = w.open_device()
    evidence = {'operation': args.operation, 'physical_observation': 'pending'}
    try:
        if args.operation == 'restore':
            restore(h)
            evidence['original_base_and_pages_restored'] = True
        else:
            if (ROOT / (PREFIX + 'base-backup.bin')).exists():
                raise RuntimeError('Existing test backup: restore/review before reapplying')
            base = read_region(h, 'base')
            if base != read_region(h, 'base') or base[196:200] != bytes.fromhex('00 00 00 25'):
                raise RuntimeError('Expected stable own-map top-row 8 action at slot 49')
            pages = [read_page(h, i) for i in (0, 1)]
            if pages != [read_page(h, i) for i in (0, 1)]:
                raise RuntimeError('Macro page backups unstable')
            baseline = (ROOT / 'macro-runtime-backup.bin').read_bytes()
            if b''.join(pages) != baseline[:1024]:
                raise RuntimeError('Macro pages differ from recently verified backup')
            settings = w.read_settings(h)
            custom = read_region(h, 'custom')
            (ROOT / (PREFIX + 'base-backup.bin')).write_bytes(base)
            for i, data in enumerate(pages):
                (ROOT / (PREFIX + f'page{i}-backup.bin')).write_bytes(data)
            (ROOT / (PREFIX + 'settings-backup.bin')).write_bytes(settings)
            (ROOT / (PREFIX + 'custom-backup.bin')).write_bytes(custom)
            directory = bytearray(pages[0])
            directory[:4] = bytes.fromhex('00 02 11 00')
            data = bytearray(pages[1])
            events = bytes.fromhex('00 00 32 1e 80 00 32 1e 00 00 32 1f 80 00 32 1f')
            data[:17] = bytes([0]) + events
            desired = bytearray(base)
            desired[196:200] = bytes.fromhex('03 01 01 00')
            evidence.update({'slot': 49, 'trigger_action': '03 01 01 00',
                             'directory_entry': '00 02 11 00', 'events_hex': events.hex(' '),
                             'base_changed_offsets': [i for i in range(512) if base[i] != desired[i]],
                             'expected_output': '12 once', 'fn_layer_written': False})
            try:
                write_page(h, 1, bytes(data))
                write_page(h, 0, bytes(directory))
                write_base(h, bytes(desired))
                evidence['settings_unchanged'] = w.read_settings(h) == settings
                evidence['custom_table_unchanged'] = read_region(h, 'custom') == custom
                if not evidence['settings_unchanged'] or not evidence['custom_table_unchanged']:
                    raise RuntimeError('Unrelated settings or lighting changed')
                evidence['all_written_regions_readback_match'] = True
            except BaseException:
                restore(h)
                raise
        print(json.dumps(evidence, indent=2), flush=True)
    finally:
        h.close()
        (ROOT / (PREFIX + args.operation + '.json')).write_text(json.dumps(evidence, indent=2) + '\n')

if __name__ == '__main__':
    main()
