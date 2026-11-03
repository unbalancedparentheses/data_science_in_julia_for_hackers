'use strict';
const inputs = ['angle', 'noise', 'budget'].map(id => document.getElementById(id));
const x = speed => 50 + 540 * speed / 8;
const svgNS = 'http://www.w3.org/2000/svg';
for (let speed = 0; speed <= 8; speed += 2) {
  const label = document.createElementNS(svgNS, 'text');
  label.setAttribute('x', x(speed)); label.setAttribute('y', 244);
  label.setAttribute('text-anchor', 'middle'); label.textContent = speed;
  document.getElementById('ticks').appendChild(label);
}
let previousKey = '', cached;
function update() {
  const [halfwidth, sigma, budget] = inputs.map(input => Number(input.value));
  ['angle-value', 'noise-value', 'budget-value'].forEach((id, i) => {
    document.getElementById(id).textContent = `${[halfwidth, sigma, budget][i]}${['°', ' m', ' km/s'][i]}`;
  });
  const key = `${halfwidth}/${sigma}`;
  if (key !== previousKey) { cached = MarsModel.posterior(halfwidth, sigma); previousKey = key; }
  const {interval, probability} = MarsModel.summary(cached, budget);
  const {speeds, density} = MarsModel.speedDensity(cached);
  const peak = Math.max(...density);
  document.getElementById('density').setAttribute('d', speeds.map((v, i) =>
    `${i ? 'L' : 'M'}${x(v).toFixed(3)},${(220 - 170 * density[i] / peak).toFixed(3)}`).join(' '));
  const band = document.getElementById('interval-band');
  band.setAttribute('x', x(interval[0])); band.setAttribute('width', x(interval[2]) - x(interval[0]));
  const line = document.getElementById('budget-line');
  line.setAttribute('x1', x(budget)); line.setAttribute('x2', x(budget));
  document.getElementById('result').textContent =
    `Middle 90% interval: ${interval[0].toFixed(2)}–${interval[2].toFixed(2)} km/s. ` +
    `Median: ${interval[1].toFixed(2)} km/s. ` +
    `Probability the ideal escape speed is at most the ${budget.toFixed(2)} km/s budget: ${(100 * probability).toFixed(1)}%.`;
}
inputs.forEach(input => input.addEventListener('input', update));
document.getElementById('controls').addEventListener('reset', () => requestAnimationFrame(update));
document.getElementById('controls').addEventListener('submit', event => event.preventDefault());
update();
