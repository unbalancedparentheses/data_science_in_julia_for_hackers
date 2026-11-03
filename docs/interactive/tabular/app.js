import data from './data.js';
import {compare} from './model.js';
const el=id=>document.getElementById(id);
function update() {
  const penalty=+el('penalty').value, depth=+el('depth').value;
  el('depth-value').textContent=depth;
  const models=compare(data,penalty,depth);
  const names=['Training mean','Linear',`Ridge (${penalty})`,`Tree (depth ${depth})`];
  el('summary').textContent=`Ridge penalty ${penalty} and tree depth ${depth}, compared on all ${data.observed.length} validation deliveries.`;
  el('scores').innerHTML=models.map((m,i)=>`<tr><th scope="row">${names[i]}</th><td>${m.rmse.toFixed(2)}</td></tr>`).join('');
  const chartNames=['Mean','Linear','Ridge','Tree'];
  const colors=['#8090a4','#8090a4','#197888','#7757b3'];
  const maxError=Math.max(...models.map(m=>m.rmse))*1.12;
  el('bars').innerHTML=`<title>Validation errors in minutes; lower is better</title>`+models.map((m,i)=>`<text x="5" y="${28+i*40}" font-size="14">${chartNames[i]}</text><rect x="160" y="${10+i*40}" width="${475*m.rmse/maxError}" height="25" fill="${colors[i]}"/><text x="${170+475*m.rmse/maxError}" y="${28+i*40}" font-size="13">${m.rmse.toFixed(2)}</text>`).join('');
  // Keep axes fixed across controls so visual changes describe the model, not a rescale.
  const limit=Math.ceil(Math.max(...data.observed,...data.ridge.flatMap(m=>m.predictions),...data.trees.flatMap(m=>m.predictions))/10)*10;
  const x=v=>85+605*v/limit, y=v=>330-290*v/limit;
  const ticks=Array.from({length:5},(_,i)=>limit*i/4);
  const grid=ticks.map(value=>`<line x1="85" x2="690" y1="${y(value)}" y2="${y(value)}" stroke="#e0e5ed"/><line x1="${x(value)}" x2="${x(value)}" y1="40" y2="330" stroke="#e0e5ed"/><text x="70" y="${y(value)+5}" text-anchor="end" font-size="15">${value}</text><text x="${x(value)}" y="357" text-anchor="middle" font-size="15">${value}</text>`).join('');
  const circles=models.slice(2).map((model,j)=>model.predictions.map((p,i)=>`<circle cx="${x(data.observed[i])}" cy="${y(p)}" r="2.5" fill="${colors[j+2]}" opacity=".4"/>`).join('')).join('');
  el('scatter').innerHTML=`<title>All validation deliveries: ridge teal, tree purple. Axes from zero to ${limit} minutes.</title>${grid}<path d="M85 40V330H690" fill="none" stroke="#8995a3"/><path d="M85 330L690 40" stroke="#667788" stroke-dasharray="5 5"/>${circles}<text x="85" y="25" font-size="15">Predicted minutes</text><text x="387" y="390" text-anchor="middle" font-size="15">Observed minutes</text>`;
}
el('penalty').addEventListener('change',update); el('depth').addEventListener('input',update); update();
