import http from 'node:http';
import {readFile} from 'node:fs/promises';
const files=new Map([['/','index.html'],...['index.html','app.js','protocol.js','layout.js','style.css'].map(f=>['/'+f,f])]);
const port=Number(process.env.PORT || 8766);
http.createServer(async(req,res)=>{
  const file=files.get(new URL(req.url,'http://localhost').pathname);
  if(!file){res.writeHead(404);res.end('Not found');return;}
  try {
    const body=await readFile(new URL(file,import.meta.url));
    res.writeHead(200,{'Content-Type':file.endsWith('.js')?'text/javascript':file.endsWith('.css')?'text/css':'text/html','Cache-Control':'no-store','Content-Security-Policy':"default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; connect-src 'none'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'",'Permissions-Policy':'hid=(self)'});res.end(body);
  } catch {res.writeHead(500);res.end('Unable to load editor.');}
}).listen(port,'127.0.0.1',()=>console.log(`Color Studio: http://127.0.0.1:${port}`));
