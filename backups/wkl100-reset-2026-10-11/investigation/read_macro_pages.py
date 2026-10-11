"""Read-only application-mode backup of the eight known macro CODE pages."""
from pathlib import Path
import hashlib
import json
import wkl_control as w
from set_custom_eight_keys import query

ROOT = Path(__file__).resolve().parent

def read_page(h, page):
    if page not in range(8):
        raise ValueError('Only macro pages 0..7 are supported')
    a = query(h, bytes([9, 0x85, 0, 0, 1, page, 255, 0]))
    continuation = bytes.fromhex('09 83 04 00 01 00 ff 00')
    b = query(h, continuation)
    c = query(h, continuation)
    if a[-7:] != b[:7] or b[-7:] != c[:7]:
        raise RuntimeError('Read continuation overlap mismatch')
    return a + b[7:] + c[7:16]

def main():
    h = w.open_device()
    try:
        passes = [b''.join(read_page(h, i) for i in range(8)) for _ in range(2)]
        if passes[0] != passes[1]:
            raise RuntimeError('Repeated macro backups differ')
        data = passes[0]
        (ROOT / 'macro-runtime-backup.bin').write_bytes(data)
        firmware = (ROOT / 'wkl100-isp-view-20261007-202027-pass1.bin').read_bytes()
        evidence = {
            'length': len(data), 'sha256': hashlib.sha256(data).hexdigest(),
            'two_reads_match': True, 'matches_original_firmware': data == firmware[0xdc00:0xec00],
            'bytes_other_than_00_ff': sum(x not in (0, 255) for x in data),
            'writes': 'Only read-request feature messages; no SET configuration commands.',
        }
        (ROOT / 'macro-runtime-backup.json').write_text(json.dumps(evidence, indent=2) + '\n')
        print(json.dumps(evidence, indent=2))
    finally:
        h.close()

if __name__ == '__main__':
    main()
