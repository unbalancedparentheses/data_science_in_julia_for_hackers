using Test, Random, Statistics, Distributions
include("core.jl")
using .FootballWorkflow
@testset "Bayesian football workflow" begin
    posterior = goal_posterior([0, 1, 2]; shape=2, rate=1)
    @test mean(posterior) ≈ 5/4
    @test var(posterior) ≈ 5/16
    @test_throws ArgumentError goal_posterior([-1, 2])
    @test_throws ArgumentError metropolis_rates([1, 2]; step=0)
    reference_fit = metropolis_rates([0, 1, 2]; step=0.7, draws=6000, warmup=1000)
    @test abs(mean(reference_fit.samples) - mean(posterior)) < 0.04
    @test abs(var(reference_fit.samples) - var(posterior)) < 0.05
    result = workflow_demo()
    @test abs(mean(result.fit.samples) - mean(result.posterior)) < 0.04
    @test result.diagnostics.rhat < 1.02
    @test result.diagnostics.bulk_ess > 400
    @test all(a -> 0.1 < a < 0.9, result.fit.acceptance)
    stuck = metropolis_rates(result.training.goals; draws=1000, warmup=0, step=0.00001)
    @test chain_diagnostics(stuck.samples).rhat > 1.1
    @test result.pooled.observed > result.pooled.interval[2]
    @test result.grouped.interval[1] <= result.grouped.observed <= result.grouped.interval[2]
    @test result.grouped_score > result.pooled_score
    @test replicate_goals(posterior, 5; draws=20) == replicate_goals(posterior, 5; draws=20)
    @test_throws DimensionMismatch predictive_check([0, 1], zeros(Int, 3, 10))
    # Exact one-step predictive probability agrees with the Gamma–Poisson formula.
    training=(goals=[0, 1, 2], easy=[false, false, false])
    testing=(goals=[0], easy=[false])
    @test exp(log_predictive_score(training, testing)) ≈ (4/5)^5
end
