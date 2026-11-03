import assert from 'node:assert/strict';
import data from './data.js';
import {compare,rmse} from './model.js';
for (const penalty of [0,.01,.1,1,10]) for (let depth=2;depth<=8;depth++) {
  const result=compare(data,penalty,depth);
  const source=[data.baseline,data.linear,data.ridge.find(m=>m.penalty===penalty),data.trees.find(m=>m.depth===depth)];
  for (let i=0;i<result.length;i++) assert.ok(Math.abs(result[i].rmse-source[i].rmse)<1e-9);
}
assert.equal(data.observed.length,360);
assert.throws(()=>compare(data,2,4)); assert.throws(()=>rmse([],[]));
assert.notEqual(compare(data,.1,2)[3].rmse,compare(data,.1,8)[3].rmse);
console.log('Tabular: all 35 control combinations agree with Julia/MLJ validation errors.');
