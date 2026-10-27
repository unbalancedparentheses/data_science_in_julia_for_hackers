### A Pluto.jl notebook ###
# v0.20.0

using Markdown
using InteractiveUtils

# ╔═╡ 6cd71344-fe9d-5feb-8c99-2a56f6f560b1
md"""# Predicting delivery times

Compare a linear model, ridge regression and a tree on synthetic deliveries with missing distances and categorical weather. The controls expose **validation** errors only. Choose the procedure before evaluating a final test set with `mlj_comparison.jl`.
"""

# ╔═╡ 93422f13-e60b-563a-9720-8dae353c078b
begin
    import Pkg
    Pkg.activate(@__DIR__)
    using PlutoUI, MLJ
    using Random, Statistics
    include(joinpath(@__DIR__, "core.jl"))
    const TL = TabularLearning
    Ridge = @load RidgeRegressor pkg=MLJLinearModels verbosity=0
    Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0
end

# ╔═╡ 33f74961-2bef-56cd-a4db-53754efb55f7
macro bind(def, element)
    quote
        local widget = $(esc(element))
        global $(esc(def)) = Base.get(widget)
        widget
    end
end

# ╔═╡ 4c86a2fb-7b08-5802-a262-a9767722c9fc
begin
    deliveries = TL.delivery_data()
    rows = TL.split_rows(length(deliveries.minutes))
    preparation = TL.fit_preprocessor(deliveries, rows.train)
    Xtrain = TL.transform(preparation, deliveries, rows.train)
    Xvalidation = TL.transform(preparation, deliveries, rows.validation)
    ytrain = deliveries.minutes[rows.train]
    yvalidation = deliveries.minutes[rows.validation]
    train_table = MLJ.table(Xtrain)
    validation_table = MLJ.table(Xvalidation)
    baseline_error = TL.rmse(yvalidation, fill(mean(ytrain), length(yvalidation)))
    linear_error = TL.rmse(yvalidation, TL.predict_linear(TL.fit_linear(Xtrain, ytrain), Xvalidation))
end

# ╔═╡ f5c24be6-2656-5e6e-ad8a-b413e7b99cff
md"""Ridge penalty:
$(@bind ridge_penalty Select([0.0, 0.01, 0.1, 1.0, 10.0]; default=0.1))

Maximum tree depth:
$(@bind tree_depth Slider(2:8; default=4, show_value=true))
"""

# ╔═╡ b1db3866-2611-5229-9d9d-ea2bd20f8e56
begin
    ridge_machine = machine(Ridge(lambda=ridge_penalty), train_table, ytrain)
    fit!(ridge_machine; verbosity=0)
    ridge_error = TL.rmse(yvalidation, predict(ridge_machine, validation_table))
end

# ╔═╡ 9beb3dc5-9d4e-54da-b5c1-c87331f0f2f4
begin
    tree_machine = machine(Tree(max_depth=tree_depth, min_samples_leaf=10,
                                rng=MersenneTwister(1503)), train_table, ytrain)
    fit!(tree_machine; verbosity=0)
    tree_error = TL.rmse(yvalidation, predict(tree_machine, validation_table))
end

# ╔═╡ b331f1ad-0154-5336-a07b-3831c9c693fe
md"""## Validation RMSE, in minutes

| Model | RMSE |
|:--|--:|
| Training-mean baseline | $(round(baseline_error; digits=2)) |
| Ordinary least squares | $(round(linear_error; digits=2)) |
| Ridge, penalty $(ridge_penalty) | $(round(ridge_error; digits=2)) |
| Tree, depth $(tree_depth) | $(round(tree_error; digits=2)) |

All models use the same rows. Median imputation, scaling, and weather encoding were fitted only on training data. Missing distances lose information that no algorithm can fully reconstruct here.

Trying enough settings can overfit validation data too. Record your search, freeze a choice, and use a separate final test assessment. The independent `mlj_comparison.jl` script runs its own predeclared candidate grid; it does not silently adopt these exploratory slider choices.
"""

# ╔═╡ Cell order:
# ╟─6cd71344-fe9d-5feb-8c99-2a56f6f560b1
# ╠═93422f13-e60b-563a-9720-8dae353c078b
# ╠═33f74961-2bef-56cd-a4db-53754efb55f7
# ╠═4c86a2fb-7b08-5802-a262-a9767722c9fc
# ╟─f5c24be6-2656-5e6e-ad8a-b413e7b99cff
# ╠═b1db3866-2611-5229-9d9d-ea2bd20f8e56
# ╠═9beb3dc5-9d4e-54da-b5c1-c87331f0f2f4
# ╟─b331f1ad-0154-5336-a07b-3831c9c693fe
