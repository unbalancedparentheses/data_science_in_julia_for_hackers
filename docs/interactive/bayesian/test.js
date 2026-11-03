"use strict";
const assert=require('node:assert/strict'),fixture=require('./fixtures.js'),engine=require('./engine.js');
let checks=0;function near(a,b){assert.ok(Number.isFinite(a)&&Math.abs(a-b)<1e-10,`${a} != ${b}`);checks++;}
for(const row of fixture.expected){const actual=engine.calculate(fixture.goals,row.strength,row.posterior);for(const key of ['shape','rate','mean','variance'])near(actual[key],row[key]);actual.probabilities.forEach((x,i)=>near(x,row.probabilities[i]));near(actual.probabilities.reduce((a,b)=>a+b,0),1);assert.ok(actual.probabilities.every(x=>x>=0));}
assert.throws(()=>engine.calculate(fixture.goals,0,true));
console.log(`Passed ${checks} Julia parity checks across ${fixture.expected.length} control states.`);
