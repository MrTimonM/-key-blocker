import {Keyboard,ID,equal,getColor,setColor} from './protocol.js';
import {ROWS,KEYS} from './layout.js';
const $=id=>document.getElementById(id);
const STORAGE='wkl100-color-studio-backup-v1';
let keyboard=null,snapshot=null,draft=null,selected=new Set(),anchor=null,busy=false,demo=false;
const keyButtons=new Map();
const palette=['#ff0000','#ff8a00','#ffd400','#00ff00','#00c9c9','#2389ff','#a966ff','#ff66b3','#ffffff','#000000'];
function message(text,type=''){ $('status').textContent=text;$('status').className='status '+type; }
function validBytes(value,length){return Array.isArray(value)&&value.length===length&&value.every(n=>Number.isInteger(n)&&n>=0&&n<=255);}
function validateBackup(value){
  if(value?.schema!==1 || value?.device!=='258A:019D WKL-100' || !validBytes(value.custom,512) || !validBytes(value.settings,128))
    throw new Error('This is not a valid WKL-100 lighting backup.');
  return {custom:Uint8Array.from(value.custom),settings:Uint8Array.from(value.settings)};
}
function savedBackup(){try {const json=localStorage.getItem(STORAGE);return json?validateBackup(JSON.parse(json)):null;}catch{return null;}}
function backup(current){
  const value={schema:1,device:'258A:019D WKL-100',savedAt:new Date().toISOString(),custom:[...current.custom],settings:[...current.settings]};
  // A storage failure aborts the save before sending any lighting write.
  localStorage.setItem(STORAGE,JSON.stringify(value));
}
function download(name,value){
  const url=URL.createObjectURL(new Blob([JSON.stringify(value,null,2)],{type:'application/json'}));
  const a=document.createElement('a');a.href=url;a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
}
function changedKeys(){return draft&&snapshot?KEYS.filter(k=>getColor(draft,k.slot)!==getColor(snapshot.custom,k.slot)):[];}
function effectName(effect){return effect===19?'Custom':`Preset ${effect}`;}
function render(){
  const editing=!!draft&&!busy;
  for(const key of KEYS){
    const button=keyButtons.get(key.slot);button.disabled=!editing;
    const color=draft?getColor(draft,key.slot):'#34435a';
    button.style.setProperty('--key-color',color);button.setAttribute('aria-pressed',String(selected.has(key.slot)));
    button.classList.toggle('changed',!!snapshot&&getColor(snapshot.custom,key.slot)!==color);
    button.setAttribute('aria-label',`${key.label}, ${draft?color:'color not read'}${selected.has(key.slot)?', selected':''}`);
  }
  const labels=KEYS.filter(k=>selected.has(k.slot)).map(k=>k.label);
  $('selected-label').textContent=labels.length===1?labels[0]:labels.length?`${labels.length} keys selected`:'Choose a key';
  $('selected-detail').textContent=labels.length?labels.join(' · '):'Every key can have its own color.';
  $('selection-count').textContent=labels.length?`${labels.length} key${labels.length===1?'':'s'} selected`:'No keys selected';
  $('color').disabled=$('hex').disabled=$('paint').disabled=!editing||!labels.length;
  for(const button of $('swatches').children)button.disabled=!editing||!labels.length;
  $('select-all').disabled=$('clear-selection').disabled=!editing;
  $('lighting-mode').disabled=!editing;
  $('connection').textContent=busy?'Working…':keyboard?'Connected via USB':demo?'Preview only':'Disconnected';
  $('connect').hidden=!!keyboard;$('connect').disabled=busy||!('hid' in navigator);
  $('disconnect').hidden=!keyboard;$('disconnect').disabled=busy;
  $('demo').hidden=!!keyboard;$('demo').disabled=busy;
  $('current-effect').textContent=snapshot?(demo?'Preview · Custom':effectName(snapshot.settings[10])):'Not read yet';
  $('canvas-caption').textContent=demo?'Preview only. Connect to read your actual colors.':draft?'Saved custom colors, with your edits shown below.':'The colors will appear when you connect.';
  const count=changedKeys().length;const customChosen=$('lighting-mode').value==='custom';
  const needsCustom=snapshot&&snapshot.settings[10]!==19;
  $('save').disabled=busy||!keyboard||!customChosen||(!count&&!needsCustom);
  $('save').textContent=busy?'Working…':needsCustom?'Save & switch to custom':'Save to keyboard';
  $('changes').textContent=count?`${count} key${count===1?'':'s'} changed`:(needsCustom&&customChosen?'Ready to switch to custom':'No unsaved changes');
  $('mode-help').textContent=customChosen?'Saving applies these colors and switches to Custom.':'The current preset stays active. Choose Custom to save your key colors.';
  $('read').disabled=busy||!keyboard;$('discard').disabled=!editing||!count;
  $('export').disabled=$('import').disabled=!editing;
  $('restore').disabled=busy||!keyboard||!savedBackup();$('download-backup').disabled=busy||!savedBackup();
}
function chooseColor(){
  if(!selected.size||!draft)return;
  const colors=[...selected].map(slot=>getColor(draft,slot));
  if(colors.every(c=>c===colors[0]))$('color').value=$('hex').value=colors[0];
}
function select(slot,event){
  if(event.shiftKey&&anchor!==null){const ids=KEYS.map(k=>k.slot);const a=ids.indexOf(anchor),b=ids.indexOf(slot);for(const id of ids.slice(Math.min(a,b),Math.max(a,b)+1))selected.add(id);}
  else if(event.ctrlKey||event.metaKey){selected.has(slot)?selected.delete(slot):selected.add(slot);anchor=slot;}
  else {selected=new Set([slot]);anchor=slot;}
  chooseColor();render();
}
for(const row of ROWS){
  const element=document.createElement('div');element.className='key-row';
  for(const [label,slot,width=1] of row){
    const button=document.createElement('button');button.type='button';button.className='key';button.textContent=label;
    button.style.setProperty('--width',width);button.dataset.slot=slot;button.addEventListener('click',event=>select(slot,event));
    element.append(button);keyButtons.set(slot,button);
  }
  $('keyboard').append(element);
}
function paint(color){
  try {for(const slot of selected)setColor(draft,slot,color);$('hex').value=$('color').value=color.toLowerCase();$('lighting-mode').value='custom';render();}
  catch(error){message(error.message,'error');}
}
for(const color of palette){const button=document.createElement('button');button.className='swatch';button.type='button';button.style.setProperty('--swatch',color);button.setAttribute('aria-label',`Use ${color}`);button.title=color;button.addEventListener('click',()=>paint(color));$('swatches').append(button);}
$('color').addEventListener('input',()=>paint($('color').value));
$('paint').addEventListener('click',()=>paint($('hex').value));
$('hex').addEventListener('keydown',event=>{if(event.key==='Enter')paint($('hex').value);});
$('select-all').addEventListener('click',()=>{selected=new Set(KEYS.map(k=>k.slot));chooseColor();render();});
$('clear-selection').addEventListener('click',()=>{selected.clear();render();});
$('lighting-mode').addEventListener('change',render);
async function run(action){
  if(busy)return;busy=true;render();
  try {await action();}catch(error){message(error.message||'The operation failed. Try reading the keyboard again.','error');}
  finally {busy=false;render();}
}
function accept(result){snapshot=result;draft=result.custom.slice();$('lighting-mode').value=result.settings[10]===19?'custom':'current';chooseColor();}
$('connect').addEventListener('click',()=>run(async()=>{
  const devices=await navigator.hid.requestDevice({filters:[ID]});if(!devices.length)return;
  const device=devices[0];let candidate;
  try {
    candidate=new Keyboard(device);if(!device.opened)await device.open();
    message('Reading the current effect and custom colors…');const result=await candidate.read();
    keyboard=candidate;demo=false;accept(result);message(`Read ${effectName(result.settings[10])}. Your custom colors are ready to edit.`,'success');
  } catch(error){if(candidate)await candidate.close().catch(()=>{});throw error;}
}));
$('disconnect').addEventListener('click',()=>run(async()=>{await keyboard.close();keyboard=null;demo=false;message('Disconnected. Your unsaved colors are kept in this tab.');}));
navigator.hid?.addEventListener('disconnect',event=>{
  if(keyboard?.device===event.device){keyboard=null;demo=false;message('Keyboard disconnected. Reconnect in wired mode to continue.','error');render();}
});
window.addEventListener('pagehide',()=>{keyboard?.close().catch(()=>{});});
$('read').addEventListener('click',()=>run(async()=>{
  const edits=changedKeys().map(k=>[k.slot,getColor(draft,k.slot)]);
  message('Reading the keyboard…');accept(await keyboard.read());
  for(const [slot,color] of edits)setColor(draft,slot,color);
  if(edits.length)$('lighting-mode').value='custom';
  chooseColor();
  message(edits.length?'Current lighting read. Your unsaved colors were kept.':'Current lighting read.','success');
}));
$('save').addEventListener('click',()=>run(async()=>{
  message('Backing up your lighting, saving colors, and checking the result…');
  accept(await keyboard.saveCustom(snapshot,draft,backup));message('Saved to your keyboard. Custom mode is active; all colors passed readback.','success');
}));
$('restore').addEventListener('click',()=>run(async()=>{
  const saved=savedBackup();if(!saved)throw new Error('No valid backup is available.');
  message('Restoring the previous colors and lighting mode…');accept(await keyboard.restore(saved,backup));
  message('Previous lighting restored and verified.','success');
}));
$('download-backup').addEventListener('click',()=>{
  const value=localStorage.getItem(STORAGE);if(value)download('wkl100-lighting-backup.json',JSON.parse(value));
});
$('discard').addEventListener('click',()=>{draft=snapshot.custom.slice();chooseColor();render();message('Unsaved color edits discarded.');});
$('export').addEventListener('click',()=>download('wkl100-custom-colors.json',{schema:1,device:'258A:019D WKL-100',colors:KEYS.map(k=>({slot:k.slot,key:k.label,color:getColor(draft,k.slot)}))}));
$('import').addEventListener('change',()=>run(async()=>{
  const file=$('import').files[0];$('import').value='';if(!file)return;
  if(file.size>100000)throw new Error('The color file is too large.');
  const value=JSON.parse(await file.text());const next=draft.slice();
  if(value.schema!==1 || value.device!=='258A:019D WKL-100')throw new Error('Choose a WKL-100 color export or lighting backup.');
  if(value.custom){const saved=validateBackup(value);for(const k of KEYS)setColor(next,k.slot,getColor(saved.custom,k.slot));}
  else {
    if(!Array.isArray(value.colors)||value.colors.length>KEYS.length)throw new Error('Invalid color export.');
    const seen=new Set();
    for(const entry of value.colors){if(!keyButtons.has(entry.slot)||seen.has(entry.slot))throw new Error('Invalid or repeated key in the color file.');seen.add(entry.slot);setColor(next,entry.slot,entry.color);}
  }
  draft=next;$('lighting-mode').value='custom';chooseColor();message('Colors imported into the preview. Save to apply them to the keyboard.');
}));
$('demo').addEventListener('click',()=>{
  demo=true;const custom=new Uint8Array(512);
  const settings=new Uint8Array(128);settings[10]=19;
  for(const k of KEYS)setColor(custom,k.slot,'#2389ff');
  for(const k of KEYS.filter(k=>'YUIO'.includes(k.label)&&k.label.length===1))setColor(custom,k.slot,'#ff0000');
  for(const k of KEYS.filter(k=>'GFVB'.includes(k.label)&&k.label.length===1))setColor(custom,k.slot,'#00ff00');
  accept({custom,settings,base:new Uint8Array(512)});selected.clear();message('Preview only. These are example colors; nothing is sent to a keyboard.');render();
});
if(!('hid' in navigator))message('Use desktop Chrome or Edge to connect. You can still explore the preview.');
render();
