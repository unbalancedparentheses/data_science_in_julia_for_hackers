using Test
include("core.jl")
using .ModelEvaluation

@testset "evaluation contracts" begin
    mail = synthetic_mail()
    @test mail == synthetic_mail()
    rows = split_rows(length(mail.label))
    @test sort(vcat(rows.train, rows.validation, rows.test)) == collect(eachindex(mail.label))
    @test isempty(intersect(rows.train, rows.validation))
    @test isempty(intersect(rows.train, rows.test))
    @test isempty(intersect(rows.validation, rows.test))
    c = confusion([1, 1, 0, 0], [0.9, 0.2, 0.8, 0.1])
    @test c == (tp=1, fp=1, tn=1, fn=1)
    @test metrics(c) == (accuracy=0.5, precision=0.5, recall=0.5, false_positive_rate=0.5)
    @test mean_cost(c; false_positive_cost=5, false_negative_cost=1) == 1.5
    baseline = metrics(confusion([1, 0, 0], zeros(3)))
    @test baseline.accuracy ≈ 2/3
    @test ismissing(baseline.precision)
    @test baseline.recall == 0
    @test brier_score([0, 1], [0.0, 1.0]) == 0
    @test brier_score([0, 1], [1.0, 0.0]) == 1
    @test sum(x.n for x in reliability([0, 1], [0.0, 1.0])) == 2
    @test_throws ArgumentError confusion([0], [NaN])
    @test_throws ArgumentError confusion(Int[], Float64[])
    @test_throws DimensionMismatch confusion([0, 1], [0.5])
    @test_throws ArgumentError fit_score(Int[], Int[])
    # Rates are determined by training examples, not a global dataset.
    @test fit_score([1, 1, 2, 2], [0, 0, 1, 1]) == [0.25, 0.75, 0.5, 0.5]
    # A larger false-positive penalty changes the selected action.
    y, p = [1, 0], [0.8, 0.7]
    @test choose_threshold(y, p; thresholds=[0.5, 0.9], false_positive_cost=0.1).threshold == 0.5
    @test choose_threshold(y, p; thresholds=[0.5, 0.9], false_positive_cost=5).threshold == 0.9
    expected = expected_confusion((tp=8, fp=1, tn=9, fn=2); prevalence=0.2, n=1000)
    @test expected == (tp=160.0, fp=80.0, tn=720.0, fn=40.0)
    @test sum(values(expected)) == 1000
    @test_throws ArgumentError expected_confusion((tp=0, fp=1, tn=9, fn=0))
    model = fit_score(mail.signal[rows.train], mail.label[rows.train])
    pval = predict_score(model, mail.signal[rows.validation])
    policy = choose_threshold(mail.label[rows.validation], pval)
    ytest = mail.label[rows.test]
    test_p = predict_score(model, mail.signal[rows.test])
    @test 0 <= brier_score(ytest, test_p) <= 1
    @test sum(values(confusion(ytest, test_p; threshold=policy.threshold))) == length(rows.test)
end

@testset "Published fixed-split results" begin
    mail = synthetic_mail()
    rows = split_rows(length(mail.label))
    model = fit_score(mail.signal[rows.train], mail.label[rows.train])
    pval = predict_score(model, mail.signal[rows.validation])
    counts = confusion(mail.label[rows.validation], pval)
    @test counts == (tp=14, fp=4, tn=1115, fn=67)
    policy = choose_threshold(mail.label[rows.validation], pval)
    bins = reliability(mail.label[rows.validation], pval; bins=5)
    @test getproperty.(bins, :n) == [1089, 93, 18]
    @test round(brier_score(mail.label[rows.validation], pval); digits=5) == 0.04362
    @test round(brier_score(mail.label[rows.test], predict_score(model, mail.signal[rows.test])); digits=5) == 0.04482
    @test policy.threshold == 0.85
    @test policy.validation_cost == 81/1200
    @test mean_cost(counts) == 87/1200
    @test confusion(mail.label[rows.test], predict_score(model, mail.signal[rows.test]);
                    threshold=policy.threshold) == (tp=0, fp=0, tn=1108, fn=92)
end
