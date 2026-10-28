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
    # Keep the published comparison tied to the pinned, seeded experiment.
    @test round.([x.rmse for x in report.validation]; digits=3) ==
        [7.062, 7.115, 8.070, 12.003, 10.340, 6.679, 5.945]
    @test report.selected == "tree depth=6"
    @test round(report.test_rmse; digits=3) == 7.827
    @test round(report.test_mae; digits=3) == 4.387
    @test round(report.baseline_test_rmse; digits=3) == 17.429
    println(report)
end
