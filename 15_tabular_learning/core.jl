module TabularLearning
using Random, Statistics, LinearAlgebra
export delivery_data, split_rows, fit_preprocessor, transform, fit_linear, predict_linear, rmse, mae

"""Synthetic deliveries; all features are available when the order is placed."""
function delivery_data(n=1800; seed=1501)
    n > 0 || throw(ArgumentError("n must be positive"))
    rng = MersenneTwister(seed)
    actual_distance = 0.5 .+ 11.5 .* rand(rng, n)
    weather = rand(rng, ["clear", "rain", "storm"], n)
    minutes = [12 + 2.5d + 0.8max(d - 6, 0)^2 +
               (w == "clear" ? 0 : w == "rain" ? 8 : 20) + 3randn(rng)
               for (d, w) in zip(actual_distance, weather)]
    distance = Union{Missing, Float64}[rand(rng) < 0.15 ? missing : d for d in actual_distance]
    return (; distance, weather, minutes)
end
function split_rows(n; seed=1502)
    n >= 5 || throw(ArgumentError("at least five rows are required"))
    ids = randperm(MersenneTwister(seed), n)
    a, b = floor(Int, 0.6n), floor(Int, 0.8n)
    return (; train=ids[1:a], validation=ids[a+1:b], test=ids[b+1:end])
end

"""Learn imputation, scaling and categorical vocabulary only from selected rows."""
function fit_preprocessor(data, rows)
    isempty(rows) && throw(ArgumentError("training rows must not be empty"))
    observed = collect(skipmissing(data.distance[rows]))
    isempty(observed) && throw(ArgumentError("training distances are all missing"))
    all(isfinite, observed) || throw(ArgumentError("distances must be finite"))
    center = median(observed)
    filled = coalesce.(data.distance[rows], center)
    scale = std(filled; corrected=false)
    scale = scale > 0 ? scale : 1.0
    levels = sort(unique(data.weather[rows]))
    return (; center, scale, levels)
end
function transform(preprocessor, data, rows)
    all(w -> w in preprocessor.levels, data.weather[rows]) ||
        throw(ArgumentError("unseen weather category: review or retrain the model"))
    filled = coalesce.(data.distance[rows], preprocessor.center)
    all(isfinite, filled) || throw(ArgumentError("distances must be finite"))
    numeric = (filled .- preprocessor.center) ./ preprocessor.scale
    absent = Float64.(ismissing.(data.distance[rows]))
    # One category is the reference; encoding all categories plus an intercept
    # would make the columns linearly dependent.
    encoded = [Float64.(data.weather[rows] .== level) for level in preprocessor.levels[2:end]]
    return hcat(numeric, absent, encoded...)
end
function fit_linear(X, y; lambda=0.0)
    size(X, 1) == length(y) || throw(DimensionMismatch("features and targets differ"))
    isempty(y) && throw(ArgumentError("training targets must not be empty"))
    lambda >= 0 || throw(ArgumentError("lambda must be nonnegative"))
    design = hcat(ones(size(X, 1)), X)
    # Solve least squares directly; never explicitly invert X'X.
    if lambda == 0
        return design \ y
    end
    penalty = Matrix{Float64}(I, size(design, 2), size(design, 2))
    penalty[1, 1] = 0.0 # do not penalize the intercept
    return vcat(design, sqrt(length(y) * lambda) .* penalty) \ vcat(y, zeros(size(design, 2)))
end
predict_linear(coef, X) = hcat(ones(size(X, 1)), X) * coef
rmse(y, prediction) = sqrt(mean((y .- prediction).^2))
mae(y, prediction) = mean(abs.(y .- prediction))
end
