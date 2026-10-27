## Bookdown installation

Install R, RStudio, and the R packages `bookdown` and `JuliaCall`. Install Julia
and instantiate the chapter environment before rendering, for example:

```sh
julia --project=04_naive_bayes -e 'using Pkg; Pkg.instantiate()'
```

The chapter `Project.toml` and `Manifest.toml` files record the dependencies used
by the examples. The historical environments include older packages; the fast
regression suite below is separate from a full book render.

## Workflow

1. Edit the chapter's `.Rmd` file and its corresponding Pluto `.jl` notebook.
   Keep shared algorithms and explanations in sync.
2. Run the chapter's code from the repository root. Bookdown setup cells activate
   the chapter environment without changing directories, so all chapter data
   paths remain relative to the repository root. Pluto notebooks use their own
   chapter-relative paths.
3. In RStudio, with the repository root as the working directory, render the
   chapter:

   ```r
   bookdown::preview_chapter("04_naive_bayes.Rmd")
   ```

   Rendering individual chapters avoids rerunning all the expensive examples.
   Inspect the resulting page in `docs/`, including plots and code output.
4. Regenerate the common navigation and search index from the published pages,
   then check local links:

   ```sh
   python3 scripts/update_navigation.py
   python3 scripts/update_search.py
   python3 scripts/check_site.py
   ```

   Do not copy a sidebar from another chapter by hand: it may contain outdated
   section anchors. When adding a chapter, update `CHAPTERS` and `PARTS` in
   `scripts/update_navigation.py`; search uses that same chapter list.
5. Commit the source and the updated generated pages together. If an algorithm
   changes, rerun its outputs or remove obsolete numerical results rather than
   presenting results from the old implementation.

## Fast regression checks

The focused Julia tests require Julia 1.10 and the small `tests/` environment.
They exercise the actual classifier definitions in the book, notebook, and
standalone script. Image-helper tests exercise filesystem and error propagation
with lightweight codec stubs; they do not train the convolutional network.

```sh
julia --project=tests -e 'using Pkg; Pkg.instantiate()'
julia --project=tests tests/runtests.jl
python3 -m unittest discover -s tests -p 'test_*.py'
git diff --check
```

These checks cover classifier priors, repeated words, long emails, optional word
limits, empty inputs, image output directories, navigation structure, local
links, search coverage, and published algorithm/source consistency. They do not
replace executing the full notebooks and inspecting rendered chapters.

## Render the new chapters

Chapters 14–17 have a lightweight publishing path that uses Pandoc (standalone
or bundled with Quarto) to typeset the `.Rmd` prose and Julia code into the
existing GitBook layout:

```sh
python3 scripts/render_new_chapters.py
python3 scripts/update_navigation.py
python3 scripts/update_search.py
python3 scripts/render_new_chapters.py --check
python3 -m unittest discover -s tests -p 'test_*.py'
```

Set `PANDOC` to a Pandoc executable or `QUARTO` to a Quarto executable when it is
not on `PATH`. CI uses Quarto 1.10.19 so the bundled Pandoc version is fixed.
The renderer does not execute Julia or invent output: the
chapter-local Julia tests validate the computations separately. CI runs both
the computation tests and the publishing checks. Generated pages are committed
alongside their sources so GitHub Pages can serve them directly.
