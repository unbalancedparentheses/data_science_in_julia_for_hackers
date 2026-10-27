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

# ╔═╡ 371da9fa-0124-4396-8c1b-d87b679d8244
begin
    import Pkg
    Pkg.activate(@__DIR__)
    using PlutoUI, Statistics
    include(joinpath(@__DIR__, "core.jl"))
    using .CausalPricing
end

# ╔═╡ 06aa145b-0172-412a-bc3b-4a98a8426866
md"""
# Does raising the price increase sales?

This experiment accompanies **From prediction to intervention**. The synthetic
population sells exactly 20 fewer units at the higher price on every day.
Change the manager's tendency to set high prices on busy days. Random seeds
stay fixed, so slider movements change the policy rather than redraw the world.
"""

# ╔═╡ 43397969-f655-4f48-883d-d19ff827ba71
@bind tendency Slider(0.5:0.05:0.95; default=0.85, show_value=true)

# ╔═╡ 55289213-812b-4d5c-a813-9c17022fda54
population = pricing_population(4000; seed=1601)

# ╔═╡ 28edc3ef-a971-4fa1-bd89-5d8307385a82
historical = observe_prices(population; seed=1602,
    high_given_busy=tendency, high_given_quiet=1-tendency)

# ╔═╡ 378bdad5-1881-40d2-9c6e-5492b1cb1077
trial = observe_prices(population; seed=1603,
    high_given_busy=0.5, high_given_quiet=0.5)

# ╔═╡ 37cb1c54-e7cc-4574-83c3-98f3f263910f
begin
    naive = difference_in_means(historical.quantity, historical.high)
    adjusted = adjusted_difference(historical)
    randomized = difference_in_means(trial.quantity, trial.high)
    md"""
    | Analysis | Estimated quantity effect |
    |:--|--:|
    | Historical difference | $(round(naive.estimate; digits=2)) |
    | Historical, adjusted for demand | $(round(adjusted; digits=2)) |
    | Randomized experiment | $(round(randomized.estimate; digits=2)) |
    | Known synthetic effect | −20 |

    Approximate 95% interval for the randomized estimate:
    $(round.(randomized.interval; digits=2)). This interval addresses sampling
    uncertainty, not bias from a broken experiment or an incorrect causal story.
    """
end

# ╔═╡ 118361f0-3108-44fc-af6b-dbbdc8c6ec3f
[(context=busy ? "busy" : "quiet", high_price=high,
  observations=count((historical.busy .== busy) .& (historical.high .== high)))
 for busy in (false, true), high in (false, true)]

# ╔═╡ 4abc318a-6718-4c34-9c92-13f3c9a60565
md"""
## Explain the result before changing the model

Why does the unadjusted association move while the causal effect stays fixed?
As the policy becomes more deterministic, which comparison has fewer data?
Adjustment works here because the pre-treatment demand label includes all
confounding by construction. It need not work if the manager also uses an
unrecorded forecast. A good predictive score cannot verify that assumption.
"""

# ╔═╡ Cell order:
# ╠═371da9fa-0124-4396-8c1b-d87b679d8244
# ╟─06aa145b-0172-412a-bc3b-4a98a8426866
# ╠═43397969-f655-4f48-883d-d19ff827ba71
# ╠═55289213-812b-4d5c-a813-9c17022fda54
# ╠═28edc3ef-a971-4fa1-bd89-5d8307385a82
# ╠═378bdad5-1881-40d2-9c6e-5492b1cb1077
# ╟─37cb1c54-e7cc-4574-83c3-98f3f263910f
# ╠═118361f0-3108-44fc-af6b-dbbdc8c6ec3f
# ╟─4abc318a-6718-4c34-9c92-13f3c9a60565
