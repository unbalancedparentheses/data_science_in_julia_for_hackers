# Browser evaluation experiment

Serve the repository's `docs` directory and open `interactive/evaluation/`.
The demo uses only local static assets. `model.js` implements the chapter's
label-shift reweighting and first-minimum threshold rule in JavaScript.

Generate its validation counts and reference scenarios with Julia, then test
the browser calculations from the repository root:

```sh
julia docs/interactive/evaluation/generate_fixture.jl
node docs/interactive/evaluation/test.mjs
```

To check freshness without modifying the committed fixture:

```sh
julia docs/interactive/evaluation/generate_fixture.jl /tmp/evaluation-reference.mjs
node scripts/browser/compare_fixture.mjs docs/interactive/evaluation/data.js /tmp/evaluation-reference.mjs
```

Only training and validation data participate. The interactive demo does not
expose the final test labels or results. Eighteen reference scenarios cover
the endpoint costs and prevalences, plus the notebook's default prevalence.
