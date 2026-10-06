import {hex,bytesOf,describeCollections,reportSummary,appendBounded} from './model.js';
const $ = id => document.getElementById(id);
let connected = [];
let busy = false;
const snapshots = [];
const keys = [], reports = [];
let totalKeys = 0, totalReports = 0;
const started = new Date().toISOString();
const status = message => { $('status').textContent = message; };
const supported = window.isSecureContext && 'hid' in navigator;
$('connect').disabled = !supported;
status(supported ? 'Ready. Close Phantom Editor, select wired mode, then connect.' : 'WebHID is unavailable here. Open this localhost page in desktop Chrome or Edge.');
function renderDevices() {
  $('devices').replaceChildren();
  $('devices').className = connected.length ? '' : 'empty';
  if (!connected.length) $('devices').textContent = 'No open interfaces. Previous descriptors remain available in the export.';
  for (const {snapshot} of connected) {
    const div = document.createElement('div'); div.className = 'device';
    const title = document.createElement('strong'); title.textContent = snapshot.productName || 'Unnamed HID interface'; div.append(title);
    const label = document.createElement('code'); label.textContent = `${hex(snapshot.vendorId,4)}:${hex(snapshot.productId,4)} · interface ${snapshot.sessionInterface}`; div.append(label);
    const table = document.createElement('table');
    const head = document.createElement('tr');
    for (const text of ['Type','Report ID','Bytes*','Usage pages']) {const th=document.createElement('th');th.textContent=text;head.append(th);} table.append(head);
    for (const r of reportSummary(snapshot.collections)) {
      const row=document.createElement('tr');
      for (const text of [r.kind,hex(r.reportId),r.bytes,r.pages.map(p=>hex(p,4)).join(', ')]) {const td=document.createElement('td');td.textContent=text;row.append(td);} table.append(row);
    }
    div.append(table);
    const note=document.createElement('p');note.className='muted';note.textContent='* Derived from exposed descriptor fields; excludes the report-ID byte. Interface number above is a session label, not a USB interface number.';div.append(note);
    $('devices').append(div);
  }
  $('descriptors').textContent=JSON.stringify(snapshots,null,2);
  $('disconnect').disabled=!connected.length || busy;
}
function renderLogs() {
  $('key-count').textContent=`${totalKeys} key events`;
  $('report-count').textContent=`${totalReports} raw reports`;
  $('key-log').textContent=keys.slice(-40).reverse().map(k=>`${k.time.slice(11,23)} ${k.type} ${k.code} key=${JSON.stringify(k.key)}${k.repeat?' REPEAT':''} physical=${JSON.stringify(k.physicalLabel)}`).join('\n') || 'Waiting for a capture…';
  $('report-log').textContent=reports.slice(-30).reverse().map(r=>`${r.time.slice(11,23)} interface=${r.sessionInterface} report=${hex(r.reportId)} ${r.byteLength} bytes\n${r.hex}`).join('\n') || 'Waiting for a vendor input report…';
}
setInterval(renderLogs,250);
$('connect').onclick=async()=>{
  if(busy)return;busy=true;$('connect').disabled=true;
  try {
    const devices=await navigator.hid.requestDevice({filters:[{vendorId:0x258a,productId:0x019d}]});
    if(!devices.length){status('No device selected. No configuration changed.');return;}
    let failed=0;
    for(const device of devices){
      if(connected.some(e=>e.device===device))continue;
      try{
        if(!device.opened)await device.open();
        const snapshot={sessionInterface:snapshots.length+1,productName:device.productName,vendorId:device.vendorId,productId:device.productId,connectedAt:new Date().toISOString(),collections:describeCollections(device.collections)};
        const listener=event=>{
          const bytes=bytesOf(event.data);totalReports++;
          appendBounded(reports,{time:new Date().toISOString(),sessionInterface:snapshot.sessionInterface,reportId:event.reportId,byteLength:bytes.length,bytes,hex:bytes.map(b=>b.toString(16).padStart(2,'0')).join(' ')});
        };
        device.addEventListener('inputreport',listener);
        connected.push({device,snapshot,listener});snapshots.push(snapshot);
      }catch(error){failed++;status(`An interface could not open: ${error.message}`);}
    }
    status(`${connected.length} interface(s) open.${failed?` ${failed} could not open; close other keyboard tools and retry.`:''} No keymap commands sent.`);
  }catch(error){status(`Connection not completed: ${error.message}`);}
  finally{busy=false;$('connect').disabled=!supported;renderDevices();}
};
$('disconnect').onclick=async()=>{
  if(busy)return;busy=true;$('connect').disabled=true;$('disconnect').disabled=true;
  const closing=connected;connected=[];
  let failed=0;
  for(const entry of closing){entry.device.removeEventListener('inputreport',entry.listener);try{await entry.device.close();}catch{failed++;}}
  busy=false;$('connect').disabled=!supported;renderDevices();status(failed?'Listeners stopped; an interface could not close. Unplug the keyboard to release it.':'Disconnected. Capture remains available for export.');
};
if(supported)navigator.hid.addEventListener('disconnect',event=>{
  const entry=connected.find(e=>e.device===event.device);if(!entry)return;
  entry.device.removeEventListener('inputreport',entry.listener);entry.snapshot.disconnectedAt=new Date().toISOString();
  connected=connected.filter(e=>e!==entry);renderDevices();status('Keyboard disconnected. Reconnect using the button when ready.');
});
for(const type of ['keydown','keyup'])$('pad').addEventListener(type,event=>{
  // Keep Tab available to leave the pad; do not trap keyboard navigation.
  if(event.key==='Tab')return;
  event.preventDefault();
  const entry={time:new Date().toISOString(),type,physicalLabel:$('physical').value.trim(),key:event.key,code:event.code,location:event.location,repeat:event.repeat,modifiers:{ctrl:event.ctrlKey,alt:event.altKey,shift:event.shiftKey,meta:event.metaKey},source:'DOM; keyboard identity unknown'};
  totalKeys++;appendBounded(keys,entry);$('last-key').textContent=`${entry.code} → ${JSON.stringify(entry.key)}${entry.repeat?' (repeat)':''}`;
});
$('clear').onclick=()=>{keys.length=0;reports.length=0;totalKeys=0;totalReports=0;$('last-key').textContent='No key captured yet.';renderLogs();status('Event capture cleared. Descriptors and notes retained.');};
$('export').onclick=()=>{
  const evidence={schemaVersion:1,started,exportedAt:new Date().toISOString(),mode:'read-only',notes:$('notes').value,devices:snapshots,keyEvents:keys,inputReports:reports,totals:{keyEvents:totalKeys,inputReports:totalReports},retentionLimitPerStream:500,limitations:['No firmware or stored-keymap readback.','DOM events are translated by the OS and have no keyboard identity.','Standard keyboard HID reports may be protected by the browser.','No output reports or feature-report requests were sent.']};
  const url=URL.createObjectURL(new Blob([JSON.stringify(evidence,null,2)],{type:'application/json'}));
  const a=document.createElement('a');a.href=url;a.download=`keyboard-evidence-${Date.now()}.json`;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);status('Evidence exported. Share this JSON to analyze the report definitions and observed key mapping.');
};
