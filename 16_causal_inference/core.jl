module CausalPricing
using Random, Statistics
export pricing_population, observe_prices, difference_in_means, adjusted_difference, pricing_demo

"""Synthetic potential outcomes. Prices are 10 and 14; quantity effect is -20."""
function pricing_population(n::Integer=4000; seed::Integer=1601)
    n >= 4 || throw(ArgumentError("at least four customers are required"))
    rng = MersenneTwister(seed)
    busy = rand(rng, n) .< 0.5
    quantity_low = 80 .+ 120 .* busy .+ 8 .* randn(rng, n)
    quantity_high = quantity_low .- 20
    return (; busy, quantity_low, quantity_high)
end

"""Assign prices using pre-treatment demand, then reveal only observed outcomes."""
function observe_prices(population; seed::Integer=1602, high_given_busy=0.85, high_given_quiet=0.15)
    all(p -> 0 < p < 1, (high_given_busy, high_given_quiet)) ||
        throw(ArgumentError("assignment probabilities must lie strictly between zero and one"))
    probabilities = ifelse.(population.busy, high_given_busy, high_given_quiet)
    high = rand(MersenneTwister(seed), length(probabilities)) .< probabilities
    quantity = ifelse.(high, population.quantity_high, population.quantity_low)
    price = ifelse.(high, 14.0, 10.0)
    profit = (price .- 4.0) .* quantity
    return (; busy=population.busy, high, quantity, profit)
end

"""Difference in sample means and an approximate independent-groups 95% interval."""
function difference_in_means(outcome, high)
    length(outcome) == length(high) || throw(DimensionMismatch("outcomes and assignments differ"))
    treated, control = outcome[high], outcome[.!high]
    min(length(treated), length(control)) >= 2 ||
        throw(ArgumentError("each price group needs at least two observations"))
    estimate = mean(treated) - mean(control)
    se = sqrt(var(treated) / length(treated) + var(control) / length(control))
    return (; estimate, se, interval=(estimate - 1.96se, estimate + 1.96se))
end

"""Standardize within-demand contrasts to this sample's demand composition."""
function adjusted_difference(data; outcome=data.quantity)
    length(outcome) == length(data.busy) || throw(DimensionMismatch("outcome length differs"))
    estimate = 0.0
    for context in (false, true)
        rows = data.busy .== context
        any(rows) || throw(ArgumentError("both demand contexts must be observed"))
        estimate += mean(rows) * difference_in_means(outcome[rows], data.high[rows]).estimate
    end
    return estimate
end

function pricing_demo(; n=4000, seed=1601)
    population = pricing_population(n; seed)
    historical = observe_prices(population; seed=seed + 1)
    trial = observe_prices(population; seed=seed + 2, high_given_busy=0.5, high_given_quiet=0.5)
    return (; population, historical, trial,
        naive=difference_in_means(historical.quantity, historical.high),
        adjusted=adjusted_difference(historical),
        randomized=difference_in_means(trial.quantity, trial.high),
        oracle=mean(population.quantity_high - population.quantity_low),
        profit_effect=difference_in_means(trial.profit, trial.high))
end
end
