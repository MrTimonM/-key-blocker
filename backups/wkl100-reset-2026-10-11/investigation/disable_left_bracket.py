"""Owner-authorized WKL-100 base-layer left bracket -> zero/unbound action.

Capture the entire live own-device map first. No ISP, restart or Fn write.
Zero action's physical behavior requires owner confirmation.
"""
import datetime
import hashlib
import json
from pathlib import Path
import wkl_control as w
from set_custom_eight_keys import read_region
from test_fn8_to9 import read_fn

ROOT = Path(__file__).resolve().parent

def main():
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    prefix = ROOT / ('disable-left-bracket-' + stamp)
    record = {'request': 'physical left bracket [ -> do nothing',
              'physical_observation': 'pending', 'fn_layer_written': False}
    h = w.open_device()
    try:
        base = read_region(h, 'base')
        if base != read_region(h, 'base'):
            raise RuntimeError('Unstable live base map')
        factory = (ROOT / 'wkl100-factory-base-512.bin').read_bytes()
        action = bytes.fromhex('00 00 00 2f')
        slots = [i for i in range(128) if factory[4*i:4*i+4] == action]
        if len(slots) != 1:
            raise RuntimeError('Factory map lacks a unique left-bracket slot')
        slot = slots[0]
        if base[4*slot:4*slot+4] != action:
            raise RuntimeError('Live left-bracket action differs; no write performed')
        fn = read_fn(h)
        settings = w.read_settings(h)
        custom = read_region(h, 'custom')
        for kind, data in [('base-before', base), ('fn-before', fn),
                           ('settings-before', settings), ('custom-before', custom)]:
            Path(str(prefix) + '-' + kind + '.bin').write_bytes(data)
        desired = bytearray(base)
        desired[4*slot:4*slot+4] = bytes(4)
        changes = [i for i in range(512) if base[i] != desired[i]]
        if changes != [4*slot+3]:
            raise RuntimeError('Unexpected offline map difference')
        Path(str(prefix) + '-base-desired.bin').write_bytes(desired)
        record.update({'slot': slot, 'hid_usage': '0x2F', 'before_action': action.hex(' '),
                       'after_action': '00 00 00 00', 'changed_offsets': changes,
                       'before_sha256': hashlib.sha256(base).hexdigest(),
                       'backup_prefix': prefix.name})
        w.send(h, bytes.fromhex('09 03 00 00 00 00 00 00') + desired)
        actual = read_region(h, 'base')
        Path(str(prefix) + '-base-after.bin').write_bytes(actual)
        if actual != desired:
            w.send(h, bytes.fromhex('09 03 00 00 00 00 00 00') + base)
            record['restored_after_mismatch'] = read_region(h, 'base') == base
            raise RuntimeError('Desired map did not match readback')
        record['full_base_readback_matches'] = read_region(h, 'base') == desired
        record['fn_unchanged'] = read_fn(h) == fn
        record['settings_unchanged'] = w.read_settings(h) == settings
        record['custom_rgb_unchanged'] = read_region(h, 'custom') == custom
        if not all(record[k] for k in ['full_base_readback_matches', 'fn_unchanged',
                                      'settings_unchanged', 'custom_rgb_unchanged']):
            raise RuntimeError('Post-write preservation check failed')
        print(json.dumps(record, indent=2), flush=True)
    except Exception as e:
        record['error'] = str(e)
        raise
    finally:
        h.close()
        Path(str(prefix) + '.json').write_text(json.dumps(record, indent=2) + '\n')

if __name__ == '__main__':
    main()
