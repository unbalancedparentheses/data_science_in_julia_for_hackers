# julia --project=15_tabular_learning docs/interactive/tabular/generate_fixture.jl
using MLJ, Random, Statistics
include("../../../15_tabular_learning/core.jl")
include("../../../scripts/browser/write_fixture.jl")
const TL = TabularLearning
Ridge = @load RidgeRegressor pkg=MLJLinearModels verbosity=0
Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0
data = TL.delivery_data()
rows = TL.split_rows(length(data.minutes))
preparation = TL.fit_preprocessor(data, rows.train)
Xtrain = TL.transform(preparation, data, rows.train)
Xvalidation = TL.transform(preparation, data, rows.validation)
ytrain, yvalidation = data.minutes[rows.train], data.minutes[rows.validation]
train_table, validation_table = MLJ.table(Xtrain), MLJ.table(Xvalidation)
function record(name, predictions)
    (; name, predictions=collect(predictions), rmse=TL.rmse(yvalidation, predictions))
end
baseline = record("Training mean", fill(mean(ytrain), length(yvalidation)))
linear = record("Linear", TL.predict_linear(TL.fit_linear(Xtrain, ytrain), Xvalidation))
ridge = []
for penalty in (0.0, 0.01, 0.1, 1.0, 10.0)
    mach = machine(Ridge(lambda=penalty), train_table, ytrain)
    fit!(mach; verbosity=0)
    push!(ridge, (; penalty, record("Ridge", predict(mach, validation_table))...))
end
trees = []
for depth in 2:8
    mach = machine(Tree(max_depth=depth, min_samples_leaf=10, rng=MersenneTwister(1503)), train_table, ytrain)
    fit!(mach; verbosity=0)
    push!(trees, (; depth, record("Tree", predict(mach, validation_table))...))
end
write_fixture((; observed=collect(yvalidation), baseline, linear, ridge, trees), joinpath(@__DIR__, "data.js"))
