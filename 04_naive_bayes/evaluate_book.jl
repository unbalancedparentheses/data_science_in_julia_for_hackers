# Reproduce the chapter's fixed held-out result with its actual classifier functions.
# julia --project=tests 04_naive_bayes/evaluate_book.jl [--write]
using TextAnalysis, Random, TOML, SHA, Test
const ROOT = dirname(@__DIR__)
source = read(joinpath(ROOT, "04_naive_bayes.Rmd"), String)
function definition(prefix)
    tail = SubString(source, first(findfirst(prefix, source)))
    stop = findfirst(r"\nend(?=\n|$)", tail)
    String(tail[1:last(stop)])
end
for prefix in ("mutable struct BayesSpamFilter", "function words_count(",
               "function fit!(", "function word_spam_probability(",
               "function spam_predict(", "function get_predictions(", "function spam_filter_accuracy(")
    include_string(Main, definition(prefix))
end

# This bundled count CSV contains no quoted fields. Read its integer cells with
# standard libraries so reproducing one result does not load plotting packages.
path = joinpath(@__DIR__, "data", "emails.csv")
lines = readlines(path)
@assert all(line -> !occursin('"', line), lines)
header = split(lines[1], ',')
@assert length(header) == 3002 && length(lines) == 5173
all_words = header[2:end-1]
document = StringDocument(join(all_words, " "))
prepare!(document, strip_articles)
prepare!(document, strip_pronouns)
vocabulary = split(TextAnalysis.text(document))
columns = [findfirst(==(word), header) for word in vocabulary]
data_matrix = Matrix{Int}(undef, length(columns), length(lines)-1)
labels = Vector{Int}(undef, length(lines)-1)
for (i, line) in enumerate(lines[2:end])
    fields = split(line, ',')
    @assert length(fields) == length(header)
    data_matrix[:, i] = parse.(Int, fields[columns])
    labels[i] = parse(Int, fields[end])
end
# Execute the book's split directly, rather than maintain a second split rule.
split_chunk = match(r"```\{julia[^\n]*\n(labels = raw_df.Prediction.*?)```"s, source).captures[1]
include_string(Main, replace(split_chunk, "labels = raw_df.Prediction" => ""))
@test isempty(intersect(train_rows, test_rows))
@test sort(vcat(train_rows, test_rows)) == collect(eachindex(labels))
model = BayesSpamFilter()
fit!(model, x_train, y_train, vocabulary)
predictions = get_predictions(x_test, y_test, model, 1)
tn = count((predictions .== 0) .& (y_test .== 0))
fn = count((predictions .== 0) .& (y_test .== 1))
fp = count((predictions .== 1) .& (y_test .== 0))
tp = count((predictions .== 1) .& (y_test .== 1))
result = Dict("dataset_sha256" => bytes2hex(sha256(read(path))),
              "seed" => 123, "training_count" => length(y_train), "test_count" => length(y_test),
              "vocabulary_count" => length(vocabulary), "first_predictions" => predictions[1:5],
              "true_ham" => tn, "missed_spam" => fn, "blocked_ham" => fp, "true_spam" => tp,
              "accuracy" => spam_filter_accuracy(predictions, y_test), "ham_recall" => tn/(tn+fp),
              "spam_recall" => tp/(fn+tp), "spam_fraction" => sum(labels)/length(labels),
              "all_ham_accuracy" => count(==(0), y_test)/length(y_test))
@test tn + fn + fp + tp == length(y_test)
fixture = joinpath(@__DIR__, "book_results.toml")
if "--write" in ARGS
    open(fixture, "w") do io
        TOML.print(io, result; sorted=true)
    end
else
    expected = TOML.parsefile(fixture)
    @test result == expected
end
TOML.print(stdout, result; sorted=true)
