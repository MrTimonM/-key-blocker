export const hex = (n, width = 2) => '0x' + Number(n).toString(16).toUpperCase().padStart(width, '0');
export function bytesOf(view) {
  return Array.from(new Uint8Array(view.buffer, view.byteOffset, view.byteLength));
}
// WebIDL properties may live on prototypes; explicitly copy rather than JSON.stringify(device).
const itemFields = ['reportSize','reportCount','usageMinimum','usageMaximum','logicalMinimum','logicalMaximum','physicalMinimum','physicalMaximum','unitExponent','unitSystem','unitFactorLengthExponent','unitFactorMassExponent','unitFactorTimeExponent','unitFactorTemperatureExponent','unitFactorCurrentExponent','unitFactorLuminousIntensityExponent','isAbsolute','isArray','isBufferedBytes','isConstant','isLinear','isRange','isVolatile','hasNull','hasPreferredState','wrap'];
export function describeCollections(collections) {
  return Array.from(collections || [], c => ({
    usagePage: c.usagePage, usage: c.usage, type: c.type,
    ...Object.fromEntries(['inputReports','outputReports','featureReports'].map(kind => [kind,
      Array.from(c[kind] || [], r => ({reportId:r.reportId, items:Array.from(r.items || [], item => ({
        ...Object.fromEntries(itemFields.filter(k => item[k] !== undefined).map(k => [k,item[k]])), usages:Array.from(item.usages || [])
      }))}))])), children:describeCollections(c.children)
  }));
}
export function reportSummary(collections) {
  const reports = new Map();
  function walk(list) {
    for (const c of list) {
      for (const kind of ['inputReports','outputReports','featureReports']) for (const r of c[kind]) {
        const key = `${kind}:${r.reportId}`;
        const entry = reports.get(key) || {kind:kind.replace('Reports',''),reportId:r.reportId,bits:0,pages:[]};
        entry.bits += r.items.reduce((sum,i) => sum + (i.reportSize || 0) * (i.reportCount || 0),0);
        if (!entry.pages.includes(c.usagePage)) entry.pages.push(c.usagePage);
        reports.set(key,entry);
      }
      walk(c.children);
    }
  }
  walk(collections);
  return [...reports.values()].map(r => ({...r,bytes:Math.ceil(r.bits / 8)}));
}
export function appendBounded(list, entry, limit = 500) {
  list.push(entry);
  if (list.length > limit) list.splice(0,list.length-limit);
}
