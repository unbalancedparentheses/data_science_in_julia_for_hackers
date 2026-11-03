# Static Mars mission

Open `index.html` directly or serve `docs/` and visit `/interactive/mars/`.
All runtime assets are relative and local; no package installation, Julia server,
CDN, or external requests are needed by a reader. The Pluto companion remains in
`06_gravity/mission/notebook.jl`.

The browser model implements the same 500 gravity cells and 61 midpoint angle
cells as `06_gravity/mission/core.jl`. Nine Julia-generated complete posterior
grids cover angle half-widths 0, 7.5, 15 and range standard deviations 1, 3, 10;
three speed budgets per grid give 27 comparisons, including control bounds.

From the repository root:

```sh
julia --startup-file=no 06_gravity/mission/browser_fixtures.jl
node docs/interactive/mars/model.test.cjs
npm ci --prefix tests/browser
node docs/interactive/mars/browser.test.cjs
```

If Chromium is not installed for Playwright, run
`tests/browser/node_modules/.bin/playwright install chromium` first.
The browser test uses keyboard controls, checks real result changes, verifies that
the budget changes only the decision (not the posterior), checks reset/mobile
overflow/runtime errors, and saves screenshots in the OS temporary directory.

Fixtures are a numerical regression oracle, not runtime data. `model.js` computes
the posterior in the browser; changing an input does not look up canned outputs.
Density uses transformed cell widths so the plotted horizontal axis genuinely
represents speed. The model's idealized physics and fixed-data assumptions are
listed in the page. No actual spacecraft reliability claim is made.
