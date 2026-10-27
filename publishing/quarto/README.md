# Julia publishing pilot

This small Quarto report executes the same standard-library-only core used in
chapter 14. It tests native Julia execution, equations, code display, and an
HTML artifact without migrating the existing Bookdown book.

Requirements: Julia 1.10 and Quarto 1.10.19. Put `julia` on `PATH` (or configure
Quarto's `QUARTO_JULIA` environment variable), then run from the repository root:

```sh
quarto render publishing/quarto
```

The first render downloads QuartoNotebookRunner into Quarto's managed Julia
environment. The chapter environment itself uses only Julia standard libraries.
The report is written to `_site/decision-costs.html`; generated output and
Quarto's local state are ignored by Git. The native `julia` engine is selected
explicitly in `_quarto.yml` so a Python/Jupyter installation is unnecessary.

The report must fail when a Julia cell errors (`execute.error: false`). CI
renders this pilot separately from the legacy chapters. The full Bookdown build
still requires its documented R and Julia dependencies.

Quarto documentation: <https://quarto.org/docs/computations/julia.html>.
