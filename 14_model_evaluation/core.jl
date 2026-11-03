module ModelEvaluation
using Random, Statistics
export synthetic_mail, split_rows, fit_score, predict_score, confusion, metrics,
       mean_cost, choose_threshold, reliability, brier_score, expected_confusion

"""Independent synthetic emails; signal categories are known before delivery."""
function synthetic_mail(n=6000; seed=1401)
    n > 0 || throw(ArgumentError("n must be positive"))
    rng = MersenneTwister(seed)
    signal = Vector{Int}(undef, n)
    label = Vector{Int}(undef, n)
    probabilities = (0.01, 0.08, 0.40, 0.85)
    for i in 1:n
        u = rand(rng)
        signal[i] = u < 0.70 ? 1 : u < 0.90 ? 2 : u < 0.98 ? 3 : 4
        label[i] = Int(rand(rng) < probabilities[signal[i]])
    end
    return (; signal, label)
end

function split_rows(n; seed=1402)
    n >= 5 || throw(ArgumentError("at least five rows are required"))
    rows = randperm(MersenneTwister(seed), n)
    a, b = floor(Int, 0.6n), floor(Int, 0.8n)
    return (; train=rows[1:a], validation=rows[a+1:b], test=rows[b+1:end])
end

"""Estimate a smoothed spam rate in each of four signal categories."""
function fit_score(signal, label)
    length(signal) == length(label) || throw(DimensionMismatch("signals and labels differ"))
    isempty(label) && throw(ArgumentError("training data must not be empty"))
    all(x -> x in 1:4, signal) || throw(ArgumentError("unknown signal category"))
    all(x -> x in (0, 1), label) || throw(ArgumentError("labels must be binary"))
    return [(sum(label[signal .== k]) + 1) / (count(==(k), signal) + 2) for k in 1:4]
end
predict_score(model, signal) = model[signal]

function check_predictions(label, probability)
    length(label) == length(probability) || throw(DimensionMismatch("labels and probabilities differ"))
    isempty(label) && throw(ArgumentError("evaluation data must not be empty"))
    all(x -> x in (0, 1), label) || throw(ArgumentError("labels must be binary"))
    all(p -> isfinite(p) && 0 <= p <= 1, probability) || throw(ArgumentError("probabilities must be in [0,1]"))
end

function confusion(label, probability; threshold=0.5)
    check_predictions(label, probability)
    0 <= threshold <= 1 || throw(ArgumentError("threshold must be in [0,1]"))
    predicted = probability .>= threshold
    return (tp=count(predicted .& (label .== 1)),
            fp=count(predicted .& (label .== 0)),
            tn=count(.!predicted .& (label .== 0)),
            fn=count(.!predicted .& (label .== 1)))
end
safe_ratio(a, b) = b == 0 ? missing : a / b
function metrics(c)
    return (; accuracy=(c.tp + c.tn) / (c.tp + c.fp + c.tn + c.fn),
            precision=safe_ratio(c.tp, c.tp + c.fp),
            recall=safe_ratio(c.tp, c.tp + c.fn),
            false_positive_rate=safe_ratio(c.fp, c.fp + c.tn))
end
function mean_cost(c; false_positive_cost=5.0, false_negative_cost=1.0)
    false_positive_cost >= 0 && false_negative_cost >= 0 || throw(ArgumentError("costs must be nonnegative"))
    return (false_positive_cost * c.fp + false_negative_cost * c.fn) / (c.tp + c.fp + c.tn + c.fn)
end
function choose_threshold(label, probability; thresholds=0.0:0.01:1.0,
                          false_positive_cost=5.0, false_negative_cost=1.0)
    isempty(thresholds) && throw(ArgumentError("provide at least one threshold"))
    losses = [mean_cost(confusion(label, probability; threshold=t);
                       false_positive_cost, false_negative_cost) for t in thresholds]
    i = argmin(losses) # first minimizer: deterministic, no test-set tie breaking
    return (; threshold=thresholds[i], validation_cost=losses[i])
end
"""Expected counts under label shift: class-conditional error rates stay fixed."""
function expected_confusion(c; prevalence=0.1, n=1000)
    0 <= prevalence <= 1 || throw(ArgumentError("prevalence must be in [0,1]"))
    n > 0 || throw(ArgumentError("n must be positive"))
    c.tp + c.fn > 0 && c.fp + c.tn > 0 || throw(ArgumentError("both classes must be observed"))
    sensitivity = c.tp / (c.tp + c.fn)
    false_positive_rate = c.fp / (c.fp + c.tn)
    tp = n * prevalence * sensitivity
    fp = n * (1 - prevalence) * false_positive_rate
    return (; tp, fp, tn=n * (1 - prevalence) - fp, fn=n * prevalence - tp)
end
function brier_score(label, probability)
    check_predictions(label, probability)
    return mean((probability .- label).^2)
end
function reliability(label, probability; bins=5)
    check_predictions(label, probability)
    bins > 0 || throw(ArgumentError("bins must be positive"))
    groups = min.(floor.(Int, bins .* probability) .+ 1, bins)
    return [(; bin=k, n=count(==(k), groups),
             predicted=mean(probability[groups .== k]), observed=mean(label[groups .== k]))
            for k in 1:bins if any(==(k), groups)]
end
end
