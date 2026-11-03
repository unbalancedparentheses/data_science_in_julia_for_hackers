"use strict";
const $=id=>document.getElementById(id),pct=x=>(100*x).toFixed(2)+'%';
function render(){
 const s=Number($('strength').value),post=$('view').value==='posterior',r=BayesianEngine.calculate(bayesianFixture.goals,s,post);
 const observed=Array(12).fill(0);bayesianFixture.goals.forEach(g=>observed[Math.min(g,11)]++);observed.forEach((n,i)=>observed[i]=n/bayesianFixture.goals.length);
 $('summary').textContent=`${post?'Posterior':'Prior'} prediction: mean ${r.mean.toFixed(3)} goals; variance ${r.variance.toFixed(3)}; zero-goal chance ${pct(r.probabilities[0])}.`;
 $('parameters').textContent=`Gamma shape ${r.shape}, rate ${r.rate}. Dataset: ${bayesianFixture.goals.reduce((a,b)=>a+b,0)} goals in 80 matches. Prior strength ${s}, prior mean 2.`;
 $('results').innerHTML=r.probabilities.map((p,k)=>`<tr><th scope="row">${k===11?'11+':k}</th><td>${pct(p)}</td><td>${pct(observed[k])}</td></tr>`).join('');
 const max=.6, y=p=>250-220*p/max;let svg='';
 for(const tick of [0,.2,.4,.6])svg+=`<line x1="82" x2="790" y1="${y(tick)}" y2="${y(tick)}" stroke="#d5ded7"/><text x="75" y="${y(tick)+5}" font-size="14" text-anchor="end">${Math.round(tick*100)}%</text>`;
 r.probabilities.forEach((p,k)=>{let x=88+k*58;svg+=`<rect x="${x}" y="${y(p)}" width="23" height="${250-y(p)}" fill="#147767"/><rect x="${x+24}" y="${y(observed[k])}" width="23" height="${250-y(observed[k])}" fill="#bd6238"/><text x="${x+23}" y="278" font-size="16" text-anchor="middle">${k===11?'11+':k}</text>`;});
 $('chart').innerHTML=svg;
}
$('strength').addEventListener('change',render);$('view').addEventListener('change',render);$('reset').addEventListener('click',()=>{$('strength').value='1';$('view').value='posterior';render();});render();
