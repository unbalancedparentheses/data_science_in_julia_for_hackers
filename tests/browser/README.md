# Static chapter browser checks

These tests launch real headless Chromium against a local static HTTP server.
They visit all five standalone demos and their published chapter iframes, move
every slider/select with browser actions, verify calculated results and charts
change, check phone-width layout, and fail on uncaught JavaScript or missing
demo assets. External runtimes/CDNs are blocked in the interaction tests.
The model-specific Node/Julia fixture checks separately verify numerical values.

From the repository root (Node 22 and Python 3):

```sh
npm ci --prefix tests/browser --ignore-scripts
cd tests/browser
npx playwright install chromium
npm test
```

CI installs Linux browser libraries with `npx playwright install --with-deps
chromium`. Playwright and its browser revision are pinned through the lockfile.
The server uses port 8768 and serves `docs/`; no Julia server is started.
Failure screenshots and traces appear in `tests/browser/test-results/`.

To recheck saved browser fixtures against the current Julia implementations,
run `node scripts/browser/check_fixture.cjs NAME` from the repository root, with
NAME one of `mars`, `evaluation`, `tabular`, `causal`, or `bayesian`. Set `JULIA`
to an executable path when Julia is not on PATH. Install the tabular/Bayesian
chapter environments first. The checker writes only to a temporary directory
and tolerates small floating-point differences across platforms; changed
predictions, shapes, or model settings fail the check. CI runs these checks in
the corresponding Julia jobs and all JavaScript parity tests in the browser job.
