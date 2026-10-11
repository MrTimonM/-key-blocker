"""WKL-100 validated RGB control. The own-device keymap is now recovered; the controlled 8->9 test is in test_own_map_8_to_9.py. General remapping remains disabled here."""
import argparse,datetime,json,time
from pathlib import Path
import hid
ROOT=Path(__file__).resolve().parent
VID,PID,UP,USAGE=0x258a,0x019d,0xff02,2
REFERENCE=ROOT/'reference-base-layer.bin'
ACTIVE=ROOT/'active-base-layer.bin'

def open_device():
 ds=[d for d in hid.enumerate(VID,PID) if d['usage_page']==UP and d['usage']==USAGE]
 if len(ds)!=1: raise RuntimeError(f'Expected one WKL-100 control collection, found {len(ds)}')
 if ds[0]['product_string']!='WKL-100': raise RuntimeError('Product name differs from the tested WKL-100')
 h=hid.device(); h.open_path(ds[0]['path']); return h

def log(api,packet,**extra):
 with (ROOT/'control-history.jsonl').open('a',encoding='utf8') as f:
  f.write(json.dumps({'time':datetime.datetime.now(datetime.timezone.utc).isoformat(),'api':api,'length':len(packet),'hex':packet.hex(' '),**extra})+'\n')

def send(h,packet):
 if len(packet)!=520 or packet[0]!=9: raise ValueError('Expected report 09 with exactly 520 bytes')
 n=h.send_feature_report(packet); log('SET_FEATURE',packet,result=n)
 if n!=520: raise RuntimeError(f'Short feature write: {n}')
 time.sleep(.15)

def read_settings(h):
 header=bytes.fromhex('09 84 00 00 01 00 80 00'); send(h,header+bytes(512))
 response=bytes(h.get_feature_report(9,520)); log('GET_FEATURE',response)
 if response[:8]!=header or len(response)<136: raise RuntimeError('Settings response did not match expected header/length')
 return response[8:136]

def write_base(h,data):
 if len(data)!=512: raise ValueError('Expected 512-byte base layer')
 send(h,bytes.fromhex('09 03 00 00 00 00 00 00')+data)
 ACTIVE.write_bytes(data)

# Normal keyboard-page HID usages. Physical slots come from the reference base map.
CODES={str(i):0x1e+i-1 for i in range(1,10)}; CODES['0']=0x27
CODES.update({chr(97+i):4+i for i in range(26)})
CODES.update({f'f{i}':0x39+i for i in range(1,13)})
CODES.update({'enter':0x28,'escape':0x29,'backspace':0x2a,'tab':0x2b,'space':0x2c,'delete':0x4c,'insert':0x49,'home':0x4a,'end':0x4d,'pageup':0x4b,'pagedown':0x4e,'right':0x4f,'left':0x50,'down':0x51,'up':0x52})

def remap(h,source,target):
 ref=REFERENCE.read_bytes(); current=bytearray(ACTIVE.read_bytes())
 if len(ref)!=512 or len(current)!=512: raise RuntimeError('Invalid base-layer file')
 try: src=CODES[source.lower()]; dst=CODES[target.lower()]
 except KeyError as e: raise ValueError(f'Unknown key: {e.args[0]}')
 slots=[i for i in range(113) if ref[i*4:i*4+4]==bytes([0,0,0,src])]
 if len(slots)!=1: raise RuntimeError(f'Expected unique physical slot for {source}, found {slots}')
 slot=slots[0]; before=bytes(current[slot*4:slot*4+4]); current[slot*4:slot*4+4]=bytes([0,0,0,dst])
 write_base(h,bytes(current)); print(f'Sent hardware remap {source} -> {target}, physical slot {slot}; prior action {before.hex(" ")}.')
 print('Press the physical source key in a text field to verify.')

def main():
 parser=argparse.ArgumentParser(description=__doc__); sub=parser.add_subparsers(dest='command',required=True)
 p=sub.add_parser('remap',help='Disabled until a device-specific base map is available'); p.add_argument('source'); p.add_argument('target')
 sub.add_parser('restore-keymap',help='Disabled: reference factory map differs from this keyboard')
 sub.add_parser('read-settings')
 p=sub.add_parser('rgb-effect',help='Change the hardware RGB effect; modes 3 and 11 have been observed on this device'); p.add_argument('effect',type=int,choices=[3,11])
 sub.add_parser('restore-rgb',help='Restore the settings saved before the most recent RGB command')
 args=parser.parse_args(); h=open_device()
 try:
  if args.command=='remap': raise RuntimeError('The actual keymap is recovered. Use the controlled own-device test in test_own_map_8_to_9.py; this older reference-map remapper remains disabled.')
  elif args.command=='restore-keymap': raise RuntimeError('Reference restore disabled: use the keyboard factory reset to restore its actual layout.')
  elif args.command=='read-settings': print(read_settings(h).hex(' '))
  elif args.command=='rgb-effect':
   before=read_settings(h); (ROOT/'rgb-write-backup.bin').write_bytes(before)
   after=bytearray(before); after[10]=args.effect
   (ROOT/'rgb-pending-settings.bin').write_bytes(after)
   send(h,bytes.fromhex('09 04 00 00 01 00 80 00')+bytes(after)+bytes(384))
   actual=read_settings(h)
   (ROOT/'rgb-write-readback.bin').write_bytes(actual)
   changed=[i for i,(x,y) in enumerate(zip(before,actual)) if x!=y]
   if actual!=bytes(after): raise RuntimeError(f'RGB write readback mismatch; changed settings offsets: {changed}')
   print(f'RGB effect {before[10]} -> {args.effect}; verified readback; changed offsets: {changed}')
  elif args.command=='restore-rgb':
   backup=(ROOT/'rgb-write-backup.bin').read_bytes()
   if len(backup)!=128: raise RuntimeError('Invalid RGB settings backup')
   send(h,bytes.fromhex('09 04 00 00 01 00 80 00')+backup+bytes(384))
   if read_settings(h)!=backup: raise RuntimeError('RGB restoration readback mismatch')
   print(f'Restored RGB settings, effect {backup[10]}; verified readback.')
 finally: h.close()

if __name__=='__main__': main()
