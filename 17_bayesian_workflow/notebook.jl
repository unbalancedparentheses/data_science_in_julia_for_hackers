### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# Script-only defaults. Pluto ignores this preamble and uses its native @bind.
macro bind(def, element)
    quote
        local widget = $(esc(element))
        global $(esc(def)) = Base.get(widget)
        widget
    end
end

# ╔═╡ 56006eca-486d-4e0e-8618-9f95f0bbb54b
begin
    import Pkg
    Pkg.activate(@__DIR__)
    using PlutoUI, Random, Statistics, Distributions
    include(joinpath(@__DIR__, "core.jl"))
    using .FootballWorkflow
end

# ╔═╡ 30369c65-9a0b-4595-80f2-fb305e1dde91
md"""
# A posterior is the beginning of a check

This notebook accompanies **A complete Bayesian workflow**. It fits a small
Gamma–Poisson scoring model, checks a hand-written Metropolis sampler against
an exact posterior, and exposes a missing opponent effect. The matches are
synthetic. These are not estimates for an actual team.
"""

# ╔═╡ e0dbde0a-317b-4832-9010-daf890b50703
training = football_data()

# ╔═╡ 66bf5081-2dcc-4764-adb5-ab7422b7fc2b
md"Prior strength (the prior mean stays at two goals per match):"

# ╔═╡ 875e71e8-09a9-4bdf-a3d4-a81e9ed7907a
@bind strength Slider([0.5, 1.0, 5.0, 10.0, 30.0]; default=1.0, show_value=true)

# ╔═╡ b4f9a257-c386-42ef-b10b-307e96490e31
posterior = goal_posterior(training.goals; shape=2strength, rate=strength)

# ╔═╡ b1e04c47-b814-4255-bc08-a1bb5f74f5f3
md"Metropolis proposal scale in log-rate space (a tiny step can accept often yet mix badly):"

# ╔═╡ 883724a4-8e93-4119-934d-547e5fd69ca0
@bind proposal_scale Slider([0.00001, 0.01, 0.1, 0.25, 1.0, 3.0]; default=0.25, show_value=true)

# ╔═╡ 06f062aa-66b2-40ce-897f-c40155fbfd51
fit = metropolis_rates(training.goals; shape=2strength, rate=strength,
    step=proposal_scale, draws=4000, warmup=1000)

# ╔═╡ 6bfabed4-3219-42f4-8743-1c8dce7641cd
(diagnostics=chain_diagnostics(fit.samples),
 acceptance=fit.acceptance, exact_mean=mean(posterior), sampled_mean=mean(fit.samples))

# ╔═╡ 6a67a39e-6147-4ae9-b296-e3c18d30719b
let
    values = fit.samples
    lower, upper = extrema(values)
    span = max(upper-lower, eps(Float64))
    colors = ["#1b9e77", "#d95f02", "#7570b3", "#e7298a"]
    paths = String[]
    rows = unique(vcat(collect(1:10:size(values, 1)), size(values, 1)))
    for chain in axes(values, 2)
        points = join(["$(50+650*(i-1)/(size(values,1)-1)),$(210-180*(values[i,chain]-lower)/span)" for i in rows], " ")
        push!(paths, "<polyline points='$points' fill='none' stroke='$(colors[chain])' stroke-width='1' opacity='0.75'/>")
    end
    HTML("""<svg viewBox='0 0 740 255' role='img' aria-label='Four retained Markov chain traces; x axis is draw index and y axis scoring rate' style='width:100%;max-width:850px;background:white'>
    <text x='50' y='18' fill='#222'>Retained rate draws (four chains)</text>
    <path d='M50 25V215H705' stroke='#555' fill='none'/>
    <text x='4' y='37' fill='#222'>$(round(upper;digits=2))</text>
    <text x='4' y='212' fill='#222'>$(round(lower;digits=2))</text>
    $(join(paths))<text x='50' y='240' fill='#222'>1</text>
    <text x='650' y='240' fill='#222'>$(size(values,1)) draws</text></svg>""")
end

# ╔═╡ 72664b5a-4d4c-4503-82ea-57ff90b0737d
begin
    pooled = predictive_check(training.goals,
        replicate_goals(posterior, length(training.goals)))
    grouped = predictive_check(training.goals,
        grouped_replicates(training; shape=2strength, rate=strength))
    (pooled=pooled, grouped=grouped)
end

# ╔═╡ d536f944-ec8f-496a-b420-e146f0864fd0
md"""
Even well-mixed chains can accurately sample a model that misses scoreless
matches. Compare the observed zero fraction with the replicated intervals.
The grouped model changes an assumption about opponents; changing sampler
settings alone does not.

The intervals here describe replicated seasons. They are not confidence
intervals for a parameter, and a posterior predictive tail area is not the
probability that a model is true. Inspect the full chapter for the distinct
held-out evaluation step before using these diagnostics to choose a model.
"""

# ╔═╡ Cell order:
# ╠═56006eca-486d-4e0e-8618-9f95f0bbb54b
# ╟─30369c65-9a0b-4595-80f2-fb305e1dde91
# ╠═e0dbde0a-317b-4832-9010-daf890b50703
# ╟─66bf5081-2dcc-4764-adb5-ab7422b7fc2b
# ╠═875e71e8-09a9-4bdf-a3d4-a81e9ed7907a
# ╠═b4f9a257-c386-42ef-b10b-307e96490e31
# ╟─b1e04c47-b814-4255-bc08-a1bb5f74f5f3
# ╠═883724a4-8e93-4119-934d-547e5fd69ca0
# ╠═06f062aa-66b2-40ce-897f-c40155fbfd51
# ╠═6bfabed4-3219-42f4-8743-1c8dce7641cd
# ╟─6a67a39e-6147-4ae9-b296-e3c18d30719b
# ╠═72664b5a-4d4c-4503-82ea-57ff90b0737d
# ╟─d536f944-ec8f-496a-b420-e146f0864fd0
