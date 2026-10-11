"""Backed-up Fn-layer test; preserve Fn/reset and all other actions."""
import argparse
import json
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import query, read_region

ROOT = Path(__file__).resolve().parent

def read_fn(h):
    a = query(h, bytes.fromhex('09 83 01 00 01 00 ff 00'))
    header = bytes.fromhex('09 83 04 00 01 00 ff 00')
    b = query(h, header)
    c = query(h, header)
    if a[-7:] != b[:7] or b[-7:] != c[:7]:
        raise RuntimeError('Fn continuation overlaps differ')
    return a + b[7:] + c[7:16]

def write_fn(h, data):
    if len(data) != 512:
        raise ValueError('Expected whole own-device Fn region')
    w.send(h, bytes.fromhex('09 03 01 00 00 00 00 00') + data)
    if read_fn(h) != data:
        raise RuntimeError('Full Fn region readback mismatch')

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('operation', choices=['apply', 'restore'])
    args = p.parse_args()
    h = w.open_device()
    evidence = {'operation': args.operation, 'physical_observation': 'pending'}
    try:
        path = ROOT / 'fn8-test-backup.bin'
        if args.operation == 'restore':
            write_fn(h, path.read_bytes())
            evidence['original_fn_restored'] = True
        else:
            if path.exists():
                raise RuntimeError('Existing Fn test backup; review before applying again')
            before = read_fn(h)
            if before != read_fn(h):
                raise RuntimeError('Fn backup unstable')
            if before[:4] != bytes.fromhex('08 ff 00 00') or before[236:240] != bytes.fromhex('0d 00 00 00'):
                raise RuntimeError('Expected own Fn/reset actions differ')
            base = read_region(h, 'base')
            settings = w.read_settings(h)
            if base[196:200] != bytes.fromhex('00 00 00 25'):
                raise RuntimeError('Base 8 action is not original')
            path.write_bytes(before)
            desired = bytearray(before)
            desired[196:200] = bytes.fromhex('00 00 00 26')
            evidence['changed_fn_offsets'] = [i for i in range(512) if before[i] != desired[i]]
            evidence['fn_and_reset_preserved'] = desired[:4] == before[:4] and desired[236:240] == before[236:240]
            try:
                write_fn(h, bytes(desired))
                evidence['base_unchanged'] = read_region(h, 'base') == base
                evidence['settings_unchanged'] = w.read_settings(h) == settings
                if not evidence['base_unchanged'] or not evidence['settings_unchanged']:
                    raise RuntimeError('Unrelated state changed')
                evidence['full_fn_readback_matches'] = True
            except BaseException:
                write_fn(h, before)
                raise
        print(json.dumps(evidence, indent=2), flush=True)
    finally:
        h.close()
        (ROOT / ('fn8-test-' + args.operation + '.json')).write_text(json.dumps(evidence, indent=2) + '\n')

if __name__ == '__main__':
    main()
