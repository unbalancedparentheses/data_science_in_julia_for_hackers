# Model evaluation experiment

Run the standard-library regression tests from the repository root:

```sh
julia --startup-file=no 14_model_evaluation/runtests.jl
```

To use the interactive notebook, instantiate its environment and open
`14_model_evaluation.jl` with Pluto:

```sh
julia --project=14_model_evaluation -e 'using Pkg; Pkg.instantiate()'
```

The notebook activates this chapter environment explicitly and imports PlutoUI.
Install and launch Pluto from your normal notebook environment. It can also be
smoke-tested as a script using the controls' default values:

```sh
julia --project=14_model_evaluation 14_model_evaluation/14_model_evaluation.jl
```

`core.jl` is the shared implementation used by the chapter, notebook, and tests.
The prevalence control reweights class-conditional validation error rates under
an explicit label-shift assumption. It does not claim that the original scores
remain calibrated after prevalence changes. No notebook controls expose the
final test outcomes.

The committed manifest was resolved with Julia 1.10.10 and PlutoUI 0.7.83.
The standard-library tests do not require Pluto or PlutoUI.
