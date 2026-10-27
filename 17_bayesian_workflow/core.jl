module FootballWorkflow
using Random, Statistics, Distributions, MCMCDiagnosticTools
export football_data, goal_posterior, metropolis_rates, chain_diagnostics,
       replicate_goals, grouped_replicates, predictive_check, log_predictive_score, workflow_demo

"""A synthetic schedule: difficult opponents have a lower scoring rate."""
function football_data(; seed=1701, matches_per_group=40)
    matches_per_group > 1 || throw(ArgumentError("need at least two matches per group"))
    rng = MersenneTwister(seed)
    easy = repeat([false, true], inner=matches_per_group)
    goals = [rand(rng, Poisson(e ? 4.0 : 0.2)) for e in easy]
    return (; easy, goals)
end

"""Conjugate Gamma posterior; arguments use shape and RATE, not scale."""
function goal_posterior(goals; shape=2.0, rate=1.0)
    shape > 0 && rate > 0 || throw(ArgumentError("shape and rate must be positive"))
    all(y -> y isa Integer && y >= 0, goals) || throw(ArgumentError("goals must be nonnegative integers"))
    return Gamma(shape + sum(goals), inv(rate + length(goals)))
end

"""Random-walk Metropolis in log-rate space, including the Jacobian."""
function metropolis_rates(goals; shape=2.0, rate=1.0, draws=4000, warmup=1000,
                          step=0.25, starts=[0.1, 0.5, 3.0, 8.0], seed=1702)
    goal_posterior(goals; shape, rate) # Validate the model inputs.
    draws > 0 && warmup >= 0 && step > 0 || throw(ArgumentError("invalid sampling settings"))
    !isempty(starts) && all(>(0), starts) || throw(ArgumentError("initial rates must be positive"))
    a, b = shape + sum(goals), rate + length(goals)
    # Gamma density in η = log(λ): (a-1)η - b exp(η) + η.
    logtarget(η) = a * η - b * exp(η)
    samples = Matrix{Float64}(undef, draws, length(starts))
    acceptance = zeros(length(starts))
    for (chain, start) in enumerate(starts)
        rng = MersenneTwister(seed + chain)
        η = log(start)
        for iteration in 1:(warmup + draws)
            proposal = η + step * randn(rng)
            accepted = log(rand(rng)) < logtarget(proposal) - logtarget(η)
            if accepted
                η = proposal
            end
            if iteration > warmup
                samples[iteration - warmup, chain] = exp(η)
                acceptance[chain] += accepted / draws
            end
        end
    end
    return (; samples, acceptance)
end

scalar(x) = x isa Number ? x : only(x)
function chain_diagnostics(samples)
    return (rhat=scalar(rhat(samples)),
            bulk_ess=scalar(ess(samples; kind=:bulk)),
            tail_ess=scalar(ess(samples; kind=:tail)),
            mean_mcse=scalar(mcse(samples; kind=mean)))
end

"""One parameter draw per replicated season, not one per match."""
function replicate_goals(distribution, n; draws=2000, seed=1703)
    n > 0 && draws > 0 || throw(ArgumentError("positive season and draw counts required"))
    rng = MersenneTwister(seed)
    replicates = Matrix{Int}(undef, n, draws)
    for d in 1:draws
        λ = rand(rng, distribution)
        replicates[:, d] = rand(rng, Poisson(λ), n)
    end
    return replicates
end

function grouped_replicates(data; shape=2.0, rate=1.0, draws=2000, seed=1704)
    replicates = Matrix{Int}(undef, length(data.goals), draws)
    for (index, context) in enumerate((false, true))
        rows = data.easy .== context
        any(rows) || throw(ArgumentError("both opponent groups must be observed"))
        posterior = goal_posterior(data.goals[rows]; shape, rate)
        replicates[rows, :] = replicate_goals(posterior, count(rows); draws, seed=seed + index)
    end
    return replicates
end

function predictive_check(goals, replicates; statistic=y -> mean(y .== 0))
    size(replicates, 1) == length(goals) || throw(DimensionMismatch("season lengths differ"))
    observed = statistic(goals)
    simulated = [statistic(view(replicates, :, d)) for d in axes(replicates, 2)]
    return (; observed, interval=quantile(simulated, [0.05, 0.95]),
            replicated_mean=mean(simulated), upper_fraction=mean(simulated .>= observed))
end

"""Sum of marginal one-match log scores with a fixed training posterior."""
function log_predictive_score(training, testing; grouped=false, shape=2.0, rate=1.0)
    score = 0.0
    for (y, context) in zip(testing.goals, testing.easy)
        train = grouped ? training.goals[training.easy .== context] : training.goals
        a, b = shape + sum(train), rate + length(train)
        # Gamma–Poisson mixture: success probability b/(b+1).
        score += logpdf(NegativeBinomial(a, b / (b + 1)), y)
    end
    return score
end

function workflow_demo()
    training = football_data()
    testing = football_data(seed=1710, matches_per_group=20)
    posterior = goal_posterior(training.goals)
    fit = metropolis_rates(training.goals)
    pooled = predictive_check(training.goals, replicate_goals(posterior, length(training.goals)))
    grouped = predictive_check(training.goals, grouped_replicates(training))
    return (; training, testing, posterior, fit, diagnostics=chain_diagnostics(fit.samples), pooled, grouped,
            pooled_score=log_predictive_score(training, testing),
            grouped_score=log_predictive_score(training, testing; grouped=true))
end
end
