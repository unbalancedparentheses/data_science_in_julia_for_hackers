import assert from 'node:assert/strict';
import data from './data.js';
import {evaluate} from './model.js';
const near=(a,b)=>assert.ok(Math.abs(a-b)<1e-9,`${a} != ${b}`);
for (const c of data.cases) {
  const r=evaluate(data,c.fp,c.fn,c.prevalence);
  near(r.threshold,c.threshold); near(r.cost,c.cost);
  for (const key of ['tp','fp','tn','fn']) near(r.counts[key],c.counts[key]);
}
assert.throws(()=>evaluate(data,-1,1,.07));
assert.equal(evaluate(data,20,1,.01).precision,null);
console.log(`Evaluation: ${data.cases.length} scenarios match Julia.`);
