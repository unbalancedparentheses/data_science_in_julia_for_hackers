# Reactive notebook regression tests

These tests use Pluto 0.20.28's own notebook loader, isolated Julia workers,
native bond registry, and reactive update API. They open all four new notebooks,
check that no cells fail, send one browser-side slider value to each notebook,
and assert that the bound value and a dependent result both change. Notebook
files must remain unchanged. No browser or public web server is required;
Pluto's local worker processes require loopback socket access.

From the repository root, instantiate the test environment and each notebook
environment, then run the suite:

```sh
julia --project=tests/pluto -e 'using Pkg; Pkg.instantiate()'
julia --project=14_model_evaluation -e 'using Pkg; Pkg.instantiate()'
julia --project=15_tabular_learning -e 'using Pkg; Pkg.instantiate()'
julia --project=16_causal_inference -e 'using Pkg; Pkg.instantiate()'
julia --project=17_bayesian_workflow -e 'using Pkg; Pkg.instantiate()'
julia --project=tests/pluto tests/pluto/runtests.jl
python3 tests/test_pluto_notebooks.py
```

The companion Python check ensures that script-only `@bind` fallback macros
remain in the file preamble, outside every Pluto cell. A fallback inside a cell
can replace Pluto's real macro: controls still render and scripts still run,
but the widget no longer registers a native bond. Plain-script smoke tests
alone do not catch this regression.

The Pluto version is pinned because the headless test uses internal APIs.
Update it deliberately and rerun both the loader and reactive-update tests.
