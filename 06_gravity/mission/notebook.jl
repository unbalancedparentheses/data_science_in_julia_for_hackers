### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# Plain Julia has no bond values; each control below supplies its documented default.
macro bind(def, element)
    quote
        local control = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, control) ? Base.get(control) : missing
        control
    end
end

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b01
begin
    include(joinpath(@__DIR__, "core.jl"))
    using .MarsMission
end

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b03
md"""
# One chance to leave Mars

Five throws, an uncertain angle, and a hypothetical speed budget. Before moving
anything, predict: will measuring the angle exactly mostly move the estimate,
or mostly narrow its interval? Write down your prediction.

We fix the data, a uniform gravity prior on the displayed grid, and the rounded
Earth/Mars radius ratio. Range errors are independent Normal errors; recorded
times are exact. Angle uncertainty is **shared** across throws.
"""

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b04
md"Angle half-width in degrees (default 7.5):"

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b05
@bind angle_control HTML("<input type='range' min='0' max='15' step='0.5' value='7.5' aria-label='Angle uncertainty half-width in degrees'>")

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b06
md"Range-error standard deviation in metres (default 3):"

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b07
@bind noise_control HTML("<input type='range' min='1' max='10' step='0.5' value='3' aria-label='Range error standard deviation in metres'>")

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b08
md"Hypothetical available speed in km/s (default 5):"

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b09
@bind budget_control HTML("<input type='range' min='3' max='7' step='0.05' value='5' aria-label='Hypothetical speed budget in kilometres per second'>")

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b10
begin
    halfwidth = ismissing(angle_control) ? 7.5 : Float64(angle_control)
    sigma = ismissing(noise_control) ? 3.0 : Float64(noise_control)
    budget = ismissing(budget_control) ? 5.0 : Float64(budget_control)
    distances = [25.94, 38.84, 52.81, 45.54, 17.24]
    times = [3.91, 4.57, 5.43, 4.85, 3.15]
    result = posterior(distances, times; sigma, halfwidth)
    decision = mission_summary(result; budget)
end

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b11
md"""
## Mission readout

Angle: **45 ± $(halfwidth) degrees**. Range-error standard deviation: **$(sigma) m**.

Middle 90% escape-speed interval: **$(round(decision.interval[1]; digits=2)) to $(round(decision.interval[3]; digits=2)) km/s**.

Posterior median: **$(round(decision.interval[2]; digits=2)) km/s**.

Probability the ideal escape speed is at most our **$(budget) km/s** budget:
**$(round(100decision.probability_within_budget; digits=1))%**.

This is a probability under our stone-throwing model, **not a spacecraft success
probability**. We have not modelled the engine, atmosphere, radius uncertainty,
or a biased stopwatch. The ship is a decision-making story, not a launch plan.
"""

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b13
begin
    # Plot a density in SPEED, not gravity: account for unequal transformed cells.
    speeds = escape_speed.(result.gs)
    edges = escape_speed.(vcat(result.gs[1] - (result.gs[2]-result.gs[1])/2,
                               (result.gs[1:end-1] .+ result.gs[2:end])/2,
                               result.gs[end] + (result.gs[end]-result.gs[end-1])/2))
    density = result.masses ./ diff(edges)
    plot_x(v) = 55 + 520v/8
    plot_y(d) = 220 - 170d/maximum(density)
    points = join(["$(plot_x(v)),$(plot_y(d))" for (v,d) in zip(speeds,density)], " ")
    tick_labels = join(["<text x='$(plot_x(v))' y='243' text-anchor='middle'>$(v)</text>" for v in 0:2:8])
    mission_plot = HTML("""
    <svg viewBox="0 0 630 300" role="img" aria-labelledby="mars-chart-title mars-chart-desc" style="max-width:750px;width:100%;background:white;color:#18222c">
      <title id="mars-chart-title">Posterior ideal escape speed and hypothetical speed budget</title>
      <desc id="mars-chart-desc">The blue curve is the posterior density of escape speed in kilometres per second. The pale band is its middle 90 percent interval. A dashed orange line marks the speed budget. Values are also listed in the mission readout.</desc>
      <text x="55" y="23" font-size="15">Posterior density (relative height)</text>
      <rect x="$(plot_x(decision.interval[1]))" y="40" width="$(plot_x(decision.interval[3])-plot_x(decision.interval[1]))" height="180" fill="#dcebf8"/>
      <polyline points="$(points)" fill="none" stroke="#16689b" stroke-width="2"/>
      <line x1="$(plot_x(budget))" y1="40" x2="$(plot_x(budget))" y2="220" stroke="#b54d00" stroke-width="3" stroke-dasharray="6 4"/>
      <line x1="55" y1="220" x2="575" y2="220" stroke="#18222c"/>
      $(tick_labels)
      <text x="315" y="270" text-anchor="middle">Ideal escape speed (km/s)</text>
      <text x="55" y="292" font-size="12">Blue band: middle 90% interval. Orange dashed line: hypothetical budget.</text>
    </svg>
    """)
end

# ╔═╡ 164c4c3d-d434-4443-98ca-116e72fd9b12
md"""
## Now change the experiment

1. Keep range noise at 3. Set angle half-width to zero. Was your prediction right?
2. Restore the angle uncertainty, then halve the range noise. Which measurement
   would you pay to improve? Compare interval widths, not just medians.
3. Set the speed budget to the median. Why is the probability near one half?
4. Inspect `core.jl`. Replace the recorded times with `1.05 .* times` while keeping
   ranges fixed. Predict the direction of the error before running it.

**Explanation:** the same ranges with longer times imply weaker gravity. A shared
clock error will not disappear when we throw more stones. More observations can
make a wrong model more confident. Independent calibration is a better next experiment.

The grid sums across a shared unknown angle before reporting gravity. Its cell
spacing is an approximation; `runtests.jl` compares a finer grid and an analytic
known-angle case. If mass piles up at a grid edge, extend the prior range and
investigate instead of trusting the clipped interval.
"""

# ╔═╡ Cell order:
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b01
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b03
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b04
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b05
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b06
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b07
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b08
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b09
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b10
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b11
# ╠═164c4c3d-d434-4443-98ca-116e72fd9b13
# ╟─164c4c3d-d434-4443-98ca-116e72fd9b12
