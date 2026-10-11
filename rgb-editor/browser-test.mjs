// Run with a Playwright module path. Tests use a simulated device exclusively.
import assert from 'node:assert/strict';
import {createDevice} from './mock-device.js';
const {chromium}=await import(process.argv[2]||'playwright');
const browser=await chromium.launch({headless:true,channel:'msedge'});
try {
  const page=await browser.newPage({viewport:{width:1440,height:1000},acceptDownloads:true});const errors=[];
  page.on('pageerror',error=>errors.push(error.message));
  await page.addInitScript(`{
    const createDevice=${createDevice.toString()};
    window.testDevice=createDevice();
    const hid=new EventTarget();hid.requestDevice=async()=>[window.testDevice];
    Object.defineProperty(navigator,'hid',{value:hid});
  }`);
  await page.goto('http://127.0.0.1:8766/');
  assert.equal(await page.locator('.key').count(),81);
  assert(await page.locator('#save').isDisabled());
  await page.locator('#demo').click();await page.locator('.key[data-slot="38"]').click();
  await page.locator('#hex').fill('#123456');await page.locator('#paint').click();
  assert(await page.locator('#save').isDisabled());assert.deepEqual(await page.evaluate(()=>window.testDevice.calls),[]);
  await page.locator('#connect').click();await page.getByText('Read Preset 3. Your custom colors are ready to edit.',{exact:true}).waitFor();
  await page.locator('.key[data-slot="38"]').click();await page.locator('#hex').fill('#ff0000');await page.locator('#paint').click();
  await page.locator('.key[data-slot="33"]').click();await page.locator('#hex').fill('#00ff00');await page.locator('#paint').click();
  const downloadPromise=page.waitForEvent('download');await page.locator('#export').click();const download=await downloadPromise;
  let text='';for await(const chunk of await download.createReadStream())text+=chunk;
  const exported=JSON.parse(text);assert.equal(exported.colors.find(k=>k.slot===38).color,'#ff0000');
  await page.locator('#save').click();await page.getByText('Saved to your keyboard. Custom mode is active; all colors passed readback.',{exact:true}).waitFor();
  assert.equal(await page.locator('#current-effect').innerText(),'Custom');
  assert(await page.locator('#save').isDisabled());assert(!(await page.locator('#restore').isDisabled()));
  assert.equal(await page.evaluate(()=>window.testDevice.settings[10]),19);
  assert.equal(await page.evaluate(()=>window.testDevice.custom[38]),255);
  assert.equal(await page.evaluate(()=>window.testDevice.custom[126+33]),255);
  await page.screenshot({path:'rgb-editor-desktop.png',fullPage:true});
  await page.setViewportSize({width:390,height:844});await page.screenshot({path:'rgb-editor-mobile.png',fullPage:true});
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
  await page.locator('#restore').click();await page.getByText('Previous lighting restored and verified.',{exact:true}).waitFor();
  assert.equal(await page.locator('#current-effect').innerText(),'Preset 3');
  await page.locator('#disconnect').click();assert.equal(await page.evaluate(()=>window.testDevice.opened),false);
  assert.deepEqual(errors,[]);console.log('PASS: preview, current preset read, individual colors, export, save/custom activation, backup restore, disconnect, desktop/mobile layout.');
} finally {await browser.close();}
