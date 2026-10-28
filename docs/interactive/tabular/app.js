import data from './data.js';
import {compare} from './model.js';
const el=id=>document.getElementById(id);
function update() {
  const penalty=+el('penalty').value, depth=+el('depth').value;
  el('depth-value').textContent=depth;
  const models=compare(data,penalty,depth);
  const names=['Training mean','Linear',`Ridge (${penalty})`,`Tree (depth ${depth})`];
  el('summary').textContent=`Ridge: ${models[2].rmse.toFixed(2)} minutes RMSE. Tree: ${models[3].rmse.toFixed(2)} minutes RMSE.`;
  el('scores').innerHTML=models.map((m,i)=>`<tr><th scope="row">${names[i]}</th><td>${m.rmse.toFixed(2)}</td></tr>`).join('');
  const chartNames=['Mean','Linear','Ridge','Tree'];
  const colors=['#8090a4','#8090a4','#197888','#7757b3'];
  const maxError=Math.max(...models.map(m=>m.rmse))*1.12;
  el('bars').innerHTML=`<title>Validation errors in minutes; lower is better</title>`+models.map((m,i)=>`<text x="5" y="${32+i*44}" font-size="14">${chartNames[i]}</text><rect x="160" y="${15+i*44}" width="${475*m.rmse/maxError}" height="25" fill="${colors[i]}"/><text x="${170+475*m.rmse/maxError}" y="${33+i*44}" font-size="13">${m.rmse.toFixed(2)}</text>`).join('');
  // Keep axes fixed across controls so visual changes describe the model, not a rescale.
  const limit=Math.ceil(Math.max(...data.observed,...data.ridge.flatMap(m=>m.predictions),...data.trees.flatMap(m=>m.predictions))/10)*10;
  const x=v=>60+620*v/limit, y=v=>295-255*v/limit;
  const circles=models.slice(2).map((model,j)=>model.predictions.map((p,i)=>`<circle cx="${x(data.observed[i])}" cy="${y(p)}" r="2.5" fill="${colors[j+2]}" opacity=".4"/>`).join('')).join('');
  el('scatter').innerHTML=`<title>All validation deliveries: ridge teal, tree purple. Axes from zero to ${limit} minutes.</title><path d="M60 40V295H680" fill="none" stroke="#8995a3"/><path d="M60 295L680 40" stroke="#8995a3" stroke-dasharray="5 5"/>${circles}<text x="60" y="22" font-size="13">Predicted minutes (0–${limit})</text><text x="60" y="315" font-size="13">0</text><text x="660" y="315" font-size="13">${limit}</text><text x="280" y="340" font-size="13">Observed minutes</text>`;
}
el('penalty').addEventListener('change',update); el('depth').addEventListener('input',update); update();
