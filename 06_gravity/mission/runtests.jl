using Test
include("core.jl")
using .MarsMission
@testset "Mars mission physics and inference" begin
    @test gravity_from_throw(20, 4, 45) ≈ 2.5
    @test gravity_from_throw(20, 4, 30) ≈ 2.5/sqrt(3)
    @test escape_speed(4*3.7) ≈ 2escape_speed(3.7)
    @test escape_speed(0) == 0
    @test_throws ArgumentError gravity_from_throw(20, 0, 45)
    @test_throws ArgumentError escape_speed(-1)
    times = [3.0, 4.0, 5.0, 6.0]
    distances = 3.7 .* times.^2 ./ 2
    known = posterior(distances, times; sigma=1, halfwidth=0)
    @test sum(known.masses) ≈ 1
    @test known.gs[argmax(known.masses)] ≈ 3.7
    # An analytic Gaussian likelihood at known angle has this posterior scale.
    mean_g = sum(known.gs .* known.masses)
    variance_g = sum((known.gs .- mean_g).^2 .* known.masses)
    @test mean_g ≈ 3.7 atol=1e-10
    @test variance_g ≈ 1/sum((times.^2 ./ 2).^2) rtol=1e-8
    biased = posterior(distances, 1.05 .* times; sigma=1, halfwidth=0)
    @test abs(biased.gs[argmax(biased.masses)] - 3.7/1.05^2) < 0.011
    noisy = posterior(distances, times; sigma=2, halfwidth=0)
    @test sum((noisy.gs .- sum(noisy.gs .* noisy.masses)).^2 .* noisy.masses) ≈ 4variance_g rtol=1e-8
    uncertain = posterior(distances, times; sigma=1, halfwidth=7.5)
    @test sum((uncertain.gs .- sum(uncertain.gs .* uncertain.masses)).^2 .* uncertain.masses) > variance_g
    @test mission_summary(known; budget=100).probability_within_budget ≈ 1
    @test mission_summary(known; budget=0).probability_within_budget == 0
    @test weighted_quantile([1,2,3], [0.2,0.6,0.2], 0.5) == 2
    @test_throws ArgumentError posterior(distances, times; sigma=0)
    @test_throws ArgumentError posterior(distances, times; halfwidth=45)
    @test_throws ArgumentError posterior(distances, times; gs=[1.,2.,4.])
    # Refining both integrations should leave mission quantiles nearly unchanged.
    coarse = mission_summary(posterior(distances, times))
    fine = mission_summary(posterior(distances, times; gs=collect(0.01:0.01:10), angle_points=121))
    @test maximum(abs.(coarse.interval .- fine.interval)) < 0.03
end

@testset "Published instrument comparison" begin
    distances = [25.94, 38.84, 52.81, 45.54, 17.24]
    times = [3.91, 4.57, 5.43, 4.85, 3.15]
    intervals = [mission_summary(posterior(distances, times; sigma, halfwidth)).interval
                 for (sigma, halfwidth) in ((3.0, 7.5), (3.0, 0.0), (1.5, 7.5))]
    # Assert the published rounded endpoints, not the unreported interior median.
    @test [round.([v[1], v[3]]; digits=3) for v in intervals] ==
          [[4.231, 5.387], [4.608, 4.882], [4.231, 5.375]]
    widths = [v[3]-v[1] for v in intervals]
    @test round.(widths; digits=3) == [1.155, 0.273, 1.144]
    @test 0.75 < 1-widths[2]/widths[1] < 0.77
    @test 0.009 < 1-widths[3]/widths[1] < 0.011
    # Distinct angle/gravity pairs can predict exactly the same complete dataset.
    @test (3.7 .* times.^2 ./ (2tand(45))) ≈
          (3.7*tand(50)/tand(45) .* times.^2 ./ (2tand(50)))
end
