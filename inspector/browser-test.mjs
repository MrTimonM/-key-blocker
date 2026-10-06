// Run: node inspector/browser-test.mjs <path-or-package-for-playwright>
// Requires the local preview server. Uses a fake device, never real hardware.
import assert from 'node:assert/strict';
const {chromium}=await import(process.argv[2] || 'playwright');
const browser=await chromium.launch({headless:true,channel:'msedge'});
try {
  const page=await browser.newPage({acceptDownloads:true});
  const errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.addInitScript(()=>{
    window.hidCalls=[];
    const forbidden=name=>()=>{window.hidCalls.push(name);throw Error('Unexpected HID call: '+name);};
    const device={vendorId:0x258a,productId:0x019d,productName:'Test fixture',collections:[{usagePage:0xff02,usage:2,featureReports:[{reportId:9,items:[{reportSize:8,reportCount:519}]}]}],open:forbidden('open'),close:forbidden('close'),addEventListener:forbidden('subscribe'),sendReport:forbidden('send'),sendFeatureReport:forbidden('feature-write'),receiveFeatureReport:forbidden('feature-read')};
    const hid=new EventTarget();hid.requestDevice=async()=>[device];Object.defineProperty(navigator,'hid',{value:hid});
  });
  await page.goto('http://127.0.0.1:8765/');
  await page.locator('#pad').focus();await page.keyboard.press('a');
  assert.match(await page.locator('#last-key').innerText(),/KeyA/);
  await page.getByRole('button',{name:'Inspect descriptors'}).click();
  await page.getByText('519',{exact:true}).waitFor();
  await page.getByRole('button',{name:'Clear selection'}).click();
  const pending=page.waitForEvent('download');
  await page.getByRole('button',{name:'Export JSON'}).click();
  const download=await pending;let text='';
  for await(const chunk of await download.createReadStream())text+=chunk;
  const result=JSON.parse(text);
  assert.equal(result.mode,'descriptor-only');assert.equal(result.devices.length,1);
  assert.equal(result.keyEvents.length,2);assert.deepEqual(result.inputReports,[]);
  assert.deepEqual(await page.evaluate(()=>window.hidCalls),[]);assert.deepEqual(errors,[]);
  console.log('PASS: capture without HID, descriptor selection, clear selection, export; zero HID open/close/subscription/report calls.');
} finally { await browser.close(); }
