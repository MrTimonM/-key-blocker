"""Undo the controlled left-bracket edit using its exact original live map.

Refuses to overwrite any subsequent map edits. Usage: python restore_left_bracket.py
Optional argument: the successful disable-left-bracket-TIMESTAMP.json record.
"""
import argparse
import json
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import read_region

ROOT = Path(__file__).resolve().parent

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('record', nargs='?')
    args = parser.parse_args()
    candidates = [Path(args.record)] if args.record else sorted(ROOT.glob('disable-left-bracket-*.json'), reverse=True)
    record = None
    for path in candidates:
        data = json.loads(path.read_text())
        if data.get('full_base_readback_matches') and 'backup_prefix' in data:
            record = data
            break
    if record is None:
        raise RuntimeError('No successful disable record found')
    prefix = ROOT / record['backup_prefix']
    before = Path(str(prefix) + '-base-before.bin').read_bytes()
    disabled = Path(str(prefix) + '-base-desired.bin').read_bytes()
    if len(before) != 512 or len(disabled) != 512:
        raise RuntimeError('Invalid backup size')
    slot = record['slot']
    if [i for i in range(512) if before[i] != disabled[i]] != [4*slot+3]:
        raise RuntimeError('Backup difference exceeds the authorized bracket edit')
    h = w.open_device()
    try:
        live = read_region(h, 'base')
        if live == before:
            print('Original mapping is already restored.')
            return
        if live != disabled or read_region(h, 'base') != live:
            raise RuntimeError('Current map differs; refusing to overwrite later edits')
        w.send(h, bytes.fromhex('09 03 00 00 00 00 00 00') + before)
        if read_region(h, 'base') != before:
            raise RuntimeError('Restoration readback mismatch')
        print('Original complete map restored and verified. No Fn/RGB/settings writes.')
    finally:
        h.close()

if __name__ == '__main__':
    main()
