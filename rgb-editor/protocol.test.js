import test from 'node:test';
import assert from 'node:assert/strict';
import {Keyboard,packet,parseResponse,joinRegion,getColor,setColor} from './protocol.js';
import {createDevice} from './mock-device.js';
import {KEYS} from './layout.js';
test('81 unique keys, including physically verified slots',()=>{
  assert.equal(KEYS.length,81);assert.equal(new Set(KEYS.map(k=>k.slot)).size,81);
  assert.equal(KEYS.find(k=>k.label==='Y').slot,38);assert.equal(KEYS.find(k=>k.label==='B').slot,34);
});
test('reject unrelated devices and unsupported write commands',()=>{
  const d=createDevice();d.productId=0x010c;assert.throws(()=>new Keyboard(d),/Choose/);
  assert.throws(()=>packet(0x03),/Unsupported/);assert.throws(()=>packet(0x75),/Unsupported/);
});
test('DataView offsets, report ID separation, malformed response rejection',()=>{
  const request=packet(0x84,{count:128});const backing=new Uint8Array(160);backing.set(request.slice(0,7),13);
  assert.equal(parseResponse(new DataView(backing.buffer,13,135),request,128).length,128);
  assert.equal(request.length,519);assert.equal(request[0],0x84);
  assert.throws(()=>parseResponse(new DataView(new ArrayBuffer(135)),request,128),/unexpected/);
  assert.throws(()=>joinRegion(new Uint8Array(255),new Uint8Array(255).fill(1),new Uint8Array(255)),/overlaps/);
});
test('save custom, switch mode, preserve metadata, settings and entire keymap',async()=>{
  const d=createDevice({includeId:true});const k=new Keyboard(d,{delay:0});const before=await k.read();
  const next=before.custom.slice();setColor(next,38,'#ff0000');setColor(next,33,'#00ff00');
  let saved;const result=await k.saveCustom(before,next,current=>{saved=current;});
  assert.deepEqual(saved.custom,before.custom);assert.equal(getColor(result.custom,38),'#ff0000');assert.equal(getColor(result.custom,33),'#00ff00');
  assert.equal(result.settings[10],19);assert.equal(result.settings[15],4);
  assert.deepEqual(result.base,before.base);assert.deepEqual(result.custom.slice(378),before.custom.slice(378));
  assert(d.calls.filter(c=>c[0]==='send').every(c=>[4,6,0x83,0x84,0x85].includes(c[1])));
});
test('stale state or backup-storage failure sends no configuration writes',async()=>{
  const d=createDevice();const k=new Keyboard(d,{delay:0});const before=await k.read();const next=before.custom.slice();setColor(next,38,'#ff0000');
  d.custom[0]=1;
  await assert.rejects(k.saveCustom(before,next,()=>assert.fail('Backup should not be called')),/changed on the keyboard/);
  d.custom[0]=0;
  await assert.rejects(k.saveCustom(before,next,()=>{throw new Error('Storage full');}),/Storage full/);
  assert.equal(d.calls.filter(c=>c[0]==='send'&&[4,6].includes(c[1])).length,0);
});
test('fixed-length WebHID responses support zero padding, with or without report ID',async()=>{
  for(const includeId of [false,true]) {
    const d=createDevice({includeId,padded:true});const k=new Keyboard(d,{delay:0});
    const result=await k.read();assert.deepEqual(result.custom,d.custom);assert.deepEqual(result.settings,d.settings);
  }
});
test('verification failure restores the original color table and mode',async()=>{
  const d=createDevice();const k=new Keyboard(d,{delay:0});const before=await k.read();const next=before.custom.slice();setColor(next,38,'#ff0000');d.corruptOnce=true;
  await assert.rejects(k.saveCustom(before,next,()=>{}),/previous lighting was restored/);
  assert.deepEqual(d.custom,before.custom);assert.deepEqual(d.settings,before.settings);
});
test('restore changes only colors and previous effect, preserving current metadata/settings',async()=>{
  const d=createDevice();const k=new Keyboard(d,{delay:0});const saved=await k.read();
  d.custom[38]=255;d.custom[400]=99;d.settings[10]=19;d.settings[15]=2;
  const result=await k.restore(saved,()=>{});
  assert.equal(result.custom[38],0);assert.equal(result.custom[400],99);assert.equal(result.settings[10],3);assert.equal(result.settings[15],2);
});
