"""Bounded OEM 0C image transfer on WKL-100's FF02:02 collection.

128x128 is a candidate, NOT a measured screen resolution. No firmware/ISP,
keymap or settings writes. Replaces image content; no image backup/getter known.
Default sends only the first 4096-byte block and stops for observation.
"""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import read_region

ROOT = Path(__file__).resolve().parent

def packets(block_index):
    for chunk in range(8):
        yield bytes([9, 12, 0, block_index, 8, chunk, 0, 2]) + bytes.fromhex('f8 00') * 256

def collect(h, timeout=150):
    reports = []
    for _ in range(16):
        data = bytes(h.read(8, timeout))
        if not data:
            break
        w.log('INPUT_REPORT', data, purpose='lcd-image-ack')
        reports.append(data.hex(' '))
    return reports

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--start', type=int, default=0, choices=range(8))
    parser.add_argument('--blocks', type=int, default=1, choices=range(1, 9))
    args = parser.parse_args()
    if args.start + args.blocks > 8:
        parser.error('Transfer exceeds candidate 128x128 frame')
    for block in range(8):
        built = list(packets(block))
        assert all(len(p) == 520 and p[:5] == bytes([9, 12, 0, block, 8]) for p in built)
        assert b''.join(p[8:] for p in built) == bytes.fromhex('f8 00') * 2048
    record = {'time': datetime.datetime.now().astimezone().isoformat(),
              'candidate_dimensions': [128, 128], 'dimensions_verified': False,
              'frame': 0, 'format': 'row-major RGB565 big-endian',
              'color': '#FF0000', 'blocks': [], 'physical_observation': 'pending'}
    output = ROOT / f'lcd-red-blocks-{args.start}-{args.blocks}.json'
    h = w.open_device()
    try:
        before = {'settings': w.read_settings(h), 'base': read_region(h, 'base'),
                  'custom': read_region(h, 'custom')}
        record['before_sha256'] = {k: hashlib.sha256(v).hexdigest() for k, v in before.items()}
        record['stale_inputs'] = collect(h, 50)
        for block in range(args.start, args.start + args.blocks):
            entry = {'block': block, 'inputs': []}
            record['blocks'].append(entry)
            for chunk, packet in enumerate(packets(block)):
                w.send(h, packet)
                entry['inputs'].extend({'after_chunk': chunk, 'hex': r} for r in collect(h, 25))
            entry['inputs'].extend({'after_chunk': 7, 'hex': r} for r in collect(h, 2000))
            # Own firmware 829A emits 09 0A 06 success chunk-count 00 00 00.
            entry['success_ack'] = any(x['hex'] == '09 0a 06 01 08 00 00 00' for x in entry['inputs'])
            print(json.dumps(entry), flush=True)
            if not entry['success_ack']:
                raise RuntimeError('No recognized success acknowledgement: stopping without retries')
        after = {'settings': w.read_settings(h), 'base': read_region(h, 'base'),
                 'custom': read_region(h, 'custom')}
        record['unchanged'] = {k: before[k] == after[k] for k in before}
        if not all(record['unchanged'].values()):
            raise RuntimeError('Unexpected keyboard settings/map/RGB difference')
    except Exception as e:
        record['error'] = str(e)
        raise
    finally:
        h.close()
        output.write_text(json.dumps(record, indent=2) + '\n', encoding='utf8')

if __name__ == '__main__':
    main()
