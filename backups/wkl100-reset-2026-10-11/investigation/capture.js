const handles = new Map();
function emit(x) { send(Object.assign({time: new Date().toISOString()}, x)); }
function hex(p,n) { if(p.isNull() || n<0 || n>65536) return null; return Array.from(new Uint8Array(p.readByteArray(n)), b=>b.toString(16).padStart(2,'0')).join(' '); }
function hook(name,cb) { const p=Module.findGlobalExportByName(name); if(p) { Interceptor.attach(p,cb); emit({event:'hook',api:name,address:p.toString()}); } else emit({event:'missing',api:name}); }
for(const wide of [true,false]) hook(wide?'CreateFileW':'CreateFileA',{
 onEnter(a){try {this.path=wide?a[0].readUtf16String():a[0].readCString(); this.hid=/hid#/i.test(this.path);}catch(e){}},
 onLeave(r){if(this.hid && !r.equals(ptr(-1))) {handles.set(r.toString(),this.path); emit({event:'open',handle:r.toString(),path:this.path});}}
});
hook('CloseHandle',{onEnter(a){handles.delete(a[0].toString());}});
for(const name of ['HidD_SetFeature','HidD_GetFeature','HidD_SetOutputReport']) hook(name,{
 onEnter(a){this.handle=a[0].toString(); this.path=handles.get(this.handle); this.buf=a[1]; this.len=a[2].toUInt32(); this.before=hex(this.buf,this.len); this.caller=this.returnAddress.toString();},
 onLeave(r){emit({event:'transfer',api:name,handle:this.handle,path:this.path,length:this.len,before:this.before,after: name==='HidD_GetFeature' && r.toInt32() ? hex(this.buf,this.len):null,success:r.toInt32()!==0,error:r.toInt32()?0:this.lastError,caller:this.caller});}
});
for(const name of ['OutputDebugStringA','OutputDebugStringW']) hook(name,{onEnter(a){try{emit({event:'debug',text:name.endsWith('W')?a[0].readUtf16String():a[0].readCString()});}catch(e){}}});
hook('HidP_GetCaps',{onEnter(a){this.buf=a[1];},onLeave(r){if(r.toInt32()>=0)emit({event:'caps',usage:this.buf.readU16(),usagePage:this.buf.add(2).readU16(),inputLength:this.buf.add(4).readU16(),outputLength:this.buf.add(6).readU16(),featureLength:this.buf.add(8).readU16()});}});
