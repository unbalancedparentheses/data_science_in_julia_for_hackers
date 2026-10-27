using Test

const ROOT = dirname(@__DIR__)

function definition(source, prefix)
    start = findfirst(prefix, source)
    isnothing(start) && error("Missing definition: $prefix")
    tail = SubString(source, first(start))
    stop = findfirst(r"\nend(?=\n|$)", tail)
    isnothing(stop) && error("Missing end: $prefix")
    return String(tail[1:last(stop)])
end

@testset "Spam classifier: $file" for file in (
    "04_naive_bayes.Rmd", "04_naive_bayes/04_naive_bayes.jl", "04_naive_bayes/tmp.jl")
    source = read(joinpath(ROOT, file), String)
    mod = Module(gensym(:Spam))
    Core.eval(mod, :(using TextAnalysis))
    for prefix in ("mutable struct BayesSpamFilter", "function words_count(",
                   "function fit!(", "function word_spam_probability(", "function spam_predict(")
        Core.eval(mod, Meta.parse(definition(source, prefix)))
    end
    model = mod.BayesSpamFilter()
    data = zeros(Int, 2, 10)
    data[1, 1] = 100
    data[2, 2:10] .= 1
    mod.fit!(model, data, [0; ones(Int, 9)], ["alpha", "beta"])
    @test collect(mod.spam_predict("unknown", model, 1)) ≈ [0.1, 0.9]
    @test collect(mod.spam_predict("", model, 1)) ≈ [0.1, 0.9]

    mod.fit!(model, [8 2; 2 8], [0, 1], ["alpha", "beta"])
    @test collect(mod.spam_predict("alpha beta", model, 1)) ≈ [0.5, 0.5]
    @test collect(mod.spam_predict("alpha alpha alpha beta", model, 1)) ≈ [0.9, 0.1]
    @test collect(mod.spam_predict("unknown unknown alpha", model, 1, 1)) ≈ [0.75, 0.25]
    @test collect(mod.spam_predict("alpha beta", model, 1, 1)) ≈ [0.75, 0.25]
    long_result = mod.spam_predict(repeat("alpha ", 10_000), model, 1)
    @test all(isfinite, long_result)
    @test sum(long_result) ≈ 1
    @test long_result[1] > 0.99
    @test_throws ArgumentError mod.spam_predict("alpha", model, 0)
    @test_throws ArgumentError mod.spam_predict("alpha", model, 1, 0)
    @test_throws ArgumentError mod.fit!(model, zeros(Int, 2, 0), Int[], ["alpha", "beta"])
    # A model trained on one class still gives a finite posterior.
    mod.fit!(model, reshape([8, 2], 2, 1), [0], ["alpha", "beta"])
    @test mod.spam_predict("alpha", model, 1) == (1.0, 0.0)
end

@testset "Image output paths: $file" for file in (
    "10_bees_vs_wasps.Rmd", "10_bees_vs_wasps/10_bees_vs_wasps.jl", "10_bees_vs_wasps/image_processing.jl")
    source = read(joinpath(ROOT, file), String)
    mod = Module(gensym(:Images))
    # Exercise the actual helper's filesystem/error behavior without image codecs.
    Core.eval(mod, quote
        Gray = identity
        load(path) = read(path)
        imresize(image, width, height) = image
        fail_save = false
        function save(path, image)
            fail_save && error("codec failure")
            write(path, image)
        end
    end)
    Core.eval(mod, Meta.parse(definition(source, "function resize_and_grayify(")))
    mktempdir() do directory
        cd(directory) do
            mkpath("data/bee1")
            write("data/bee1/example.jpg", "image fixture")
            mod.resize_and_grayify("data/bee1", "example.jpg", 90, 90)
            @test read("preprocessed_data/bee1/example.jpg", String) == "image fixture"
            mod.resize_and_grayify("data/bee1", "example.jpg", 90, 90)
            @test isfile("preprocessed_data/bee1/example.jpg")
            Core.eval(mod, :(fail_save = true))
            @test_throws ErrorException mod.resize_and_grayify("data/bee1", "example.jpg", 90, 90)
        end
    end
end
