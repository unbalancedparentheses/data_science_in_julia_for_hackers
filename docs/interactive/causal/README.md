# Causal browser experiment

Open `index.html` directly, or serve `docs` with any static HTTP server. All assets are local; no server-side Julia, CDN, analytics, fetch, or external runtime dependency is used. Keep the assets together when publishing under a GitHub Pages subpath.

From the repository root, regenerate fixtures with Julia 1.10:

```sh
julia docs/interactive/causal/generate_fixtures.jl
node docs/interactive/causal/test.js
```

The committed fixture is generated from the existing chapter core. The Node test compares every numerical output against independently evaluated Julia results at every available control setting, with absolute tolerance 1e-10. It does not establish browser accessibility or causal/model validity; the interface includes its model assumptions.

The fixture contains the Julia-seeded 4,000-observation population and uniform assignments. JavaScript computes outcomes, sample variances, historical and randomized differences, and demand-standardized differences from those inputs. Ten slider settings (50% through 95%, in five-point increments) each check all effect estimates, standard errors, interval endpoints and cell counts. The true individual effect is −20. Reusing fixed uniform draws isolates the pricing-rule change rather than introducing fresh simulation noise.
