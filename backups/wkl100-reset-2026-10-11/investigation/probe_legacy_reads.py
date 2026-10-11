"""Probe ONLY read operations recovered from OemDrv and sinowisp.
No firmware-enable, erase, flash-write, keymap-write, or RGB-write commands.
"""
import hid, time, json, hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
devices = hid.enumerate(0x258a, 0x019d)
def select(collection):
    matches = [d for d in devices if d['usage_page'] == 0xff00
               and d['usage'] == 1 and collection in d['path']]
    if len(matches) != 1:
        raise RuntimeError(f'Expected one {collection!r} device, got {len(matches)}')
    return matches[0]

commands = hid.device()
transfer = hid.device()
events = []
try:
    commands.open_path(select(b'Col05')['path'])
    transfer.open_path(select(b'Col06')['path'])
    probes = [
        ('legacy-keymap', bytes.fromhex('05 84 D4 00 00 00 00'), 1032),
        ('legacy-settings', bytes.fromhex('05 83 B6 00 00 00 00'), 1032),
        ('isp-read-native-size', bytes.fromhex('05 52 00 BC 00 00'), 1032),
    ]
    for name, packet, size in probes:
        event = {'name': name, 'request_hex': packet.hex(' '), 'requested_length': size}
        events.append(event)
        try:
            event['send_result'] = commands.send_feature_report(packet)
            time.sleep(.1)
            response = bytes(transfer.get_feature_report(6, size))
            event.update(length=len(response), response_hex=response.hex(' '),
                         sha256=hashlib.sha256(response).hexdigest())
            (ROOT / f'{name}-response.bin').write_bytes(response)
            print(name, 'send', event['send_result'], 'received', len(response),
                  'head', response[:32].hex(' '), flush=True)
        except Exception as exc:
            event['error'] = repr(exc)
            print(name, event['error'], flush=True)
        finally:
            (ROOT / 'legacy-read-probes.json').write_text(json.dumps(events, indent=2))
finally:
    commands.close()
    transfer.close()
