"use strict";
(function(root){
function calculate(goals,strength,posterior){
 if(![.5,1,5,10,30].includes(strength))throw Error('Invalid prior strength');
 const a=2*strength+(posterior?goals.reduce((x,y)=>x+y,0):0);
 const b=strength+(posterior?goals.length:0);
 const probabilities=[Math.exp(a*Math.log(b/(b+1)))];
 for(let k=0;k<10;k++) probabilities.push(probabilities[k]*(a+k)/(k+1)/(b+1));
 probabilities.push(Math.max(0,1-probabilities.reduce((x,y)=>x+y,0)));
 return {shape:a,rate:b,mean:a/b,variance:a/b+a/(b*b),probabilities};
}
const api={calculate};if(typeof module!=='undefined')module.exports=api;else root.BayesianEngine=api;
})(globalThis);
