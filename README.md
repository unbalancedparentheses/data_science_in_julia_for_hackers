# DataScienceInJuliaForHackers.jl or Data Science in Julia for Hackers

How to cite this book (note you need to replace the _**highlighted**_ text with the date in which you retrieved the information):

Carrone, F., Nicolini, M., & Obst Demaestri, H. (2021). Data Science in Julia for Hackers. Retrieved _**October 6, 2021**_, from https://datasciencejuliahackers.com/

This book is a work in progress. Contributions and corrections are welcome.

You can visit the book page [here](https://datasciencejuliahackers.com/)

A book written by Federico Carrone, Herman Obst Demaestri and Mariano Nicolini, with a focus on applied knowledge and computational techniques,
written in the Julia language.

Thanks to Martina Cantaro, Camilo Plata, Manuel Puebla, Lucas Raúl Fernandez Piana, Osvaldo Martin, Iñaki Garay and Mariana Vinyolas.

## Table of contents

### Part I: Data Science and Julia
* [First chapter](https://datasciencejuliahackers.com/science-technology-and-epistemology.html): Science, technology, models and epistemology.

* [Second chapter](https://datasciencejuliahackers.com/meeting-julia.html): Introduction to the Julia programming language, showing examples of code and some first steps.

### Part II: Bayesian Statistics
* [Third chapter](https://datasciencejuliahackers.com/probability-introduction.html): An introduction to probability, probability distributions and Bayes' interpretation.

* [Fourth chapter](https://datasciencejuliahackers.com/spam-filter.html): Using a Naive-Bayes approach we construct a simple spam email filter.

* [Fifth chapter](https://datasciencejuliahackers.com/probabilistic-programming.html): An introduction to Probabilistic Programming and some simple examples using the Turing.jl package.

* [Sixth chapter](https://datasciencejuliahackers.com/escaping-from-mars.html): We estimate the gravity of Mars to compute the escape velocity, throwing stones and taking very simple measurements from it.

* [Seventh chapter](https://datasciencejuliahackers.com/football-simulation.html): We use a hierarchical bayesian model to estimate latent variables that describe Premier League´s football teams.

* [Eighth chapter](https://datasciencejuliahackers.com/basketball-shots.html): We analyze how the scoring probability is affected by some variables, such as the distance from the hoop and the angle of shooting.

* [Ninth chapter](https://datasciencejuliahackers.com/optimal-pricing.html): We solve a problem of optimal pricing optimization using a bayesian point of view.

### Part III: Deep Learning
* [Tenth chapter](https://datasciencejuliahackers.com/image-classification.html): Overview of Machine Learning and implementation of a simple convolutional neural network that is able to discriminate between pictures of bees and wasps.

### Part IV: Scientific Machine Learning
* [Eleventh chapter](https://datasciencejuliahackers.com/ultima-online.html): We explain the Ultima Online Catastrophe using differential equations to build a population dynamics model.

* [Twelfth chapter](https://datasciencejuliahackers.com/ultima-continued.html): A continuation of the Ultima Online Catastrophe, introducing the Universal Differential Equations to recover missing parts of scientific models.

### Part V: Time Series and Forecasting
* [Thirteenth chapter](https://datasciencejuliahackers.com/time-series.html): We lay the foundations for time series analysis, focusing on the exponential smoothing method.


### Part VI: Evaluating and Improving Models

* [Fourteenth chapter](https://datasciencejuliahackers.com/model-evaluation.html): How to know your model is wrong. We compare a spam-filter baseline, inspect calibration, choose a threshold on validation data, and reserve a final test set.

* [Fifteenth chapter](https://datasciencejuliahackers.com/tabular-learning.html): Learning from messy tabular data. We build a delivery-time predictor with training-only preprocessing, a linear baseline, and an MLJ tree comparison.

### Part VII: Causal Inference and Bayesian Workflow

* [Sixteenth chapter](https://datasciencejuliahackers.com/causal-inference.html): From prediction to intervention. We distinguish the association between price and demand from the effect of changing a price.

* [Seventeenth chapter](https://datasciencejuliahackers.com/bayesian-workflow.html): A complete Bayesian workflow. We revisit football goal counts with prior and posterior predictive checks, sampling diagnostics, and held-out predictive comparisons.

## Run the examples

### Try the controls without Julia

The built site embeds five experiments directly in the Mars, model-evaluation,
tabular-learning, causal-inference, and Bayesian-workflow chapters. They run
entirely in the browser on a static host such as GitHub Pages. No Pluto session,
Julia installation, account, or backend is needed to move their controls.

Preview this branch locally:

```sh
python3 -m http.server 8767 --directory docs
```

Open `http://localhost:8767/` and follow the chapter links, or visit
`http://localhost:8767/interactive/mars/`. The delivery demo selects predictions
from Julia/MLJ models fitted ahead of time; it does not train models in JavaScript.
The other demos calculate their displayed models in the browser. Julia-generated
fixtures and real-browser tests check the results and interactions.

### Your first experiment

The newer examples are tested with Julia 1.10.10. From the repository root,
start `julia --startup-file=no` and paste this small experiment. It uses only
Julia's standard libraries, so it needs no package or dataset downloads:

```julia
include("14_model_evaluation/core.jl")
using .ModelEvaluation
labels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
delivered_everything = confusion(labels, zeros(10))
metrics(delivered_everything)
```

Before running it, make a prediction: how accurate is a filter that never
blocks a message? The result has accuracy `0.9`, recall `0.0`, and precision
`missing`: it caught no spam and never made a positive prediction. Now change
`zeros(10)` to `ones(10)`. Which mistakes disappeared, and which appeared?
[Chapter 14](14_model_evaluation.Rmd) turns that question into a decision about
the costs of blocking a customer's email.

For sliders and editable experiments, launch the pinned Pluto environment:

```sh
julia --project=tests/pluto -e 'using Pkg; Pkg.instantiate()'
julia --project=14_model_evaluation -e 'using Pkg; Pkg.instantiate()'
julia --project=tests/pluto -e 'using Pluto; Pluto.run()'
```

Open `14_model_evaluation/14_model_evaluation.jl` from Pluto's start page. The
first installation downloads packages and compiles them; subsequent launches
reuse that work. The book's HTML pages show the reading material; running and
editing a notebook happens in Pluto. To open another companion, instantiate
its chapter environment in the same way first.

If `julia` is not found, install Julia and make its executable available on
your shell's path. If an `include` cannot find a file, check that `pwd()` is
the repository root. For a missing package, rerun the matching chapter's
`Pkg.instantiate()` command and let it finish before opening the notebook.

### Choose a journey

You can read the book in order, or follow a question through several projects:

| Your question | Build it | Challenge it |
|:--|:--|:--|
| Can we catch spam without losing important mail? | Chapter 4: build a filter | Chapter 14: inspect mistakes, probabilities, and costs |
| Can measurements get us home from Mars? | Chapter 6: estimate gravity and escape speed | Change the measurement uncertainty and ask how confident the decision is |
| Can we predict football results? | Chapter 7: model teams and matches | Chapter 17: test a simpler goal model and discover what it misses |
| What happens if we change a price? | Chapter 9: optimize under uncertainty | Chapter 16: distinguish a prediction from an intervention |
| Can we predict delivery times from messy records? | Chapter 15: prepare data and compare models | Use Chapter 14's separation of training, validation, and final testing |

Start with Chapters 2–3 if Julia or probability is new to you. The return
visits use smaller synthetic experiments to isolate an idea; they do not
replace the earlier projects' real-data investigations.

Use the [chapter challenge guide](documentation/Challenges.md) to practice
with the earlier projects: predict an outcome, change an experiment, and build
something of your own. Each sequence includes hints and worked reasoning.
Mars and Chapters 14–17 include their exercises in the chapter itself.

### Original chapter environments

Several original chapters include historical chapter-local `Project.toml` and
`Manifest.toml` files. These are not all verified on current Julia. The
standard-library first experiment above, Chapters 14–17, and the
[Mars mission companion](06_gravity/mission/README.md) are the maintained,
tested starting points for this edition.

Chapter 4 declares Pluto in its own environment (its manifest pins Pluto
0.19.16). To try that historical setup, start from the repository root:

```sh
cd 04_naive_bayes
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. -e 'using Pluto; Pluto.run()'
```

Open `04_naive_bayes.jl` in Pluto. The original notebooks generally read assets
relative to their chapter directory, whereas the `.Rmd` book sources use paths
relative to the repository root. Also, the old notebooks do not explicitly
activate their chapter environment or embed their own dependency manifests.
Pluto's automatic notebook package management may therefore resolve a separate
environment; launching Pluto from a chapter project does not by itself prove
that its notebook uses those historical package versions. Full execution of
all legacy notebooks has not been verified.

Chapter 3 now has a separate environment with explicit package versions. Its
resolution and installation were checked with Julia 1.10.10. From the repository
root, you can install it and run the headless package/data smoke check:

```sh
julia --project=03_probability_intro -e 'using Pkg; Pkg.instantiate()'
julia --project=03_probability_intro 03_probability_intro/smoke_test.jl
```

This check loads the rainfall table, resizes a bundled image, and renders a
Poisson plot; it does not run the complete chapter or validate Pluto reactivity.
The five smoke assertions passed locally with Julia 1.10.10 after allowing
initial package compilation to finish. This is a package/data/plot check, not
a claim that the complete legacy chapter runs end to end.

Two concrete setup problems remain in the historical environments:

- Chapter 2 imports `CSV` but does not declare it. A narrow addition of CSV
  0.8.5 preserving every existing dependency failed because the locked
  `FFMPEG_jll` 4.3.1 and `OpenSSL_jll` 1.1.1 requirements conflict under the
  current registry. Repairing it requires a separately tested environment migration.
- Chapter 12 imports `StatsPlots` but does not declare it. A narrow addition
  preserving existing dependencies stopped at the historical, locally missing
  `DataDrivenDiffEq` 0.4.0 git-tree checkout recorded in its manifest. This is
  a setup blocker in our clean environment, not proof that the upstream commit
  is gone. Its legacy scientific-model stack needs a separate compatibility check.

These checks ran with Julia 1.10.10 and did not upgrade the historical manifests.
For book rendering and verification, see [the publishing guide](documentation/Bookdown.md).

Chapters 14–17 share their executable algorithms between the book examples,
Pluto notebooks, and chapter-local tests. Their datasets are synthetic and
seeded, so the examples do not require external data downloads. Each chapter
explains the limits of those experiments. Start with its `.Rmd` file or notebook;
install its Julia environment when a `Project.toml` is present.

### Preview the website locally

```sh
python3 -m http.server 8767 --bind 127.0.0.1 --directory docs
```

Visit <http://localhost:8767>. Keep the terminal open while reading; stop the
server with Ctrl-C. A full checkout includes the published plot images. If
you use sparse checkout, include `docs/data_science_in_julia_for_hackers_files/`
as well as the HTML files, or those plots will appear broken locally.

## Validate changes

From the repository root:

```sh
julia --project=tests -e 'using Pkg; Pkg.instantiate()'
julia --project=tests tests/runtests.jl
python3 -m unittest discover -s tests -p 'test_*.py'
```

Run the new chapters' checks and the MLJ comparison from the same directory:

```sh
julia 14_model_evaluation/runtests.jl
julia 15_tabular_learning/runtests.jl
julia 16_causal_inference/test.jl
julia --project=15_tabular_learning -e 'using Pkg; Pkg.instantiate()'
julia --project=15_tabular_learning 15_tabular_learning/integration_tests.jl
julia --project=15_tabular_learning 15_tabular_learning/mlj_comparison.jl
julia --project=17_bayesian_workflow -e 'using Pkg; Pkg.instantiate()'
julia --project=17_bayesian_workflow 17_bayesian_workflow/test.jl
```

These are focused regression checks, not a full execution of every notebook.
The CI workflow runs these checks as well. Do not carry old numerical results
forward after changing an algorithm; rerun the example or remove the obsolete
output.

To check the interactive notebooks inside Pluto (including slider updates),
follow [the Pluto runtime test instructions](tests/pluto/README.md). Running a
notebook as an ordinary Julia script checks its default values but does not
verify reactivity. CI runs both the algorithm checks and the native Pluto test.
