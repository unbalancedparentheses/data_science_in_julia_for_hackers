using Test, Statistics
include("core.jl")
using .TabularLearning

@testset "tabular preparation and regression" begin
    data = delivery_data()
    @test isequal(data, delivery_data())
    rows = split_rows(length(data.minutes))
    @test sort(vcat(rows.train, rows.validation, rows.test)) == collect(eachindex(data.minutes))
    prep = fit_preprocessor(data, rows.train)
    @test prep.center == median(skipmissing(data.distance[rows.train]))
    X = transform(prep, data, rows.train)
    @test size(X) == (length(rows.train), 4)
    @test all(isfinite, X)
    @test X[:, 2] == Float64.(ismissing.(data.distance[rows.train]))
    # Changing held-out values must not change fitted preprocessing.
    changed_distance = copy(data.distance)
    changed_distance[rows.test] .= 1e9
    changed = (; distance=changed_distance, data.weather, data.minutes)
    @test fit_preprocessor(changed, rows.train) == prep
    missing_case = (; distance=[missing], weather=["clear"])
    @test transform(prep, missing_case, [1])[1, 1:2] == [0.0, 1.0]
    @test_throws ArgumentError transform(prep, (; distance=[2.0], weather=["snow"]), [1])
    @test_throws ArgumentError fit_preprocessor((; distance=[missing], weather=["clear"]), [1])
    constant = fit_preprocessor((; distance=[2.0, 2.0], weather=["clear", "clear"]), [1, 2])
    @test constant.scale == 1
    exact_X = reshape(collect(1.0:10.0), :, 1)
    exact_y = 3 .+ 2 .* vec(exact_X)
    coef = fit_linear(exact_X, exact_y)
    @test coef ≈ [3.0, 2.0]
    @test predict_linear(coef, exact_X) ≈ exact_y
    # Penalizing slopes leaves the intercept free to retain a constant response.
    ridge = fit_linear(exact_X, fill(7.0, 10); lambda=100)
    @test ridge ≈ [7.0, 0.0] atol=1e-10
    @test abs(fit_linear(exact_X, exact_y; lambda=1)[2]) < abs(coef[2])
    @test_throws ArgumentError fit_linear(exact_X, exact_y; lambda=-1)
    fitted = fit_linear(X, data.minutes[rows.train])
    yval = data.minutes[rows.validation]
    prediction = predict_linear(fitted, transform(prep, data, rows.validation))
    @test rmse(yval, prediction) < rmse(yval, fill(mean(data.minutes[rows.train]), length(yval)))
    @test mae(yval, prediction) <= rmse(yval, prediction)
end
