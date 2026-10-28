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

The original chapters use chapter-local `Project.toml` and `Manifest.toml`
files. Instantiate the chapter environment before opening its Pluto notebook.
For example, start Julia from the Chapter 4 directory:

```sh
cd 04_naive_bayes
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. -e 'using Pluto; Pluto.run()'
```

Open `04_naive_bayes.jl` in Pluto. The `.Rmd` book sources instead use paths
relative to the repository root. See [the publishing guide](documentation/Bookdown.md)
for rendering and verification instructions.

Chapters 14–17 share their executable algorithms between the book examples,
Pluto notebooks, and chapter-local tests. Their datasets are synthetic and
seeded, so the examples do not require external data downloads. Each chapter
explains the limits of those experiments. Start with its `.Rmd` file or notebook;
install its Julia environment when a `Project.toml` is present.

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
