# Headless package/data smoke check; this does not execute the full legacy notebook.
ENV["GKSwstype"] = "100"
using Test
using CSV, DataFrames, Distributions, Images, ImageTransformations, Plots, StatsPlots

@testset "Chapter 3 environment and bundled assets" begin
    data = CSV.read(joinpath(@__DIR__, "data", "historico_precipitaciones.csv"), DataFrame)
    @test nrow(data) > 0
    @test ncol(data) == 4
    picture = load(joinpath(@__DIR__, "images", "box-experiment.jpg"))
    @test size(imresize(picture, (336, 400))) == (336, 400)
    @test pdf(Poisson(1.5), 0) ≈ exp(-1.5)
    mktempdir() do directory
        output = joinpath(directory, "distribution.png")
        savefig(bar(Poisson(1.5)), output)
        @test filesize(output) > 0
    end
end
