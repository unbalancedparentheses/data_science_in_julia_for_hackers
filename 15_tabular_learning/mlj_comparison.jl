# Run from the repository root:
# julia --project=15_tabular_learning 15_tabular_learning/mlj_comparison.jl
using MLJ
using Random, Statistics
include("core.jl")
# Qualify names because MLJ also exports transform and rmse.
const TL = TabularLearning
const Ridge = @load RidgeRegressor pkg=MLJLinearModels verbosity=0
const Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0

function compare_models(; n=1800)
    data = TL.delivery_data(n)
    rows = TL.split_rows(n)
    preparation = TL.fit_preprocessor(data, rows.train)
    Xtrain = TL.transform(preparation, data, rows.train)
    Xvalidation = TL.transform(preparation, data, rows.validation)
    ytrain = data.minutes[rows.train]
    yvalidation = data.minutes[rows.validation]
    train_table = MLJ.table(Xtrain)
    validation_table = MLJ.table(Xvalidation)

    models = Any[Ridge(lambda=lambda) for lambda in (0.0, 0.01, 0.1, 1.0)]
    append!(models, [Tree(max_depth=depth, min_samples_leaf=10,
                         rng=MersenneTwister(1503)) for depth in (2, 4, 6)])
    names = vcat(["ridge lambda=$lambda" for lambda in (0.0, 0.01, 0.1, 1.0)],
                 ["tree depth=$depth" for depth in (2, 4, 6)])
    machines = [machine(model, train_table, ytrain) for model in models]
    for mach in machines
        fit!(mach; verbosity=0)
    end
    validation_rmse = [TL.rmse(yvalidation, predict(mach, validation_table)) for mach in machines]
    best = argmin(validation_rmse)
    # The holdout does not participate in transformations, fitting, or selection.
    Xtest = MLJ.table(TL.transform(preparation, data, rows.test))
    ytest = data.minutes[rows.test]
    test_prediction = predict(machines[best], Xtest)
    return (; validation=[(; model=names[i], rmse=validation_rmse[i]) for i in eachindex(names)],
            selected=names[best], test_rmse=TL.rmse(ytest, test_prediction),
            test_mae=TL.mae(ytest, test_prediction),
            baseline_test_rmse=TL.rmse(ytest, fill(mean(ytrain), length(ytest))),
            n_test=length(ytest))
end

if abspath(PROGRAM_FILE) == @__FILE__
    report = compare_models()
    foreach(println, report.validation)
    println("Selected using validation: ", report.selected)
    println("Final test: ", (; report.test_rmse, report.test_mae,
                              report.baseline_test_rmse, report.n_test))
end
