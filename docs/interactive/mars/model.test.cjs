'use strict';
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const model = require('./model.js');
const fixtures = JSON.parse(fs.readFileSync(path.join(__dirname, 'julia-fixtures.json'), 'utf8'));
function near(actual, expected, tolerance = 2e-12) {
  assert.ok(Number.isFinite(actual) && Math.abs(actual - expected) <= tolerance,
    `${actual} != ${expected} (tolerance ${tolerance})`);
}
for (const fixture of fixtures) {
  const result = model.posterior(fixture.halfwidth, fixture.sigma);
  assert.equal(result.masses.length, fixture.masses.length);
  result.masses.forEach((mass, i) => near(mass, fixture.masses[i]));
  near(result.masses.reduce((a, b) => a + b, 0), 1);
  [3, 5, 7].forEach((budget, j) => {
    const summary = model.summary(result, budget);
    summary.interval.forEach((value, i) => near(value, fixture.interval[i]));
    near(summary.probability, fixture.probabilities[j]);
  });
  const density = model.speedDensity(result);
  near(density.density.reduce((sum, d, i) => sum + d * density.widths[i], 0), 1);
  assert.ok(density.density.every(d => Number.isFinite(d) && d >= 0));
}
assert.throws(() => model.posterior(-1, 3), RangeError);
assert.throws(() => model.posterior(7.5, 0), RangeError);
assert.throws(() => model.posterior(NaN, 3), RangeError);
const defaultModel = model.posterior();
near(model.summary(defaultModel, 0).probability, 0);
near(model.summary(defaultModel, 100).probability, 1);
console.log(`Mars browser model: ${fixtures.length} full posterior grids, 27 slider combinations match Julia; density and input checks passed.`);
