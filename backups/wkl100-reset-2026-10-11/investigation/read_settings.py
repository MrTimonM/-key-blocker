"""Read WKL-100 settings using the recovered OEM-driver query. No configuration writes."""
import datetime,json,time
from pathlib import Path
import hid
ROOT=Path(__file__).resolve().parent
VID,PID,USAGE_PAGE,USAGE,REPORT_ID,REPORT_LENGTH=0x258a,0x019d,0xff02,2,9,520

def read_settings():
 devices=[d for d in hid.enumerate(VID,PID) if d['usage_page']==USAGE_PAGE and d['usage']==USAGE]
 if len(devices)!=1: raise RuntimeError(f'Expected one 258A:019D FF02:02 collection, found {len(devices)}')
 packet=bytes.fromhex('09 84 00 00 01 00 80 00')+bytes(512)
 device=hid.device(); device.open_path(devices[0]['path'])
 log=[]
 def record(api,data,**extra):
  log.append({'time':datetime.datetime.now(datetime.timezone.utc).isoformat(),'api':api,'length':len(data),'hex':data.hex(' '),**extra})
  (ROOT/'read-settings.json').write_text(json.dumps(log,indent=2),encoding='utf-8')
 try:
  sent=device.send_feature_report(packet); record('SET_FEATURE settings-read request',packet,result=sent)
  if sent!=REPORT_LENGTH: raise RuntimeError(f'Unexpected request result: {sent}')
  time.sleep(.05)
  response=bytes(device.get_feature_report(REPORT_ID,REPORT_LENGTH))
  record('GET_FEATURE settings-read response',response)
  if response[:8]!=packet[:8]: raise RuntimeError('Response header does not match the request')
  if len(response)<136: raise RuntimeError(f'Settings response is short: {len(response)} bytes')
  (ROOT/'settings-response.bin').write_bytes(response)
  settings=response[8:136]; (ROOT/'settings.bin').write_bytes(settings)
  print(f'Confirmed {len(response)}-byte response; saved 128 settings bytes.')
  print('Request header:',packet[:8].hex(' '))
  print('Settings:',settings.hex(' '))
  return settings
 finally: device.close()

if __name__=='__main__': read_settings()
