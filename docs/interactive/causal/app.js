"use strict";
const $=id=>document.getElementById(id), fmt=x=>x.toFixed(2);
function render(){
 const t=Number($('tendency').value)/100,r=CausalEngine.calculate(causalFixture,t);
 $('tendency-value').textContent=Math.round(t*100)+'%'; $('quiet').textContent=Math.round((1-t)*100)+'%';
 $('summary').textContent=`Naive: ${fmt(r.naive.estimate)} units. Adjusted: ${fmt(r.adjusted)}. Known effect: −20.`;
 const rows=[['Naive historical',r.naive.estimate,r.naive.interval],['Adjusted for demand',r.adjusted,null],['Randomized experiment',r.trial.estimate,r.trial.interval],['Known synthetic effect',-20,null]];
 $('results').innerHTML=rows.map(([name,value,ci])=>`<tr><th scope="row">${name}</th><td>${fmt(value)}</td><td>${ci?ci.map(fmt).join(' to '):'—'}</td></tr>`).join('');
 $('counts').innerHTML=r.counts.map((c,i)=>`<tr><th scope="row">${i?'Busy':'Quiet'}</th><td>${c[0]}</td><td>${c[1]}</td></tr>`).join('');
 const x=v=>230+(v+40)/150*540;
 let svg=`<line x1="${x(0)}" x2="${x(0)}" y1="15" y2="182" stroke="#9aa6a1"/><line x1="${x(-20)}" x2="${x(-20)}" y1="15" y2="182" stroke="#bd6238" stroke-dasharray="5 4"/>`;
 rows.forEach(([name,value,ci],i)=>{const y=35+i*43;svg+=`<text x="0" y="${y+5}" font-size="17">${name}</text>`;if(ci)svg+=`<line x1="${x(ci[0])}" x2="${x(ci[1])}" y1="${y}" y2="${y}" stroke="#147767" stroke-width="4"/>`;svg+=`<circle cx="${x(value)}" cy="${y}" r="6" fill="${i===3?'#bd6238':'#147767'}"/>`;});
 for(const tick of [-40,-20,0,40,80,110])svg+=`<text x="${x(tick)}" y="212" text-anchor="middle" font-size="15">${tick}</text>`;
 $('chart').innerHTML=svg;
}
$('tendency').addEventListener('input',render);$('reset').addEventListener('click',()=>{$('tendency').value=85;render();});render();
