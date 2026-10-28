# Browser delivery experiment

Serve `docs` and open `interactive/tabular/`. No backend, package download, or
remote API is needed by the reader. Julia/MLJ fit the fixed set of models;
JavaScript selects their saved validation predictions, computes RMSE, and
draws the comparison. The interface explicitly distinguishes these saved fits
from training a new model in the browser.

From the repository root, instantiate the existing Chapter 15 environment and
regenerate the fixture:

```sh
julia --project=15_tabular_learning -e 'using Pkg; Pkg.instantiate()'
julia --project=15_tabular_learning docs/interactive/tabular/generate_fixture.jl
node docs/interactive/tabular/test.mjs
```

The generator uses the same rows, training-only preparation, seeds, ridge
penalties, and tree depths as the Pluto notebook. All 35 combinations of its
controls are tested against Julia RMSE values; no final test outcomes are
included. To verify freshness without replacing the file:

```sh
julia --project=15_tabular_learning docs/interactive/tabular/generate_fixture.jl /tmp/tabular-reference.mjs
node scripts/browser/compare_fixture.mjs docs/interactive/tabular/data.js /tmp/tabular-reference.mjs
```
