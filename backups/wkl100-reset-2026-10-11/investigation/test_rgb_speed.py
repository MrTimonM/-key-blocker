from pathlib import Path
import time,json
import wkl_control as w
ROOT=Path(__file__).resolve().parent
h=w.open_device();before=None;events=[]
try:
 before=w.read_settings(h);(ROOT/'rgb-speed-test-backup.bin').write_bytes(before)
 for speed in [1,5,1,5]:
  state=bytearray(before);state[10]=3;state[0x38+2*3+1]=(state[0x38+2*3+1]&15)|(speed<<4)
  w.send(h,bytes.fromhex('09 04 00 00 01 00 80 00')+state+bytes(384))
  if w.read_settings(h)!=state:raise RuntimeError('Speed settings mismatch')
  events.append({'speed':speed,'readback_matches':True});print('SLOW' if speed==1 else 'FAST',flush=True);time.sleep(12)
finally:
 if before is not None:
  w.send(h,bytes.fromhex('09 04 00 00 01 00 80 00')+before+bytes(384));restored=w.read_settings(h)==before;events.append({'restored':restored});print('RESTORED custom mode and original settings:',restored,flush=True)
 h.close();(ROOT/'rgb-speed-test.json').write_text(json.dumps({'events':events,'physical_observation':'pending'},indent=2)+'\n')
