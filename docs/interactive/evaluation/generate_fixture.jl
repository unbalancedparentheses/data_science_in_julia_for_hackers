# Run from repository root with Julia 1.10.10. No external packages.
include("../../../14_model_evaluation/core.jl")
include("../../../scripts/browser/write_fixture.jl")
using .ModelEvaluation
mail = synthetic_mail()
rows = split_rows(length(mail.label))
model = fit_score(mail.signal[rows.train], mail.label[rows.train])
probabilities = predict_score(model, mail.signal[rows.validation])
labels = mail.label[rows.validation]
thresholds = collect(0.0:0.01:1.0)
counts = [confusion(labels, probabilities; threshold=t) for t in thresholds]
cases = []
for fp in (1.0, 5.0, 20.0), fn in (1.0, 10.0), prevalence in (0.01, 0.07, 0.5)
    expected = [expected_confusion(c; prevalence, n=1000) for c in counts]
    costs = [mean_cost(c; false_positive_cost=fp, false_negative_cost=fn) for c in expected]
    selected = argmin(costs)
    push!(cases, (; fp, fn, prevalence, threshold=thresholds[selected], cost=costs[selected], counts=expected[selected]))
end
write_fixture((; thresholds, counts, cases, validation_size=length(labels)), joinpath(@__DIR__, "data.js"))
