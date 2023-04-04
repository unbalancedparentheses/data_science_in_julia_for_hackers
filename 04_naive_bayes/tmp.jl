#cd("./04_naive_bayes/")
import Pkg
Pkg.activate(".")
using CSV
using DataFrames
using Distributions
using TextAnalysis
using Languages
using MLDataUtils
using Plots
using Random

Random.seed!(0)

raw_df = CSV.read("./data/emails.csv", DataFrame)

# Get the list of all words present in all mails.
# We strip the first and last columns which are the email id and classification 
all_words = names(raw_df)[2:end-1]

# Create a StringDocument, a struct with methods to remove articles and
# pronouns from the text
all_words_text = join(all_words, " ")
document = StringDocument(all_words_text)

# Remove articles and pronouns
prepare!(document, strip_articles)
prepare!(document, strip_pronouns)

# Create another DataFrame with the filtered words.
vocabulary = split(TextAnalysis.text(document))
clean_words_df = raw_df[!, vocabulary]

# Transform the DataFrame into a Matrix and transpose it to have each 
# mail as a column. 
data_matrix = Matrix(clean_words_df)'

labels = raw_df.Prediction
(x_train, y_train), (x_test, y_test) = splitobs(shuffleobs((data_matrix, labels)), at=0.7)

mutable struct BayesSpamFilter
    words_count_ham::Dict{String,Int64}
    words_count_spam::Dict{String,Int64}
    N_ham::Int64
    N_spam::Int64
    vocabulary::Array{String}
    BayesSpamFilter() = new()
end

function words_count(word_data, vocabulary, labels, spam=0)
    count_dict = Dict{String,Int64}()
    n_emails = size(word_data)[2]
    for (i, word) in enumerate(vocabulary)
        count_dict[word] = sum([word_data[i, j] for j in 1:n_emails if labels[j] == spam])
    end
    return count_dict
end

function fit!(model::BayesSpamFilter, x_train, y_train, voc)
    model.vocabulary = voc
    model.words_count_ham = words_count(x_train, model.vocabulary, y_train, 0)
    model.words_count_spam = words_count(x_train, model.vocabulary, y_train, 1)
    model.N_ham = sum(values(model.words_count_ham))
    model.N_spam = sum(values(model.words_count_spam))
    return
end

spam_filter = BayesSpamFilter()
fit!(spam_filter, x_train, y_train, vocabulary)

function word_spam_probability(word, words_count_ham, words_count_spam, N_ham, N_spam, n_vocabulary, α)
    ham_prob = (words_count_ham[word] + α) / (N_ham + α * (n_vocabulary))
    spam_prob = (words_count_spam[word] + α) / (N_spam + α * (n_vocabulary))
    return ham_prob, spam_prob
end

function spam_predict(email, model::BayesSpamFilter, α, tol=100)
    ngrams_email = ngrams(StringDocument(email))
    email_words = keys(ngrams_email)
    n_vocabulary = length(model.vocabulary)
    ham_prior = model.N_ham / (model.N_ham + model.N_spam)
    spam_prior = model.N_spam / (model.N_ham + model.N_spam)

    if length(email_words) > tol
        word_freq = values(ngrams_email)
        sort_idx = sortperm(collect(word_freq), rev=true)
        email_words = collect(email_words)[sort_idx][1:tol]
    end

    email_ham_probability = BigFloat(1)
    email_spam_probability = BigFloat(1)

    for word in intersect(email_words, model.vocabulary)
        word_ham_prob, word_spam_prob = word_spam_probability(word, model.words_count_ham, model.words_count_spam, model.N_ham, model.N_spam, n_vocabulary, α)
        email_ham_probability *= word_ham_prob
        email_spam_probability *= word_spam_prob
    end
    return ham_prior * email_ham_probability, spam_prior * email_spam_probability
end

function get_predictions(x_test, y_test, model::BayesSpamFilter, α, tol=200)
    N = length(y_test)
    predictions = Array{Int64,1}(undef, N)
    for i in 1:N
        email = string([repeat(string(word, " "), N) for (word, N) in zip(model.vocabulary, x_test[:, i])]...)
        pham, pspam = spam_predict(email, model, α, tol)
        pred = argmax([pham, pspam]) - 1
        predictions[i] = pred
    end

    predictions
end

predictions = get_predictions(x_test, y_test, spam_filter, 1)
predictions[1:5]

function spam_filter_accuracy(predictions, actual)
    N = length(predictions)
    correct = sum(predictions .== actual)
    accuracy = correct / N
    accuracy
end

spam_filter_accuracy(predictions, y_test)
sum(x_train) / length(x_train)

function spam_filter_confusion_matrix(y_test, predictions)
    # 2x2 matrix is instantiated with zeros
    confusion_matrix = zeros((2, 2))

    confusion_matrix[1, 1] = sum(isequal(y_test[i], 0) & isequal(predictions[i], 0) for i in eachindex(y_test))
    confusion_matrix[1, 2] = sum(isequal(y_test[i], 1) & isequal(predictions[i], 0) for i in eachindex(y_test))
    confusion_matrix[2, 1] = sum(isequal(y_test[i], 0) & isequal(predictions[i], 1) for i in eachindex(y_test))
    confusion_matrix[2, 2] = sum(isequal(y_test[i], 1) & isequal(predictions[i], 1) for i in eachindex(y_test))

    # Now we convert the confusion matrix into a DataFrame 
    confusion_df = DataFrame(prediction=String[], ham_mail=Integer[], spam_mail=Integer[])
    confusion_df = vcat(confusion_df, DataFrame(prediction="Model predicted Ham", ham_mail=confusion_matrix[1, 1], spam_mail=confusion_matrix[1, 2]))
    confusion_df = vcat(confusion_df, DataFrame(prediction="Model predicted Spam", ham_mail=confusion_matrix[2, 1], spam_mail=confusion_matrix[2, 2]))

    return confusion_df
end

confusion_matrix = spam_filter_confusion_matrix(y_test[:], predictions)
ham_accuracy = confusion_matrix[1, :ham_mail] / (confusion_matrix[1, :ham_mail] + confusion_matrix[2, :ham_mail])
spam_accuracy = confusion_matrix[2, :spam_mail] / (confusion_matrix[1, :spam_mail] + confusion_matrix[2, :spam_mail])