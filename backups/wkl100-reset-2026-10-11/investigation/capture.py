import argparse,json,time,frida,threading
from pathlib import Path
p=argparse.ArgumentParser(description='Log OEM-driver HID feature report calls without changing their behavior.')
p.add_argument('--exe',default=r'C:\Program Files (x86)\LEOBOG\K81\OemDrv.exe'); p.add_argument('--pid',type=int); p.add_argument('--seconds',type=int,default=30); p.add_argument('--out',default='capture.jsonl'); p.add_argument('--close',action='store_true',help='Close only the process spawned by this logger at the end')
a=p.parse_args(); root=Path(__file__).resolve().parent; device=frida.get_local_device(); spawned=a.pid is None
pid=device.spawn([a.exe],cwd=str(Path(a.exe).parent)) if spawned else a.pid
session=device.attach(pid); out=Path(a.out); out=out if out.is_absolute() else root/out
lock=threading.Lock()
with out.open('w',encoding='utf-8') as f:
 def receive(m,data):
  record=m['payload'] if m.get('type')=='send' else m
  with lock: f.write(json.dumps(record)+'\n'); f.flush()
  if record.get('event') in ['transfer','debug'] or m.get('type')=='error': print(json.dumps(record),flush=True)
 script=session.create_script((root/'capture.js').read_text()); script.on('message',receive); script.load()
 if spawned: device.resume(pid)
 print(f'Capturing PID {pid} for {a.seconds} seconds to {out}',flush=True)
 try: time.sleep(a.seconds)
 except KeyboardInterrupt: pass
 finally:
  try: session.detach()
  except frida.InvalidOperationError: pass
  if spawned and a.close:
   try: device.kill(pid)
   except frida.ProcessNotFoundError: pass
