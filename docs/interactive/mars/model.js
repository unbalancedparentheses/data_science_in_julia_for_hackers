/* Same discrete posterior as 06_gravity/mission/core.jl; no network dependencies. */
(function (root) {
  'use strict';
  const distances = [25.94, 38.84, 52.81, 45.54, 17.24];
  const times = [3.91, 4.57, 5.43, 4.85, 3.15];
  const escapeSpeed = g => 11 * Math.sqrt(g / (2 * 9.8));
  function posterior(halfwidth = 7.5, sigma = 3) {
    if (!Number.isFinite(halfwidth) || halfwidth < 0 || halfwidth > 15 ||
        !Number.isFinite(sigma) || sigma < 1 || sigma > 10) {
      throw new RangeError('Angle half-width must be 0–15 degrees and range noise 1–10 metres.');
    }
    const gs = Array.from({length: 500}, (_, i) => (i + 1) * 0.02);
    const angles = halfwidth === 0 ? [45] : Array.from({length: 61}, (_, j) =>
      45 - halfwidth + (j + 0.5) * 2 * halfwidth / 61);
    const logweights = gs.map(g => angles.map(a => {
      const tangent = Math.tan(a * Math.PI / 180);
      let sum = 0;
      for (let i = 0; i < times.length; i++) {
        const residual = (distances[i] - g * times[i] ** 2 / (2 * tangent)) / sigma;
        sum += residual ** 2;
      }
      return -sum / 2;
    }));
    let maximum = -Infinity;
    for (const row of logweights) for (const value of row) maximum = Math.max(maximum, value);
    const masses = logweights.map(row => row.reduce((sum, value) => sum + Math.exp(value - maximum), 0));
    const total = masses.reduce((sum, mass) => sum + mass, 0);
    return {gs, masses: masses.map(mass => mass / total)};
  }
  function summary(result, budget = 5) {
    if (!Number.isFinite(budget)) throw new RangeError('Speed budget must be finite.');
    const speeds = result.gs.map(escapeSpeed);
    const total = result.masses.reduce((sum, mass) => sum + mass, 0);
    const interval = [0.05, 0.5, 0.95].map(q => {
      let cumulative = 0;
      for (let i = 0; i < speeds.length; i++) {
        cumulative += result.masses[i];
        if (cumulative >= q * total) return speeds[i];
      }
      return speeds[speeds.length - 1];
    });
    const probability = result.masses.reduce((sum, mass, i) => sum + (speeds[i] <= budget ? mass : 0), 0);
    return {interval, probability};
  }
  function speedDensity(result) {
    const gs = result.gs;
    const edges = [gs[0] - (gs[1] - gs[0]) / 2];
    for (let i = 0; i < gs.length - 1; i++) edges.push((gs[i] + gs[i + 1]) / 2);
    edges.push(gs[gs.length - 1] + (gs[gs.length - 1] - gs[gs.length - 2]) / 2);
    const speedEdges = edges.map(escapeSpeed);
    return {speeds: gs.map(escapeSpeed), widths: speedEdges.slice(1).map((e, i) => e - speedEdges[i]),
      density: result.masses.map((mass, i) => mass / (speedEdges[i + 1] - speedEdges[i]))};
  }
  const api = {posterior, summary, speedDensity};
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.MarsModel = api;
})(typeof globalThis === 'object' ? globalThis : this);
