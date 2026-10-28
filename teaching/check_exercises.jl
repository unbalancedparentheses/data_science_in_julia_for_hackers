# julia --project=17_bayesian_workflow teaching/check_exercises.jl
# Uses the chapter environment for the exact Bayesian reference.
using Test, Statistics, Distributions
const ROOT = dirname(@__DIR__)
include(joinpath(ROOT, "14_model_evaluation", "core.jl"))
include(joinpath(ROOT, "15_tabular_learning", "core.jl"))
include(joinpath(ROOT, "16_causal_inference", "core.jl"))
include(joinpath(ROOT, "17_bayesian_workflow", "core.jl"))
using .CausalPricing: difference_in_means

# Execute the solution functions as printed, instead of testing another copy.
function printed_function(chapter, name)
    source = read(joinpath(ROOT, chapter * ".Rmd"), String)
    pattern = Regex("function " * name * "\\(.*?\\nend", "s")
    result = match(pattern, source)
    isnothing(result) && error("Missing printed solution: $name")
    Core.eval(Main, Meta.parse(result.match))
end
for (chapter, name) in (("14_model_evaluation", "choose_action"),
                        ("15_tabular_learning", "group_report"),
                        ("16_causal_inference", "target_effect"),
                        ("17_bayesian_workflow", "spread_gap"))
    printed_function(chapter, name)
end

@testset "Evaluation exercise solutions" begin
    c = (tp=80, fp=45, tn=855, fn=20)
    m = ModelEvaluation.metrics(c)
    @test m.accuracy ≈ 0.935
    @test m.precision ≈ 0.64
    @test m.recall ≈ 0.8
    @test ModelEvaluation.mean_cost(c) ≈ 0.245
    @test ModelEvaluation.mean_cost((tp=0, fp=0, tn=900, fn=100)) ≈ 0.1
    shifted = ModelEvaluation.expected_confusion(c; prevalence=0.01, n=1000)
    @test collect(shifted) ≈ [8, 49.5, 940.5, 2]
    @test ModelEvaluation.metrics(shifted).precision ≈ 8/57.5
    @test choose_action.([0.01, 0.5, 0.99]) == [:deliver, :review, :block]
    @test choose_action(0.2) == :deliver
    @test_throws ArgumentError choose_action(1.1)
    @test ModelEvaluation.fit_score([1, 1, 1], [1, 1, 1])[1] ≈ 4/5
    @test ModelEvaluation.fit_score([1, 1, 1, 1], [1, 1, 1, 0])[1] ≈ 4/6
end

@testset "Tabular exercise solutions" begin
    data = (distance=Union{Missing, Float64}[2, 4, missing, missing, 100],
            weather=fill("clear", 5), minutes=zeros(5))
    preparation = TabularLearning.fit_preprocessor(data, 1:3)
    @test preparation.center == 3
    @test TabularLearning.transform(preparation, data, [3, 4])[:, 1] == [0, 0]
    changed = merge(data, (distance=Union{Missing, Float64}[2, 4, missing, missing, 1000],))
    @test TabularLearning.fit_preprocessor(changed, 1:3) == preparation
    report = group_report([10, 20, 30, 40], [12, 18, 35, 35], [false, false, true, true])
    @test getproperty.(report, :n) == [2, 2]
    @test getproperty.(report, :rmse) == [2, 5]
    @test getproperty.(report, :bias) == [0, 0]
    @test_throws DimensionMismatch group_report([1], [1, 2], [true])
    deliveries = TabularLearning.delivery_data()
    rows = TabularLearning.split_rows(length(deliveries.minutes))
    prep = TabularLearning.fit_preprocessor(deliveries, rows.train)
    Xtrain = TabularLearning.transform(prep, deliveries, rows.train)
    Xvalidation = TabularLearning.transform(prep, deliveries, rows.validation)
    keep = [j for j in axes(Xtrain, 2) if j != 2]
    coefficients = TabularLearning.fit_linear(Xtrain[:, keep], deliveries.minutes[rows.train])
    prediction = TabularLearning.predict_linear(coefficients, Xvalidation[:, keep])
    @test round(TabularLearning.rmse(deliveries.minutes[rows.validation], prediction); digits=3) == 6.961
end

@testset "Causal exercise solutions" begin
    @test 0.85*180 + 0.15*60 ≈ 162
    @test 0.15*200 + 0.85*80 ≈ 98
    @test [120*(2t-1)-20 for t in (0.5, 0.85, 0.95)] ≈ [-20, 64, 88]
    data = (quantity=[80., 80., 70., 70., 200., 200., 160., 160.],
            high=[false, false, true, true, false, false, true, true],
            busy=[false, false, false, false, true, true, true, true])
    @test target_effect(data; busy_weight=0.2) ≈ -16
    @test target_effect(data; busy_weight=0.5) ≈ -25
    @test_throws ArgumentError target_effect(data; busy_weight=-0.1)
end

@testset "Bayesian exercise solutions" begin
    posterior = FootballWorkflow.goal_posterior([0, 1, 2])
    @test mean(posterior) ≈ 5/4
    @test var(posterior) ≈ 5/16
    @test mean(Gamma(4, 1/4)) == 1
    @test spread_gap([0, 1, 2]) == 0
    @test spread_gap([0, 0, 4, 4]) ≈ 10/3
    @test_throws ArgumentError spread_gap([1])
    training = FootballWorkflow.football_data()
    pooled = FootballWorkflow.replicate_goals(FootballWorkflow.goal_posterior(training.goals), length(training.goals))
    grouped = FootballWorkflow.grouped_replicates(training)
    pooled_check = FootballWorkflow.predictive_check(training.goals, pooled; statistic=spread_gap)
    grouped_check = FootballWorkflow.predictive_check(training.goals, grouped; statistic=spread_gap)
    @test pooled_check.observed > pooled_check.interval[2]
    @test grouped_check.replicated_mean > pooled_check.replicated_mean
end
