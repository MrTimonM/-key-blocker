import hid, json,time,datetime
from pathlib import Path
root=Path(r'C:\Users\Mahedi\Documents\K81-USB-Debug')
dev=next(d for d in hid.enumerate(0x258a,0x019d) if d['usage_page']==0xff02 and d['usage']==2)
h=hid.device(); h.open_path(dev['path'])
packet=bytes.fromhex('09 88 00 00 01 00 00 02')+bytes(512)
try:
 ret=h.send_feature_report(packet); time.sleep(.05); response=bytes(h.get_feature_report(9,520))
 log=[{'time':datetime.datetime.now(datetime.timezone.utc).isoformat(),'api':'SET_FEATURE read-data request','length':len(packet),'hex':packet.hex(' '),'result':ret},{'time':datetime.datetime.now(datetime.timezone.utc).isoformat(),'api':'GET_FEATURE read-data response','length':len(response),'hex':response.hex(' ')}]
 (root/'read-data.json').write_text(json.dumps(log,indent=2)); (root/'data-response.bin').write_bytes(response)
 print('request:',packet[:8].hex(' '),'sent:',ret,'response length:',len(response),'header:',response[:8].hex(' '),'first payload bytes:',response[8:88].hex(' '))
finally: h.close()
