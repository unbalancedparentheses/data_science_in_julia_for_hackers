# Tabular learning experiment

Run the standard-library tests from the repository root:

```sh
julia --startup-file=no 15_tabular_learning/runtests.jl
```

Install the pinned MLJ environment, then execute the model comparison and its
integration tests:

```sh
julia --project=15_tabular_learning -e 'using Pkg; Pkg.instantiate()'
julia --project=15_tabular_learning 15_tabular_learning/mlj_comparison.jl
julia --project=15_tabular_learning 15_tabular_learning/integration_tests.jl
```

Open `15_tabular_learning.jl` in Pluto to explore ridge penalties and tree depth.
It activates the chapter environment and uses PlutoUI controls. Install and
launch Pluto from your normal notebook environment. To smoke-test the notebook
with default control values:

```sh
julia --project=15_tabular_learning 15_tabular_learning/15_tabular_learning.jl
```

The notebook reports validation errors only. The comparison script runs a
predeclared seven-candidate search, chooses the lowest validation RMSE, and
reports final test performance for the selected machine and a mean baseline.
All learned preparation uses training rows only. The simulation has independent
rows; use grouped or chronological splits for data whose independent units are
customers, drivers, campaigns, or time periods.

The committed manifest was resolved with Julia 1.10.10 and pins MLJ 0.23.3,
MLJLinearModels 0.10.4, MLJDecisionTreeInterface 0.5.0, and PlutoUI 0.7.83.
The project declares the compatible minor release lines. Keep the manifest
when reproducing the examples; update it deliberately and rerun the tests.
