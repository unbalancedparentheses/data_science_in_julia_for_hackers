"use strict";
const assert=require('node:assert/strict'),fixture=require('./fixtures.js'),engine=require('./engine.js');
let checks=0;function near(a,b){assert.ok(Number.isFinite(a)&&Math.abs(a-b)<1e-10,`${a} != ${b}`);checks++;}
for(const row of fixture.expected){const actual=engine.calculate(fixture,row.tendency);for(const kind of ['naive','trial']){const r=actual[kind];[r.estimate,r.se,...r.interval].forEach((x,i)=>near(x,row[kind][i]));}near(actual.adjusted,row.adjusted);assert.deepEqual(actual.counts,row.counts);checks++;}
assert.ok(engine.calculate(fixture,.85).naive.estimate>0);assert.ok(engine.calculate(fixture,.85).adjusted<0);
console.log(`Passed ${checks} Julia parity checks across ${fixture.expected.length} control states.`);
