// Compare committed and freshly generated Julia ES-module fixtures, allowing roundoff.
import assert from 'node:assert/strict';
import {resolve} from 'node:path';
import {pathToFileURL} from 'node:url';
if (process.argv.length!==4) throw Error('Usage: node compare_fixture.mjs committed.js regenerated.mjs');
const [a,b]=await Promise.all(process.argv.slice(2).map(path=>import(pathToFileURL(resolve(path)).href)));
function compare(x,y,path='data') {
  if (typeof x==='number' && typeof y==='number') {
    assert.ok(Number.isFinite(x)&&Number.isFinite(y)&&Math.abs(x-y)<=1e-8*Math.max(1,Math.abs(x)),`${path}: ${x} != ${y}`);
  } else if (x!==null && typeof x==='object' && y!==null && typeof y==='object') {
    assert.equal(Array.isArray(x),Array.isArray(y),path);
    assert.deepEqual(Object.keys(x),Object.keys(y),path);
    for (const key of Object.keys(x)) compare(x[key],y[key],`${path}.${key}`);
  } else assert.equal(x,y,path);
}
compare(a.default,b.default);
console.log('Browser fixture agrees with freshly generated Julia results.');
