raise SystemExit('Disabled: the reference keymap shifted other keys. Use this keyboard\'s own keymap before another remap test.')
import re,json,hid,time,hashlib
from pathlib import Path
root=Path(r'C:\Users\Mahedi\Documents\K81-USB-Debug')
s=(root/'phantom-keymap-defaults.js').read_text(encoding='utf8'); block=s.split('const FACTORY_BASE = [',1)[1].split('];',1)[0]
actions=[bytes(int(v,16) for v in re.findall(r'0x([0-9A-Fa-f]+)',entry)) for entry in re.findall(r'\[([^\[\]]+)\]',block)]
assert len(actions)==113 and all(len(x)==4 for x in actions)
assert actions[49]==bytes.fromhex('00 00 00 25') and actions[55]==bytes.fromhex('00 00 00 26')
base=b''.join(actions)+bytes(512-113*4); modified=bytearray(base); modified[49*4+3]=0x26
original=bytes.fromhex('09 03 00 00 00 00 00 00')+base
packet=bytes.fromhex('09 03 00 00 00 00 00 00')+modified
(root/'reference-base-layer.bin').write_bytes(base); (root/'restore-reference-base-report.bin').write_bytes(original); (root/'remap-8-to-9-report.bin').write_bytes(packet)
changes=[i for i,(a,b) in enumerate(zip(original,packet)) if a!=b]; assert changes==[207]
print('Reference map:',len(actions),'slots; report length:',len(packet),'changed offset:',changes,'old/new:',hex(original[207]),hex(packet[207]),flush=True)
devs=[d for d in hid.enumerate(0x258a,0x019d) if d['usage_page']==0xff02 and d['usage']==2]; assert len(devs)==1
h=hid.device(); h.open_path(devs[0]['path'])
log={'source':'https://sfphantom.notjustanna.net/protocol.js','referenceMapSource':'https://sfphantom.notjustanna.net/keymap-defaults.js','api':'SET_FEATURE','device':devs[0]['product_string'],'length':len(packet),'hex':packet.hex(' '),'changedSlot':49,'changedByteOffset':207,'from':'8','to':'9','note':'Reference factory base layer from matching VID/PID project; not a device-read backup.'}
try:
 result=h.send_feature_report(packet); log['result']=result; print('SET_FEATURE result:',result,flush=True); time.sleep(.3)
 try:
  response=bytes(h.get_feature_report(9,520)); log['responseLength']=len(response); log['responseHex']=response.hex(' '); print('Reply:',len(response),response[:32].hex(' '),flush=True)
 except OSError as e: log['responseError']=str(e); print('Response error:',e,flush=True)
finally: h.close(); (root/'remap-test.json').write_text(json.dumps(log,indent=2))
