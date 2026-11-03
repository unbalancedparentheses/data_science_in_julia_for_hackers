// Recompute the Julia oracle in a temporary file, then compare numbers rather
// than requiring identical cross-platform floating-point serialization.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const root = path.resolve(__dirname, '../..');
const cases = {
  mars: ['06_gravity/mission/browser_fixtures.jl', 'docs/interactive/mars/julia-fixtures.json', null],
  evaluation: ['docs/interactive/evaluation/generate_fixture.jl', 'docs/interactive/evaluation/data.js', null],
  tabular: ['docs/interactive/tabular/generate_fixture.jl', 'docs/interactive/tabular/data.js', '15_tabular_learning'],
  causal: ['docs/interactive/causal/generate_fixtures.jl', 'docs/interactive/causal/fixtures.js', null],
  bayesian: ['docs/interactive/bayesian/generate_fixtures.jl', 'docs/interactive/bayesian/fixtures.js', '17_bayesian_workflow'],
};
function parse(file) {
  const text = fs.readFileSync(file, 'utf8');
  if (text.trimStart().startsWith('{') || text.trimStart().startsWith('[')) return JSON.parse(text);
  const match = text.match(/(?:export default|const \w+\s*=)\s*(\{[\s\S]*?\});(?:\n|$)/);
  assert.ok(match, `Unrecognized fixture wrapper: ${file}`);
  return JSON.parse(match[1]);
}
function compare(actual, expected, location = 'fixture') {
  if (typeof actual === 'number' && typeof expected === 'number') {
    assert.ok(Number.isFinite(actual) && Number.isFinite(expected));
    assert.ok(Math.abs(actual - expected) <= 1e-11 + 1e-10 * Math.abs(expected), `${location}: ${actual} differs from ${expected}`);
  } else if (Array.isArray(expected)) {
    assert.ok(Array.isArray(actual), location);
    assert.equal(actual.length, expected.length, location);
    expected.forEach((value, index) => compare(actual[index], value, `${location}[${index}]`));
  } else if (expected !== null && typeof expected === 'object') {
    assert.ok(actual !== null && typeof actual === 'object' && !Array.isArray(actual), location);
    assert.deepEqual(Object.keys(actual).sort(), Object.keys(expected).sort(), location);
    for (const key of Object.keys(expected)) compare(actual[key], expected[key], `${location}.${key}`);
  } else assert.deepEqual(actual, expected, location);
}
const name = process.argv[2];
if (name === '--self-test') {
  compare({ predictions: [1 + 1e-12], label: 'ridge' }, { predictions: [1], label: 'ridge' });
  assert.throws(() => compare({ predictions: [1.1] }, { predictions: [1] }));
  assert.throws(() => compare([1], [1, 2]));
  assert.throws(() => compare({ wrong: 1 }, { expected: 1 }));
  assert.throws(() => compare(NaN, 1));
  console.log('Fixture comparison accepts roundoff and rejects changed values, shapes, keys, and nonfinite values.');
} else {
  assert.ok(cases[name], `Choose fixture: ${Object.keys(cases).join(', ')}`);
  const [script, fixture, project] = cases[name];
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'julia-book-fixture-'));
  try {
    const output = path.join(directory, 'fixture.js');
    const args = ['--startup-file=no', ...(project ? [`--project=${project}`] : []), script, output];
    const run = spawnSync(process.env.JULIA || 'julia', args, { cwd: root, stdio: 'inherit', timeout: 300_000 });
    if (run.error) throw run.error;
    assert.equal(run.status, 0, 'Julia fixture generation failed');
    compare(parse(output), parse(path.join(root, fixture)));
    console.log(`${name}: committed browser fixture agrees with current Julia implementation.`);
  } finally {
    fs.rmSync(directory, { recursive: true, force: true });
  }
}
