"""Controlled WKL-100 custom lighting edit, with live backups and readback.
Device-specific: 258A:019D WKL-100, inspected firmware and recovered matrix.
No ISP, reboot, reconnect, keymap write, or settings write.
"""
import argparse, json, time, hashlib
from pathlib import Path
import wkl_control as w
ROOT=Path(__file__).resolve().parent
SLOTS={'Y':38,'U':44,'I':50,'O':56,'G':33,'F':27,'V':28,'B':34}

def query(h,header):
 w.send(h,header+bytes(512))
 d=bytes(h.get_feature_report(9,520));w.log('GET_FEATURE',d)
 if len(d)!=263 or d[:8]!=header:raise RuntimeError('Unexpected CODE read response')
 return d[8:]

def read_region(h,kind='custom'):
 # Own firmware 6C52: page*2+DC, modulo 256, selects AC00 at page 68.
 first=bytes.fromhex('09 85 00 00 01 68 ff 00') if kind=='custom' else bytes.fromhex('09 83 00 00 01 00 ff 00')
 a=query(h,first)
 # Own firmware 6C1C: selector 4 keeps the saved CODE pointer.
 # 9EBC advances it for 31 eight-byte packets, not the final seven bytes.
 b=query(h,bytes.fromhex('09 83 04 00 01 00 ff 00'))
 c=query(h,bytes.fromhex('09 83 04 00 01 00 ff 00'))
 if a[-7:]!=b[:7] or b[-7:]!=c[:7]:raise RuntimeError('Continuation overlap differs')
 data=a+b[7:]+c[7:16]
 if len(data)!=512:raise RuntimeError('Invalid full region size')
 return data

def write_custom(h,data):
 if len(data)!=512:raise RuntimeError('Invalid custom backup')
 # Own command 06 handler 7393 copies 378 bytes to AC00 and preserves AD7A-ADFF.
 packet=bytes.fromhex('09 06 00 00 01 00 7a 01')+data[:378]+bytes(134)
 w.send(h,packet);time.sleep(.5)

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('command',choices=['apply','restore','read']);args=p.parse_args()
 h=w.open_device()
 try:
  settings=w.read_settings(h)
  if settings[10]!=19:raise RuntimeError('Keyboard must already be in custom effect 19')
  before=read_region(h)
  if before!=read_region(h):raise RuntimeError('Repeated custom reads differ')
  base=read_region(h,'base')
  for key,slot in SLOTS.items():
   if base[4*slot:4*slot+4]!=bytes([0,0,0,ord(key)-65+4]):raise RuntimeError('Current matrix differs for '+key)
  if args.command=='read':print('Custom table read twice; stable.');return
  if args.command=='restore':
   desired=(ROOT/'custom-eight-keys-backup.bin').read_bytes()
  else:
   (ROOT/'custom-eight-keys-backup.bin').write_bytes(before)
   (ROOT/'custom-eight-keys-settings-backup.bin').write_bytes(settings)
   (ROOT/'custom-eight-keys-base-backup.bin').write_bytes(base)
   desired=bytearray(before)
   for key,slot in SLOTS.items():
    rgb=(255,0,0) if key in 'YUIO' else (0,255,0)
    for channel,value in enumerate(rgb):desired[channel*126+slot]=value
   desired=bytes(desired)
  changed=[i for i,(x,y) in enumerate(zip(before,desired)) if x!=y]
  allowed={126*c+slot for c in range(3) for slot in SLOTS.values()}
  if args.command=='apply' and not set(changed)<=allowed:raise RuntimeError('Unexpected offline diff')
  (ROOT/'custom-eight-keys-desired.bin').write_bytes(desired)
  write_custom(h,desired)
  actual=read_region(h)
  (ROOT/'custom-eight-keys-readback.bin').write_bytes(actual)
  if actual!=desired:
   write_custom(h,before)
   if read_region(h)!=before:raise RuntimeError('Readback mismatch; restoration also mismatched')
   raise RuntimeError('Readback mismatch; original custom table restored')
  if w.read_settings(h)!=settings:raise RuntimeError('Settings changed unexpectedly')
  if read_region(h,'base')!=base:raise RuntimeError('Base map changed unexpectedly')
  evidence={'command':args.command,'slots':SLOTS,'requested_colors':{k:('red' if k in 'YUIO' else 'green') for k in SLOTS},'changed_offsets':changed,'before_sha256':hashlib.sha256(before).hexdigest(),'after_sha256':hashlib.sha256(actual).hexdigest(),'full_512_byte_readback_matches':True,'settings_unchanged':True,'base_map_unchanged':True,'physical_verification':'pending'}
  (ROOT/('custom-eight-keys-'+args.command+'.json')).write_text(json.dumps(evidence,indent=2)+'\n',encoding='utf8')
  print(json.dumps(evidence,indent=2))
 finally:h.close()
if __name__=='__main__':main()
