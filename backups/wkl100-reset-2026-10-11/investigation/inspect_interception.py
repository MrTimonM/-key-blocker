"""Read Interception hardware-ID slots only. No filters, hooks, input, or USB writes."""
import ctypes as c,json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
path=Path(r'C:\Users\Mahedi\AppData\Local\KeyboardBracketBlocker\Lib\x64\interception.dll')
dll=c.CDLL(str(path))
dll.interception_create_context.restype=c.c_void_p
dll.interception_destroy_context.argtypes=[c.c_void_p]
dll.interception_get_hardware_id.argtypes=[c.c_void_p,c.c_int,c.c_void_p,c.c_uint]
dll.interception_get_hardware_id.restype=c.c_uint
context=dll.interception_create_context()
if not context:raise RuntimeError('Could not create diagnostic Interception context')
rows=[]
try:
    for device in range(1,21):
        buffer=c.create_unicode_buffer(1024)
        length=dll.interception_get_hardware_id(context,device,buffer,c.sizeof(buffer))
        row={'id':device,'kind':'keyboard' if device<=10 else 'mouse','length':length,
             'hardware_id':buffer.value}
        rows.append(row)
        if length:print(json.dumps(row),flush=True)
finally:dll.interception_destroy_context(context)
(ROOT/'interception-device-table.json').write_text(json.dumps(rows,indent=2))
