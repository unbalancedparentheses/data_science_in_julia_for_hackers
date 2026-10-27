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

# ╔═╡ 206b1a6d-2118-5c4f-8f2a-a3ca15b5eb39
md"""# What should a spam filter cost?

Move the controls to change the consequences of mistakes and the fraction of incoming messages that are spam. This is a synthetic decision experiment, not a fitted production spam filter.

The score model is fitted on training data. Every displayed error-rate estimate comes from validation data. The final test set remains untouched.
"""

# ╔═╡ 0ec25ed8-ee70-5ab7-b0d6-b9c0c6c7806f
begin
    import Pkg
    Pkg.activate(@__DIR__)
    using PlutoUI
    include(joinpath(@__DIR__, "core.jl"))
    using .ModelEvaluation
end

# ╔═╡ 45a3605e-afd1-5e9e-a161-6e8552664740
begin
    mail = synthetic_mail()
    rows = split_rows(length(mail.label))
    score_model = fit_score(mail.signal[rows.train], mail.label[rows.train])
    validation_probability = predict_score(score_model, mail.signal[rows.validation])
    validation_label = mail.label[rows.validation]
    thresholds = collect(0.0:0.01:1.0)
    observed_counts = [confusion(validation_label, validation_probability; threshold=t)
                       for t in thresholds]
end

# ╔═╡ 2bfc2707-f472-51ec-9327-1629d3ff3a93
md"""Cost of blocking one legitimate email:
$(@bind false_positive_cost Slider(1:20; default=5, show_value=true))

Cost of delivering one spam email:
$(@bind false_negative_cost Slider(1:10; default=1, show_value=true))

Spam prevalence in the hypothetical deployment population:
$(@bind prevalence Slider(0.01:0.01:0.50; default=0.07, show_value=true))
"""

# ╔═╡ 83be9b8c-e3b3-56fc-8120-253c57e8dec4
begin
    expected_counts = [expected_confusion(c; prevalence, n=1000) for c in observed_counts]
    costs = [mean_cost(c; false_positive_cost, false_negative_cost) for c in expected_counts]
    chosen_index = argmin(costs)
    chosen_threshold = thresholds[chosen_index]
    chosen_counts = expected_counts[chosen_index]
    chosen_metrics = metrics(chosen_counts)
end

# ╔═╡ e7f5a287-c799-5e73-bc8e-332b86340bae
md"""## A decision for this scenario

Threshold selected from the validation operating rates: **$(round(chosen_threshold; digits=2))**.

Expected cost per 1,000 messages: **$(round(1000costs[chosen_index]; digits=2))** cost units.

| Action | Actual spam | Actual ham |
|:--|--:|--:|
| Block | $(round(chosen_counts.tp; digits=1)) | $(round(chosen_counts.fp; digits=1)) |
| Deliver | $(round(chosen_counts.fn; digits=1)) | $(round(chosen_counts.tn; digits=1)) |

These are expected counts, so fractional values are intentional. Precision is
**$(ismissing(chosen_metrics.precision) ? "undefined (nothing blocked)" : round(chosen_metrics.precision; digits=3))**;
recall is **$(round(chosen_metrics.recall; digits=3))**.

Several grid thresholds may give the same actions because there are only four score values. We display the first minimum, not a uniquely optimal real-valued threshold.
"""

# ╔═╡ e4047468-e097-52f8-a8a7-4968a7c1b0c3
md"""## What assumptions are we making?

Changing prevalence keeps the score distribution within spam and within ham fixed: this is a **label-shift** thought experiment. Class-conditional error rates are estimated from finite validation samples. If spammers change tactics, those rates may change too and this calculation no longer describes deployment.

The raw score model is not automatically calibrated for every prevalence selected above. We therefore select the threshold using reweighted validation error rates, rather than treating its old scores as new-population probabilities.

Try making blocked legitimate messages expensive. Then make spam rare. Does a high accuracy imply a useful filter? What additional action, such as quarantine or human review, would you want to add?
"""

# ╔═╡ b0b39d34-933b-5afb-89f0-10cb2ce7840a
(; validation_brier=brier_score(validation_label, validation_probability),
   validation_reliability=reliability(validation_label, validation_probability))

# ╔═╡ Cell order:
# ╟─206b1a6d-2118-5c4f-8f2a-a3ca15b5eb39
# ╠═0ec25ed8-ee70-5ab7-b0d6-b9c0c6c7806f
# ╠═45a3605e-afd1-5e9e-a161-6e8552664740
# ╟─2bfc2707-f472-51ec-9327-1629d3ff3a93
# ╠═83be9b8c-e3b3-56fc-8120-253c57e8dec4
# ╟─e7f5a287-c799-5e73-bc8e-332b86340bae
# ╟─e4047468-e097-52f8-a8a7-4968a7c1b0c3
# ╠═b0b39d34-933b-5afb-89f0-10cb2ce7840a
