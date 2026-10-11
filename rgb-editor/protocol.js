// WKL-100 258A:019D only. Firmware and physical test evidence in ../findings.
export const ID = {vendorId:0x258a, productId:0x019d, usagePage:0xff02, usage:2};
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
export const equal = (a,b) => a.length === b.length && a.every((v,i) => v === b[i]);
export function bytes(view) {
  return new Uint8Array(view.buffer, view.byteOffset, view.byteLength).slice();
}
export function validateDevice(device) {
  const walk = collections => collections.flatMap(c => [c,...walk(c.children || [])]);
  const collection = walk(device.collections || []).find(c => c.usagePage === ID.usagePage && c.usage === ID.usage);
  const report = collection?.featureReports?.find(r => r.reportId === 9);
  const bits = report?.items?.reduce((n,i) => n + i.reportSize * i.reportCount, 0);
  if(device.vendorId !== ID.vendorId || device.productId !== ID.productId || device.productName !== 'WKL-100' || bits !== 519*8)
    throw new Error('Choose the WKL-100 vendor interface with its 519-byte feature report.');
}
export function packet(opcode, {selector=0,page=0,count=0,payload=[]}={}) {
  if(![0x83,0x84,0x85,0x06,0x04].includes(opcode)) throw new Error('Unsupported lighting operation.');
  if(payload.length > 512) throw new Error('Payload too large.');
  const report = new Uint8Array(519);
  report.set([opcode,selector,0,1,page,count & 255,count >> 8]);
  report.set(payload,7);
  return report;
}
export function parseResponse(view, request, size) {
  let response = bytes(view);
  // WebHID implementations may expose the report ID; HIDAPI always includes it.
  // Accept either representation only with an exact echoed header and length.
  if(response[0] === 9 && equal(response.slice(1,8),request.slice(0,7))) response=response.slice(1);
  const expected=size+7;
  if(response.length < expected || response.length > 519 || !equal(response.slice(0,7),request.slice(0,7)) || response.slice(expected).some(v=>v!==0))
    throw new Error('The keyboard returned an unexpected lighting response. No update was applied.');
  return response.slice(7,expected);
}
export function joinRegion(a,b,c) {
  if(a.length!==255 || b.length!==255 || c.length!==255 || !equal(a.slice(-7),b.slice(0,7)) || !equal(b.slice(-7),c.slice(0,7)))
    throw new Error('Lighting backup overlaps differ. Re-read the keyboard before saving.');
  return Uint8Array.from([...a,...b.slice(7),...c.slice(7,16)]);
}
export function getColor(region,slot) {
  if(region.length!==512 || !Number.isInteger(slot) || slot<0 || slot>=126) throw new Error('Invalid color slot.');
  return '#'+[region[slot],region[126+slot],region[252+slot]].map(n=>n.toString(16).padStart(2,'0')).join('');
}
export function setColor(region,slot,color) {
  getColor(region,slot);
  if(!/^#[\da-f]{6}$/i.test(color)) throw new Error('Enter a six-digit hex color, such as #ff0000.');
  for(let c=0;c<3;c++) region[c*126+slot]=parseInt(color.slice(1+c*2,3+c*2),16);
}
export class Keyboard {
  constructor(device, {delay=150}={}) {validateDevice(device); this.device=device; this.delay=delay;}
  async close() {if(this.device.opened) await this.device.close();}
  async send(report) {
    if(report.length!==519) throw new Error('Invalid feature report size.');
    await this.device.sendFeatureReport(9,report); await sleep(this.delay);
  }
  async query(opcode,options,size=255) {
    const request=packet(opcode,options); await this.send(request);
    return parseResponse(await this.device.receiveFeatureReport(9),request,size);
  }
  async region(kind) {
    const first = kind==='custom'
      ? await this.query(0x85,{page:0x68,count:255}) // DC + 2*68 wraps to AC.
      : await this.query(0x83,{selector:0,count:255});
    // Own firmware: selector 4 preserves the CODE pointer. Each read advances
    // 248 bytes; its final seven-byte packet does not advance that pointer.
    const second=await this.query(0x83,{selector:4,count:255});
    const third=await this.query(0x83,{selector:4,count:255});
    return joinRegion(first,second,third);
  }
  async settings() {return this.query(0x84,{count:128},128);}
  async read() {
    const settings=await this.settings(); const custom=await this.region('custom');
    if(!equal(custom,await this.region('custom'))) throw new Error('Lighting changed during the read. Try again.');
    const base=await this.region('base');
    return {settings,custom,base};
  }
  async writeCustom(region) {
    await this.send(packet(0x06,{count:378,payload:region.slice(0,378)}));
    await sleep(this.delay*2);
    if(!equal(await this.region('custom'),region)) throw new Error('Custom color verification failed.');
  }
  async writeSettings(settings) {
    await this.send(packet(0x04,{count:128,payload:settings}));
    if(!equal(await this.settings(),settings)) throw new Error('Lighting mode verification failed.');
  }
  async saveCustom(snapshot,desired,backup) {
    const current=await this.read();
    if(!equal(current.custom,snapshot.custom) || !equal(current.settings,snapshot.settings))
      throw new Error('Lighting changed on the keyboard. Read it again before saving.');
    if(desired.length!==512 || !equal(desired.slice(378),current.custom.slice(378)))
      throw new Error('The update would change data outside the color table.');
    await backup(current); // Must persist successfully before any write.
    let wrote=false;
    try {
      wrote=true; await this.writeCustom(desired);
      const settings=current.settings.slice(); settings[10]=19;
      if(!equal(settings,current.settings)) await this.writeSettings(settings);
      const result=await this.read();
      if(!equal(result.custom,desired) || !equal(result.settings,settings) || !equal(result.base,current.base))
        throw new Error('Final lighting or keymap verification failed.');
      return result;
    } catch(error) {
      if(wrote) {
        try {await this.writeCustom(current.custom); await this.writeSettings(current.settings);}
        catch {throw new Error(`${error.message} Automatic restoration failed. Reconnect in the app and use Restore backup.`);}
      }
      throw new Error(`${error.message} The previous lighting was restored.`);
    }
  }
  async restore(saved,backup) {
    const current=await this.read(); await backup(current);
    const desired=current.custom.slice(); desired.set(saved.custom.slice(0,378));
    try {
      await this.writeCustom(desired);
      // Restore only the effect; preserve other current settings.
      const settings=current.settings.slice(); settings[10]=saved.settings[10];
      await this.writeSettings(settings);
      const result=await this.read();
      if(!equal(result.custom,desired) || !equal(result.settings,settings) || !equal(result.base,current.base))
        throw new Error('Backup verification failed.');
      return result;
    } catch(error) {
      try {await this.writeCustom(current.custom);await this.writeSettings(current.settings);}
      catch {throw new Error(`${error.message} Recovery failed; the backup is still available.`);}
      throw new Error(`${error.message} The previous lighting was restored.`);
    }
  }
}
