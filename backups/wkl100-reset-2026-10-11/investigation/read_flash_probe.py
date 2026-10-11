import hid,time,json
from pathlib import Path
root=Path(r'C:\Users\Mahedi\Documents\K81-USB-Debug'); ds=hid.enumerate(0x258a,0x019d)
cmd=next(x for x in ds if x['usage_page']==0xff00 and x['usage']==1 and b'Col05' in x['path'])
xfer=next(x for x in ds if x['usage_page']==0xff00 and x['usage']==1 and b'Col06' in x['path'])
a,b=hid.device(),hid.device(); a.open_path(cmd['path']); b.open_path(xfer['path'])
log=[]
try:
 packet=bytes.fromhex('05 52 00 BC 00 00'); n=a.send_feature_report(packet); log.append({'api':'SET_FEATURE flash-read-address','hex':packet.hex(' '),'result':n}); time.sleep(.05)
 response=bytes(b.get_feature_report(6,2050)); log.append({'api':'GET_FEATURE flash-read','length':len(response),'hex':response.hex(' ')})
 print('Response length',len(response),'first bytes',response[:64].hex(' '))
 if len(response)>=514 and response[:2]==b'\x06\x72':
  (root/'base-keymap-read.bin').write_bytes(response[2:514]); print('Read keymap region successfully')
 finally_packet=bytes.fromhex('05 5A 00 00 00 00')
 # Reboot only after a confirmed ISP read response; do not send any erase/write/enable command.
 if response[:2]==b'\x06\x72':
  try: a.send_feature_report(finally_packet)
  except OSError as e: print('Reboot disconnected:',e)
finally:
 (root/'flash-read-attempt.json').write_text(json.dumps(log,indent=2)); a.close(); b.close()
