using Test
include("mlj_comparison.jl")
@testset "MLJ comparison" begin
    report = compare_models()
    @test length(report.validation) == 7
    @test all(x -> isfinite(x.rmse) && x.rmse >= 0, report.validation)
    @test report.selected == report.validation[argmin([x.rmse for x in report.validation])].model
    @test report.n_test == 360
    @test report.test_rmse < report.baseline_test_rmse
    @test 0 <= report.test_mae <= report.test_rmse
    println(report)
end
