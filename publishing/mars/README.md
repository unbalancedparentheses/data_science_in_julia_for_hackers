# Preserved Mars computations

`legacy-chunks.json` records the 29 Julia chunk inputs and their existing
rendered HTML from commit `2a4fbe2`. The visible code and all 15 figure references
are preserved, including their original anchors. These are historical outputs,
not claims of a new Turing run.

From the repository root, use Quarto 1.10.19 (or its bundled Pandoc):

```sh
python3 scripts/render_mars_teaching.py
python3 scripts/update_navigation.py
python3 scripts/update_search.py
python3 scripts/render_mars_teaching.py --check
```

The renderer typesets the current chapter's prose and new teaching snippets,
then restores archived computed chunks. It refuses to proceed if any archived
chunk's input changes or disappears. A deliberate change to legacy model code
therefore requires executing that model, reviewing the new outputs, and updating
the archive together. Do not change the archive merely to silence this check.
The lightweight companion tests validate the new teaching computations; they do
not revalidate historical sampling output.
