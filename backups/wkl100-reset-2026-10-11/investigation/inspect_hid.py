import ctypes as c, ctypes.wintypes as w, hid, json
from pathlib import Path
k=c.WinDLL('kernel32',use_last_error=True); h=c.WinDLL('hid',use_last_error=True)
k.CreateFileW.argtypes=[w.LPCWSTR,w.DWORD,w.DWORD,c.c_void_p,w.DWORD,w.DWORD,w.HANDLE]; k.CreateFileW.restype=w.HANDLE
k.CloseHandle.argtypes=[w.HANDLE]
h.HidD_GetPreparsedData.argtypes=[w.HANDLE,c.POINTER(c.c_void_p)]; h.HidD_FreePreparsedData.argtypes=[c.c_void_p]
h.HidP_GetCaps.argtypes=[c.c_void_p,c.c_void_p]; h.HidP_GetCaps.restype=c.c_long
class Caps(c.Structure):
 _fields_=[('Usage',w.USHORT),('UsagePage',w.USHORT),('InputReportByteLength',w.USHORT),('OutputReportByteLength',w.USHORT),('FeatureReportByteLength',w.USHORT),('Reserved',w.USHORT*17)]+[(n,w.USHORT) for n in ['NumberLinkCollectionNodes','NumberInputButtonCaps','NumberInputValueCaps','NumberInputDataIndices','NumberOutputButtonCaps','NumberOutputValueCaps','NumberOutputDataIndices','NumberFeatureButtonCaps','NumberFeatureValueCaps','NumberFeatureDataIndices']]
out=[]
for dev in hid.enumerate(0x258a,0x019d):
 dev['path']=dev['path'].decode(); fh=k.CreateFileW(dev['path'],0,3,None,3,0,None)
 if fh==c.c_void_p(-1).value: dev['error']=c.get_last_error()
 else:
  pp=c.c_void_p()
  if h.HidD_GetPreparsedData(fh,c.byref(pp)):
   caps=Caps(); status=h.HidP_GetCaps(pp,c.byref(caps)); dev['caps']={n:getattr(caps,n) for n,_ in caps._fields_ if n!='Reserved'}
   dev['status']=hex(status&0xffffffff)
   for typ,count in [(0,caps.NumberInputValueCaps),(1,caps.NumberOutputValueCaps),(2,caps.NumberFeatureValueCaps)]:
    if count:
     buf=(c.c_ubyte*(72*count))(); length=w.USHORT(count)
     h.HidP_GetValueCaps.argtypes=[c.c_int,c.c_void_p,c.POINTER(w.USHORT),c.c_void_p]; h.HidP_GetValueCaps.restype=c.c_long
     ret=h.HidP_GetValueCaps(typ,buf,c.byref(length),pp)
     dev[['input','output','feature'][typ]+'_value_caps']=[{'usage_page':hex(int.from_bytes(bytes(buf)[i*72:i*72+2],'little')),'report_id':buf[i*72+2],'bit_size':int.from_bytes(bytes(buf)[i*72+18:i*72+20],'little'),'report_count':int.from_bytes(bytes(buf)[i*72+20:i*72+22],'little'),'raw':bytes(buf)[i*72:(i+1)*72].hex()} for i in range(length.value)] if ret>=0 else {'error':hex(ret&0xffffffff)}
   h.HidD_FreePreparsedData(pp)
  k.CloseHandle(fh)
 out.append(dev)
p=Path(r'C:\Users\Mahedi\Documents\K81-USB-Debug\device-caps.json'); p.write_text(json.dumps(out,indent=2))
for d in out:
 print(hex(d['usage_page']),hex(d['usage']),d.get('caps'),{key:d[key] for key in d if key.endswith('value_caps')})
