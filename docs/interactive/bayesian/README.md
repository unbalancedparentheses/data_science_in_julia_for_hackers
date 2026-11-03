# Bayesian browser experiment

Open `index.html` directly, or serve `docs` with any static HTTP server. All assets are local; no server-side Julia, CDN, analytics, fetch, or external runtime dependency is used. Keep the assets together when publishing under a GitHub Pages subpath.

From the repository root, regenerate fixtures with Julia 1.10:

```sh
julia --project=17_bayesian_workflow docs/interactive/bayesian/generate_fixtures.jl
node docs/interactive/bayesian/test.js
```

The committed fixture is generated from the existing chapter core. The Node test compares every numerical output against independently evaluated Julia results at every available control setting, with absolute tolerance 1e-10. It does not establish browser accessibility or causal/model validity; the interface includes its model assumptions.

The fixture contains the Julia-seeded football scores and exact `Distributions.jl` negative-binomial probabilities. Five prior strengths × two prediction modes cover ten states. Tests check Gamma shape/rate, predictive mean/variance, probabilities for goals 0–10, and the complete 11+ tail. JavaScript evaluates the probability recurrence analytically; it does not sample posterior chains or estimate MCMC diagnostics. Orange observed frequencies are descriptive training-data comparisons, not held-out validation or a season-level posterior predictive interval.
