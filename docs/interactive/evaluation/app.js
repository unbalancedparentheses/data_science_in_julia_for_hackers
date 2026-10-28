import data from './data.js';
import {evaluate} from './model.js';
const el=id=>document.getElementById(id);
function update() {
  const fp=+el('fp').value, fn=+el('fn').value, prevalence=+el('prevalence').value/100;
  el('fp-value').textContent=fp; el('fn-value').textContent=fn; el('prevalence-value').textContent=`${Math.round(prevalence*100)}%`;
  const result=evaluate(data,fp,fn,prevalence);
  const action=result.counts.tp+result.counts.fp===0 ? 'With these costs, delivering everything is cheapest.' : `Cheapest rule: block scores at or above ${result.threshold.toFixed(2)}.`;
  el('summary').textContent=`${action} Expected cost: ${(1000*result.cost).toFixed(1)} units per 1,000 messages.`;
  for (const [id,key] of [['tp','tp'],['fp-count','fp'],['fn-count','fn'],['tn','tn']]) el(id).textContent=result.counts[key].toFixed(1);
  const percent=p=>p===null ? 'undefined (nothing blocked)' : `${(p*100).toFixed(1)}%`;
  el('metrics').textContent=`Precision: ${percent(result.precision)}. Recall: ${percent(result.recall)}.`;
  const costs=result.costs.map(value=>value*1000);
  // The display changes, not the costs: log spacing shows the cheap rules
  // without removing the expensive ones. Fall back to linear if zero is present.
  const logarithmic=costs.every(value=>value>0);
  const low=logarithmic ? Math.floor(Math.log10(Math.min(...costs))) : 0;
  const high=logarithmic ? Math.max(low+1,Math.ceil(Math.log10(Math.max(...costs)))) : Math.max(...costs)||1;
  const x=t=>135+555*t, y=value=>220-185*((logarithmic?Math.log10(value):value)-low)/(high-low);
  const ticks=logarithmic ? Array.from({length:high-low+1},(_,i)=>10**(low+i)) : [0,high/2,high];
  const grid=ticks.map(value=>`<line x1="135" x2="690" y1="${y(value)}" y2="${y(value)}" stroke="#e0e5ed"/><text x="120" y="${y(value)+5}" text-anchor="end" font-size="15">${value.toLocaleString('en-US')}</text>`).join('');
  const baseline=1000*prevalence*fn;
  const points=costs.map((value,i)=>`${x(data.thresholds[i])},${y(value)}`).join(' ');
  const horizontal=[0,.25,.5,.75,1].map(value=>`<text x="${x(value)}" y="247" text-anchor="middle" font-size="15">${value}</text>`).join('');
  el('axis-note').textContent=logarithmic ? 'Cost per 1,000 messages, logarithmic axis: equal vertical gaps represent equal ratios. Every candidate threshold is shown.' : 'Cost per 1,000 messages, linear axis. Every candidate threshold is shown.';
  el('chart').setAttribute('aria-label',`Expected cost per thousand messages versus threshold, ${logarithmic?'logarithmic':'linear'} cost axis`);
  el('chart').innerHTML=`<title>Expected cost versus threshold; selected threshold ${result.threshold.toFixed(2)}</title>${grid}<path d="M135 30V220H690" fill="none" stroke="#8995a3"/><line x1="135" x2="690" y1="${y(baseline)}" y2="${y(baseline)}" stroke="#667788" stroke-dasharray="6 5"/><polyline points="${points}" fill="none" stroke="#7757b3" stroke-width="3"/><circle cx="${x(result.threshold)}" cy="${y(result.cost*1000)}" r="6" fill="#155d76"/>${horizontal}<text x="412" y="274" text-anchor="middle" font-size="15">Blocking threshold</text>`;
}
for (const id of ['fp','fn','prevalence']) el(id).addEventListener('input',update);
update();
