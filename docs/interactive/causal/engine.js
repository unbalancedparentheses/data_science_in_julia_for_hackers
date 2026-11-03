"use strict";
(function(root){
function difference(values,high){
 const groups=[[],[]]; values.forEach((x,i)=>groups[Number(high[i])].push(x));
 const means=groups.map(g=>g.reduce((a,b)=>a+b,0)/g.length);
 const variances=groups.map((g,i)=>g.reduce((s,x)=>s+(x-means[i])**2,0)/(g.length-1));
 const estimate=means[1]-means[0], se=Math.sqrt(variances[0]/groups[0].length+variances[1]/groups[1].length);
 return {estimate,se,interval:[estimate-1.96*se,estimate+1.96*se]};
}
function calculate(data,tendency){
 if(![50,55,60,65,70,75,80,85,90,95].includes(Math.round(tendency*100)) || Math.abs(tendency*100-Math.round(tendency*100))>1e-9)throw Error('Invalid tendency');
 const high=data.busy.map((busy,i)=>data.uniform[i]<(busy?tendency:1-tendency));
 const y=data.low.map((x,i)=>x-(high[i]?20:0));
 let adjusted=0; const counts=[];
 for(const busy of [false,true]){
 const rows=data.busy.map((b,i)=>b===busy?i:-1).filter(i=>i>=0);
 const assignments=rows.map(i=>high[i]);
 adjusted+=rows.length/data.busy.length*difference(rows.map(i=>y[i]),assignments).estimate;
 counts.push([assignments.filter(x=>!x).length,assignments.filter(Boolean).length]);
 }
 const trialHigh=data.trialUniform.map(x=>x<.5);
 return {naive:difference(y,high),adjusted,trial:difference(data.low.map((x,i)=>x-(trialHigh[i]?20:0)),trialHigh),counts};
}
const api={calculate,difference}; if(typeof module!=='undefined')module.exports=api; else root.CausalEngine=api;
})(globalThis);
