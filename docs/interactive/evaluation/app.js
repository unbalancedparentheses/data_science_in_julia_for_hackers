import data from './data.js';
import {evaluate} from './model.js';
const el=id=>document.getElementById(id);
function update() {
  const fp=+el('fp').value, fn=+el('fn').value, prevalence=+el('prevalence').value/100;
  el('fp-value').textContent=fp; el('fn-value').textContent=fn; el('prevalence-value').textContent=`${Math.round(prevalence*100)}%`;
  const result=evaluate(data,fp,fn,prevalence);
  el('summary').textContent=`Selected threshold: ${result.threshold.toFixed(2)}. Expected cost: ${(1000*result.cost).toFixed(1)} units per 1,000 messages.`;
  for (const [id,key] of [['tp','tp'],['fp-count','fp'],['fn-count','fn'],['tn','tn']]) el(id).textContent=result.counts[key].toFixed(1);
  const percent=p=>p===null ? 'undefined (nothing blocked)' : `${(p*100).toFixed(1)}%`;
  el('metrics').textContent=`Precision: ${percent(result.precision)}. Recall: ${percent(result.recall)}.`;
  const max=Math.max(...result.costs)*1000 || 1;
  const x=t=>65+630*t, y=v=>195-160*v/max;
  const points=result.costs.map((v,i)=>`${x(data.thresholds[i])},${y(v*1000)}`).join(' ');
  el('chart').innerHTML=`<title>Expected cost versus threshold; selected threshold ${result.threshold.toFixed(2)}</title><path d="M65 30V195H695" fill="none" stroke="#8995a3"/><text x="65" y="18" font-size="13">Cost units / 1,000 messages (0–${max.toFixed(0)})</text><polyline points="${points}" fill="none" stroke="#7757b3" stroke-width="3"/><circle cx="${x(result.threshold)}" cy="${y(result.cost*1000)}" r="6" fill="#155d76"/><text x="65" y="217" font-size="13">0</text><text x="682" y="217" font-size="13">1</text><text x="320" y="232" font-size="13">Blocking threshold</text>`;
}
for (const id of ['fp','fn','prevalence']) el(id).addEventListener('input',update);
update();
