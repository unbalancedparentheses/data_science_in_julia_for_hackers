using Test, Statistics
include("core.jl")
using .CausalPricing
@testset "Pricing interventions" begin
    result = pricing_demo(n=20000)
    @test result.oracle ≈ -20
    @test result.naive.estimate > 40 # Confounding reverses the association.
    @test abs(result.adjusted - result.oracle) < 1.0
    @test abs(result.randomized.estimate - result.oracle) < 3.0
    @test result.profit_effect.estimate > 0
    @test pricing_demo(n=100).historical.quantity == pricing_demo(n=100).historical.quantity
    @test_throws ArgumentError observe_prices(result.population; high_given_busy=1)
    @test_throws ArgumentError difference_in_means([1, 2, 3], [true, true, true])
    @test_throws DimensionMismatch difference_in_means([1, 2], [true])
    @test difference_in_means([1., 1., 4., 4.], [false, false, true, true]).interval == (3., 3.)
end
