export function expectedCounts(c, prevalence, n=1000) {
  const tp = n * prevalence * c.tp / (c.tp+c.fn);
  const fp = n * (1-prevalence) * c.fp / (c.fp+c.tn);
  return {tp, fp, tn:n*(1-prevalence)-fp, fn:n*prevalence-tp};
}
export function evaluate(data, fpCost, fnCost, prevalence) {
  if (!(fpCost >= 0 && fnCost >= 0 && prevalence >= 0 && prevalence <= 1)) throw Error('Invalid scenario');
  const counts = data.counts.map(c => expectedCounts(c, prevalence));
  const costs = counts.map(c => (fpCost*c.fp+fnCost*c.fn)/1000);
  let best = 0;
  costs.forEach((cost,i) => { if (cost < costs[best]) best=i; });
  const c=counts[best];
  return {threshold:data.thresholds[best], cost:costs[best], costs, counts:c,
    precision:c.tp+c.fp ? c.tp/(c.tp+c.fp) : null,
    recall:c.tp+c.fn ? c.tp/(c.tp+c.fn) : null};
}
