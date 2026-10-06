import {hex,describeCollections,reportSummary,appendBounded} from './model.js';
const $ = id => document.getElementById(id);
let connected = [];
let busy = false;
const snapshots = [];
const keys = [];
let totalKeys = 0;
const started = new Date().toISOString();
const status = message => { $('status').textContent = message; };
const supported = window.isSecureContext && !!navigator.hid;
$('connect').disabled = !supported;
status(supported ? 'Descriptor-only mode. Select a USB device to inspect browser-provided metadata. Key capture below needs no connection.' : 'WebHID is unavailable here. Open this localhost page in desktop Chrome or Edge.');
function renderDevices() {
  $('devices').replaceChildren();
  $('devices').className = connected.length ? '' : 'empty';
  if (!connected.length) $('devices').textContent = 'No device selected. Previous descriptors remain available in the export.';
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
  $('key-log').textContent=keys.slice(-40).reverse().map(k=>`${k.time.slice(11,23)} ${k.type} ${k.code} key=${JSON.stringify(k.key)}${k.repeat?' REPEAT':''} physical=${JSON.stringify(k.physicalLabel)}`).join('\n') || 'Waiting for a capture…';
}
setInterval(renderLogs,250);
$('connect').onclick=async()=>{
  if(busy)return;busy=true;$('connect').disabled=true;
  try {
    const devices=await navigator.hid.requestDevice({filters:[{vendorId:0x258a,productId:0x019d}]});
    if(!devices.length){status('No device selected. No configuration changed.');return;}
    for(const device of devices){
      if(connected.some(e=>e.device===device))continue;
      // Metadata is available after permission; deliberately never open the device.
      const snapshot={sessionInterface:snapshots.length+1,productName:device.productName,vendorId:device.vendorId,productId:device.productId,selectedAt:new Date().toISOString(),collections:describeCollections(device.collections)};
      connected.push({device,snapshot});snapshots.push(snapshot);
    }
    status(`${connected.length} interface descriptor(s) inspected. No HID interface opened; no reports requested or subscribed to.`);
  }catch(error){status(`Connection not completed: ${error.message}`);}
  finally{busy=false;$('connect').disabled=!supported;renderDevices();}
};
$('disconnect').onclick=()=>{
  connected=[];renderDevices();status('Selection cleared. Export still includes inspected descriptors. Browser permission has not been revoked.');
};
if(supported)navigator.hid.addEventListener('disconnect',event=>{
  const entry=connected.find(e=>e.device===event.device);if(!entry)return;
  entry.snapshot.disconnectedAt=new Date().toISOString();
  connected=connected.filter(e=>e!==entry);renderDevices();status('Keyboard unplugged. Existing descriptors remain available for export.');
});
for(const type of ['keydown','keyup'])$('pad').addEventListener(type,event=>{
  // Keep Tab available to leave the pad; do not trap keyboard navigation.
  if(event.key==='Tab')return;
  event.preventDefault();
  const entry={time:new Date().toISOString(),type,physicalLabel:$('physical').value.trim(),key:event.key,code:event.code,location:event.location,repeat:event.repeat,modifiers:{ctrl:event.ctrlKey,alt:event.altKey,shift:event.shiftKey,meta:event.metaKey},source:'DOM; keyboard identity unknown'};
  totalKeys++;appendBounded(keys,entry);$('last-key').textContent=`${entry.code} → ${JSON.stringify(entry.key)}${entry.repeat?' (repeat)':''}`;
});
$('clear').onclick=()=>{keys.length=0;totalKeys=0;$('last-key').textContent='No key captured yet.';renderLogs();status('Event capture cleared. Descriptors and notes retained.');};
$('export').onclick=()=>{
  const evidence={schemaVersion:2,started,exportedAt:new Date().toISOString(),mode:'descriptor-only',notes:$('notes').value,devices:snapshots,keyEvents:keys,inputReports:[],totals:{keyEvents:totalKeys,inputReports:0},retentionLimitPerStream:500,limitations:['No firmware or stored-keymap readback.','DOM events are translated by the OS and have no keyboard identity.','Standard keyboard HID reports may be protected by the browser.','No HID interfaces opened; no input-report subscriptions, output reports or feature-report requests.']};
  const url=URL.createObjectURL(new Blob([JSON.stringify(evidence,null,2)],{type:'application/json'}));
  const a=document.createElement('a');a.href=url;a.download=`keyboard-evidence-${Date.now()}.json`;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);status('Evidence exported. Share this JSON to analyze the report definitions and observed key mapping.');
};
