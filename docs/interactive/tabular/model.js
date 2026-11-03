export function rmse(observed,predicted) {
  if (!observed.length || observed.length!==predicted.length) throw Error('Matching nonempty observations required');
  return Math.sqrt(observed.reduce((sum,y,i)=>sum+(y-predicted[i])**2,0)/observed.length);
}
export function compare(data,penalty,depth) {
  const ridge=data.ridge.find(m=>m.penalty===penalty);
  const tree=data.trees.find(m=>m.depth===depth);
  if (!ridge || !tree) throw Error('Unknown model setting');
  return [data.baseline,data.linear,ridge,tree].map(m=>({...m,rmse:rmse(data.observed,m.predictions)}));
}
