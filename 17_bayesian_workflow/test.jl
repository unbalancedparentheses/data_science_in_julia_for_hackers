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

# Earlier book chapters call StatsBase/Distributions.fit in the shared Julia
# session. Resolve that imported binding before executing the published code.
module PublishedChapter17
using Distributions
fit(Normal, [1.0, 2.0, 3.0])
end
@testset "Published chapter after an imported fit call" begin
    source_path = joinpath(@__DIR__, "..", "17_bayesian_workflow.Rmd")
    source = read(source_path, String)
    blocks = collect(eachmatch(r"(?ms)^```\{julia[^\n]*\}\s*\n(.*?)^```", source))
    @test !isempty(blocks)
    cd(dirname(source_path)) do
        for block in blocks
            Base.include_string(PublishedChapter17, block.captures[1], source_path)
        end
    end
    @test PublishedChapter17.fit === Distributions.fit
    @test size(PublishedChapter17.sampler_fit.samples) == (4000, 4)
end

@testset "Published football readouts" begin
    c = PublishedChapter17
    @test c.prior_zero_check.observed == 0.4125
    @test c.prior_zero_check.interval == [0.0, 0.725]
    # The mean lies exactly at a decimal rounding midpoint; reduction order
    # can move the last binary bit across it on ARM versus x86.
    @test c.prior_zero_check.replicated_mean ≈ 0.24645 atol=1e-12
    @test round(mean(c.posterior); digits=4) == 2.0123
    @test round.(quantile.(Ref(c.posterior), [0.05, 0.95]); digits=4) == [1.7603, 2.2784]
    @test round(mean(c.sampler_fit.samples); digits=4) == 2.0142
    @test round(c.diagnostics.rhat; digits=4) == 1.0009
    @test round(c.diagnostics.bulk_ess; digits=1) == 3394.8
    @test round(c.diagnostics.tail_ess; digits=1) == 3240.7
    @test round(c.diagnostics.mean_mcse; digits=4) == 0.0028
    stuck_diagnostics = chain_diagnostics(c.stuck_fit.samples)
    @test round(stuck_diagnostics.rhat; digits=2) == 3.98
    @test round(stuck_diagnostics.bulk_ess; digits=2) == 8.43
    @test c.pooled_check.interval == [0.0625, 0.2125]
    @test predictive_check(c.training.goals, grouped_replicates(c.training)).interval == [0.3125, 0.4625]
    @test round(log_predictive_score(c.training, c.future); digits=2) == -102.58
    @test round(log_predictive_score(c.training, c.future; grouped=true); digits=2) == -54.05
end
