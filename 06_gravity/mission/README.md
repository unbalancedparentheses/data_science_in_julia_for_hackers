# Mars mission companion

A small reproducible companion to chapter 6. The calculation uses Julia's standard
library only and is separate from the historical Turing/Plots chapter environment.
Tested with Julia 1.10.10.

From the repository root:

```sh
julia --startup-file=no 06_gravity/mission/runtests.jl
julia --startup-file=no 06_gravity/mission/notebook.jl
```

The notebook includes a responsive SVG of the escape-speed posterior, its middle
90% interval, and the hypothetical speed budget. Its density accounts for the
unequal speed widths produced by transforming uniform gravity cells.

The second command checks the notebook at default controls; a plain script does
not display Markdown cells. To print its result:

```sh
julia --startup-file=no -e 'include("06_gravity/mission/notebook.jl"); println(decision)'
```

For interactive controls, open `notebook.jl` in an existing Pluto installation.
If needed, install Pluto in a separate environment (not the legacy chapter project):

```sh
julia --project=@mars-pluto -e 'using Pkg; Pkg.add(name="Pluto", version="0.20.28"); using Pluto; Pluto.run()'
```

`core.jl` contains the shared physics and normalized grid calculation. The notebook
calls it directly. The posterior uses a uniform gravity grid from 0.02 to 10 m/s²,
a uniform shared angle interval, and independent Normal range errors at a fixed
standard deviation. Time, radius ratio, and the noise scale are not inferred.
The tests compare known-angle inference with its analytic Gaussian likelihood,
check physical scaling and parameter guards, and compare two grid resolutions.

Before touching the sliders, predict which change will matter. Then compare two
experiments with only one control changed. The speed budget is a hypothetical
constraint for the chapter's idealized decision, not a prediction of launch success.
