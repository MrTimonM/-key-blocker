import http from 'node:http';
import {readFile} from 'node:fs/promises';
const allowed=new Map([['/','index.html'],['/index.html','index.html'],['/app.js','app.js'],['/model.js','model.js'],['/style.css','style.css']]);
http.createServer(async(req,res)=>{
  const file=allowed.get(new URL(req.url,'http://localhost').pathname);
  if(!file){res.writeHead(404);res.end('Not found');return;}
  try{const body=await readFile(new URL(file,import.meta.url));res.writeHead(200,{'Content-Type':file.endsWith('.js')?'text/javascript':file.endsWith('.css')?'text/css':'text/html','Cache-Control':'no-store','Content-Security-Policy':"default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'none'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'"});res.end(body);}catch{res.writeHead(500);res.end('Unable to load file');}
}).listen(8765,'127.0.0.1',()=>console.log('Keyboard inspector: http://127.0.0.1:8765'));
