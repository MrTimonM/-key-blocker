import {test} from 'node:test';
import assert from 'node:assert/strict';
import {bytesOf,describeCollections,reportSummary,appendBounded} from './model.js';
test('raw bytes honor DataView offsets',()=>assert.deepEqual(bytesOf(new DataView(Uint8Array.of(99,1,2,88).buffer,1,2)),[1,2]));
test('nested report fields aggregate per report and preserve WebIDL properties',()=>{
  const item=Object.create({reportSize:8,reportCount:512,usages:[1]});
  const collections=describeCollections([{usagePage:0xff02,usage:2,featureReports:[{reportId:9,items:[item]}],children:[{usagePage:0xff02,featureReports:[{reportId:9,items:[{reportSize:8,reportCount:7}]}]}]}]);
  const reports=reportSummary(collections);assert.equal(reports.length,1);assert.equal(reports[0].bytes,519);assert.equal(reports[0].reportId,9);assert.deepEqual(collections[0].featureReports[0].items[0].usages,[1]);
});
test('capture buffers remain bounded under a stuck key',()=>{const list=[];for(let n=0;n<10000;n++)appendBounded(list,n);assert.equal(list.length,500);assert.equal(list[0],9500);});
