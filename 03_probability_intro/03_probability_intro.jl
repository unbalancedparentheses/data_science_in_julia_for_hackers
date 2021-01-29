### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ e6ecfce4-54e5-11eb-2ff6-3bb479c286af
using StatsPlots

# ╔═╡ 8b06866e-5424-11eb-3cb6-f9afabefcd70
begin
	using Plots
	using Distributions
	
	plot(Normal(64, 3), xlabel="Height (in)", ylabel="Probability", legend=false, size=(400, 300))
end

# ╔═╡ e45d76d4-1250-11eb-14d7-c30fcb5a5b72
begin
	using CSV
	using DataFrames
	rain_data = CSV.read("/Users/lambda/Desktop/Julia/Libro/bayes_book/prob_intro/data/historico_precipitaciones.csv", DataFrame)
	colnames = ["Year", "Month", "mm", "Days"]
	names!(rain_data, Symbol.(colnames))
	
	for i in 1:length(rain_data[:Month])
		if rain_data[:Month][i] == "Enero" rain_data[:Month][i] = "January"
		elseif rain_data[:Month][i] == "Febrero" rain_data[:Month][i] = "February"
		elseif rain_data[:Month][i] == "Marzo" rain_data[:Month][i] = "March"
		elseif rain_data[:Month][i] == "Abril" rain_data[:Month][i] = "April"
		elseif rain_data[:Month][i] == "Mayo" rain_data[:Month][i] = "May"
		elseif rain_data[:Month][i] == "Junio" rain_data[:Month][i] = "June" 
		elseif rain_data[:Month][i] == "Julio" rain_data[:Month][i] = "July"  				elseif rain_data[:Month][i] == "Agosto" rain_data[:Month][i] = "August" 
		elseif rain_data[:Month][i] == "Septiembre" rain_data[:Month][i] = "September" 
		elseif rain_data[:Month][i] == "Octubre" rain_data[:Month][i] = "October"
		elseif rain_data[:Month][i] == "Noviembre" rain_data[:Month][i] = "November"
		elseif rain_data[:Month][i] == "Diciembre" rain_data[:Month][i] = "December"
		end
	end
end;

# ╔═╡ 84b10156-5116-11eb-1a6d-13f625300801
md"
# Introduction to Probability
In this book, probability and statistics topics will be discussed extensively. Mainly the Bayesian interpretation of probability and Bayesian statistics. But we first need an intuitive conceptual basis to build on top of that. 
We won't assume any prior knowledge, so let's start from the basics. What *is* probability? Probability si a measure of uncertainty of a particular event happening or the degree of confidence about some statement or hypothesis, that we express with a number ranging from $0$ to $1$. The number $0$ means we know with certainty that the event will not happen (or that the hypothesis is false), while the number $1$ means we know with certainty that the event will happen (or that the hypothesis is true). How exactly this number is linked to each event is something that is far from trivial and indeed is a discussion that has been going for years. Later on we will dive deeper into that rabbit hole, but for the moment lets not worry about how exacly this is defined or calculated: assume we have well established method for the time being. The important thing now will be the different rules that emerge from the nature of these events.

We can start reasoning about probabilities of events with an example. Say we know that the probability of raining today in Buenos Aires is $0.8$. In a more mathematical form, we can say that

$P(R) = 0.8,$

where $R$ stands for the event 'it will rain in Buenos Aires today'. Now let's think about another event, for example, the eruption of the Mount Merapi volcano in Indonesia. Say we consulted some geologists and the probability of that eruption happening today is of $0.005$. Mathematically, we say

$P(V) = 0.005,$

where V, in this case, stands for the event 'the volcano will erupt today'. Let's analyze the nature of these events a little bit. Are they related? Technically, we can think everything in our planet is interconnected with everything else, Butterfly Effect and all that story. But in practice, it is fair to assume these two events are pretty independent from one another. In a more formal way, what this is telling us is that knowing the probability of one of the events does not give us information about the probability of the other event. That is the definition of independence in this context. In the language of probabilities, we can write a special property for independent events,

$P(\text{R and V}) = P(R)P(V).$

Coloquially, this means that the probability of both of events 'it will rain in Buenos Aires today' and 'the volcano will erupt today' happening together is equal to the product of each of the probabilities of each one happening individually. Calculating the probability of various events happening at the same time is known as calculating the *joint probability* of the events. When the events are not independent from one another, unfortunately, things are not so simple. This leads us into another important concept, and really fundamental to the Bayesian interpretation of probability, which we will discuss later on. 
When events are not independent, it is relevant to talk about *conditional probability*. Conditional probability of two events A and B is noted as

$P(A|B)\text{ or }P(B|A)$

In general, $P(A|B)$ and $P(B|A)$, which reads as 'the conditional probability of A given B' and 'the conditional probability of B given A',
are not equal, that's why I have written the two possibilities. The way to interpret this, for example $P(A|B)$, is: 'the probability of the event A happening, *given* that we know the event B occured'. The analogous interpretation for $P(B|A)$ would be 'the probability of event B happening, given that we know the event A occured'. Altough it may sound as if this implies an order in the occurance of the events, that isn't necessary the case. What in reality has an actual order in this statement is our knowledge of what things happened. If we say, for example, $P(A|B)$, then what we know first is event B, and given this knowledge, we want to know the probability of event A.

Let's see in a simple example how this conditional probability arises from two non-independent events. Assume we have, again, the event R 'it will rain today in Buenos Aires', and another event H, 'staying at home today'. Applying what we learned, we would first ask ourselves if these two events are independent or interdependent. If they were completely independent one from another, when trying to compute the conditional probabilities, for example $P(R|H)$, we will have

$P(R|H) = P(R)$

What this equation is telling us, is that the information that the event H happened, does not affect the probability of event R. That is the bare definition of independence! However, this only means the event R is independent from the event H. This does not automatically mean that the event H is endependent of R. In fact, if we pay a little more attention to how these events relate one another, we have our answer.
The probability of raining today in Buenos Aires won't change by the fact I stay at home or not. I can't change the climate, at least in that direct way. So effectively, $P(R|H) = P(R)$ is correct. But what if we invert the events? In this case, if we think about it for a second we will notice that

$P(H|R) \neq P(H)$

Indeed, if we know that it is raining, the probability of staying at home should be affected! In my case, I would much prefer to stay at home, so that probability will be higher. 
At this point, we would state a formula that relates conditional probability and conjoint probability. For two general events A and B, this is

$P(A\text{ and }B) = P(A)P(B|A)$

With this formula in mind, and another property of conjunction probability,

$P(A\text{ and }B) = P(B\text{ and }A)$

which just means what we naturally interpret of two events happening *at the same time*. If the two events do happen at the same time, it doesn't matter if we write $B\text{ and }A)$ or $A\text{ and }B$, setting an order in the expression is just a consequence of having to write it. Just as like doing $2 + 3$ or $3 + 2$, the 'and' logical operator is commutative. We now proceed to derive the famous **Bayes' theorem**! We write 

$P(B\text{ and }A) = P(B)P(A|B),$

and putting all the pieces together, 

$P(B)P(A|B) = P(A)P(B|A) \implies P(A|B) = \frac{P(A)P(B|A)}{P(B)}$

Summing up, we arrived to Bayes' theorem:

$P(A|B) = \frac{P(A)P(B|A)}{P(B)}$

This theorem does not only give us a practical way to calculate conditional probabilities, but also is the fundamental building block of the Bayesian interpretation of probability. But what does this even mean? Here we must take a step back and focus on the details of how exactly probability is defined for an event or hypothesis.

There are two main approaches to probability, the *frequentist* approach 
and the one we have already introduced, the *Bayesian* one. The 
frequentist interpretation views probability as the frequency of events 
when a big number of repetitions are carried out. The typical example of 
this is the flipping of a coin. To know the probability of obtaining 
heads when flipping a coin, a frequentist will tell you to perform an 
experiment with a lot of coin tosses (say, 1000 repetitions). You write 
down the outcome (heads or tails) of each flip and then you calculate the 
heads ratio over the toal amount of repetitions, i.e.: $P(H) = 511 / 1000 
= 0,511$. This will be your probability from a pure frequentist point of 
view.

The Bayesian point of view has a more general interpretation. It is not bound to the frequency of events. Probability is thought as a degree of uncertainty about the event happening and also takes into account our current state of knowledge about that event. In a Bayesian way of thinking one could assign (and actually it is done extensively) a probability to events such as the election of some politician, while in the frequentist view this would make no sense, since we can't make large repetitions of the election to know the frequency underlying that event.

You might be asking yourself: How does this Bayesian probability work? What is the hidden mechanism inside of it? Take another look at Bayes' theorem. We have talked about it applying to events and hypothesis. To really get a grasp of the meaning behind the Baseyian interpretation of probability, we should think about some hypothesis $H$ and some data $D$ we are interested in to check the validity of our hypothesis. In this view, Bayes' theorem is written as

$P(H|D) = \frac{P(D|H)P(H)}{P(D)}$

Put into words, what this means is 'the probability of my hypothesis or *belief*, given the data observed, is equal to the probability that the data would be obtained if the belief were to be true, multiplied by the probability of the hypothesis being true before seeing the data, divided by the probability of obtaining that data'. 
This may sound a bit confusing at first, but if you look closely for some time and think about each term, you will find it makes perfect sense.

* P(H): This is called **Prior probability**. As its name states, it represents the probability of a particular belief or hypothesis of being true *before* we have any new data to contrast this belief.

* P(D|H): Frequently called **Likelihood**. If we remember the definition of conditional probability, what this means is the probability of the data being observed if our hypothesis were true. Intuitively, if we collect some data that contradicts our beliefs, this probability should be low. Makes sense, right?

* P(D): This term has no particular name. It is a measure of all possible ways we could have obtained the data be have. In general it is considered a normalizing constant.

* P(H|D): The famous **Posterior probability**. Again, remembering the definition of conditional probability, it is clear this represents the probability of our hypothesis being true, given that we collected some data $D$. 

It is interesting to give a little more detail on the epistemological interpretation of this entire theorem. We start from some initial hypothesis and we assign some probability to it (the Prior). How exactly this has to be done is uncertain, in fact, there are ways to encode that you don't know nothing about the validity of the hypothesis. But the important part is that, if you already knew something about it, you can include that in your priors. For example, if you are trying to estimate some parameter that you know is positive definite, then you can use priors that are defined only for positive values. From that starting point, then, you have a methodical way to update your beliefs by collecting data, and with this data, give rise to the Posterior probability, which hopefully will be more accurate than our Prior probability. 
What is nice about the Bayesian framework is that we always account for the uncertainty of the world. We start with some probability and end with another probability, but uncertainty is always present. This is what real life is about.
To understand the full power of Bayesian probability we have to extend the notion of probability to *probability distributions*. We will discuss this topic in the following section.
"

# ╔═╡ 2d9482ce-1252-11eb-0cc7-35ad9c288ef8
md"
# Probability distributions
So far we have been talking of probabilities of particular events. **Probability distributions**, on the other hand, help us compute probabilities of various events. These are functions that connect each event in an 'event space' to some probability. What do we mean by 'event space'? For example, consider the distribution of heights of adult women, given approximately by a **Normal distribution**,
"

# ╔═╡ 351923ee-5436-11eb-2bf6-8d024a64e83e
md"
In this example, the event space is just all the possible heights a woman could have, in other words, the 'x' axis. The 'y' axis, in the other hand, represents the probability that, if we select a woman randomly, she will have a given height. For example, the probability that a randomly selected woman will be 60 inches tall is approximately $0.06$. Having a distribution, one can ask questions like 'what is the probability of a randomly selected woman being 60 inches or taller?'. This could be answered by summing the probabilities of all heights 60 and up.

Any mathematical function satisfying certain requirements can be a probability distribution. There are lots of these type of functions, and each one has its own shape and distinctive properties.

We will introduce some important probability distributions so that you can have a better understanding of what all this is about. Probably, the concept of the Normal distribution –also refered as the Gaussian– was already familiar to you, as it is one of the most popular and widely used distributions in some fields and in popular culture. The shape of this distribution is governed by two *parameters*, usually represented by the Greek letters $\mu$ and $\sigma$. Roughly speaking, $\mu$ is associated with the center of the distribution and $\sigma$ with how wide it is. 
"

# ╔═╡ 4a6f2768-543e-11eb-1846-f9e35aa961d2
md"
By replicating the code below in a Pluto notebook, you will be able to create sliders to play around with the values of μ and σ and see how the shape of the  Normal distribution changes.
"

# ╔═╡ 0ac3353a-543d-11eb-08fe-d35a4c0f0bbc
@bind μ html"<input type=range min=-1 max=1 step=0.1>"

# ╔═╡ ecec1854-543c-11eb-0d11-b342e4d246e1
@bind σ html"<input type=range min=0.1 max=5 step=0.5>"

# ╔═╡ 252c0524-543a-11eb-3ab1-156be15fcfa8
plot(Normal(μ,σ), xlabel="x", ylabel="P(x)", lw=4, color="purple", label=false, size=(450, 300), alpha=0.8, title="Normal distribution", xlim=(-10, 10))

# ╔═╡ 6db26aa0-543e-11eb-3258-27c7b15323fb
md" 
Every probability distribution that is defined by a mathematical function, has a set of parameters that defines the distribution's shape and behaviour, and changing them will influence the distribution in different ways, depending on the one we are working with. 

Another widely used distribution is the *exponential*. Below you can see how it looks like. It is governed by only one parameter, $\alpha$, which basically represents the rate of decrease in probability as $x$ gets bigger. 
"

# ╔═╡ 90c1b258-543e-11eb-3f8e-3f167fab2db0
md"
Again, a slider to change the value of the $α$ parameter of exponential distribution can be implemented if you replicate the code below. 
"

# ╔═╡ 820e10b2-543e-11eb-3866-3b9fabe04884
@bind α html"<input type=range min=0.2 max=3 step=0.1>"

# ╔═╡ 9eae0268-543e-11eb-27d0-c3a726d245d5
plot(Exponential(α), xlabel="x", ylabel="P(x)", lw=4, color="blue", label=false, size=(450, 300), alpha=0.8, title="Exponential distribution", xlim=(0, 10))

# ╔═╡ 49deb9d4-543f-11eb-2202-03ced64292a4
md"
As the book progresses, we will be using a lot of different distributions. They are an important building block in probability and statistics. In the next section, we will discuss a little bit about how probability arises from gathering data.
"

# ╔═╡ fbaac2e0-1252-11eb-1d8a-e7ba0193ea9b
md"
## Histograms
To illustrate some of these concepts we have been learning, we are going to use [monthly rainfall data](https://data.buenosaires.gob.ar/dataset/registro-precipitaciones-ciudad) from the city of Buenos Aires, Argentina, since 1991. The **histogram** of the data is shown below. You may be wondering what a histogram is. An histogram is a plot that tells us the counts or relative frequencies of a given set of events."

# ╔═╡ 748f8114-1483-11eb-15c0-879e4e1dec8c
md"We can see the first few rows of our data, with columns corresponding to the year, the month, the rain precipitation (in millimeters) and the number of days it rained in that month."

# ╔═╡ a1028154-1252-11eb-363b-1722388a481e
first(rain_data, 8)

# ╔═╡ be8cb9ee-1483-11eb-1637-f3770319f3ed
md"
Now plotting the histogram for the column of rainfall in mm we have the figure shown below. Plotting a histogram is very easy with the Plots.jl package. You just have to pass the array you want to make the histogram of and the number of bins. The other arguments are self-explanatory, and are just to make the plot nicer.
"

# ╔═╡ 14317216-1251-11eb-1912-ef5685acd473
begin
	histogram(rain_data["mm"], bins=20, legend=false, size=(450, 300))
	title!("Monthly rainfall in Buenos Aires")
	xlabel!("Rainfall (mm)")
	ylabel!("Frequency")
end

# ╔═╡ c770092e-12e6-11eb-0711-0196e27d573e
md"
Histograms can be interpreted as probability distributions. The reason behind this is because we have registered some total number $N$ of events that happened in some time interval (in this case, one month) and we grouped the number of times each one ocurred. In this line of reasoning, events that happened most are more likely to happen, and hence we can say they have a higher probability associated to them. Something important to consider about histograms when dealing with a continuous variable such as, in our case, milimeters of monthly rainfall, are *bins* and bin size. When working with such continuous variables, the domain in which our data expresses itself (in this case, from 0 mm to approximately 450 mm) is divided in discrete intervals. In this way, given a bin size of 20mm, when constructing our histogram we have to ask 'how many rainy days have given us a precipitation measurement between 100mm and 120mm?', and then we register that number in that bin. This process is repeated for all bins to obtain our histogram.
We have earlier said that probability has to be a number between 0 and 1, so how can it be that these relative frequencies are linked to probabilities? What we should do now is to *normalize* our histogram to have the frequency values constrained. Normalizing is just the action of adjusting the scale of variables, without changing the relative values of our data. Below we show the normalized histogram. You will notice that the frequency values are very low now. The reason for this is that when normalizing, we impose to our histogram data that the sum of the counts of all our events (or, thinking graphically, the total area of the histogram) must be 1. But why? As probability tell us how plausible is an event, if we take into account all the events, we expect that the probability of all those events to be the maximum value, and that value is set up to 1 by convention. In that way we can compare plausibilities across different events, therefore when we say that some event has a probability of 0.6 to occur, for any event it means the same, no matter if we are talking about the probability of raining or the probability of being hit by a car.
So, we normalize the histogram obtaining:"

# ╔═╡ 178f5f72-12e7-11eb-2282-c19f2b58ae58
begin
	histogram(rain_data["mm"], bins=20, legend=false, normalize=true, size=(450, 300))
	title!("Monthly rainfall in Buenos Aires")
	xlabel!("Rainfall [mm]")
	ylabel!("Frequency")
end

# ╔═╡ 6a45327a-1254-11eb-2334-07eb5a961b02
md"
There is a lot we can say about this plot. First, it is worth noting that a rainfall amount less than $0$mm is not possible, that's why we don't have any event in this region. On the other hand, we see that a monthly rainfall higher than $300$mm is a rare event, and a rainfall higher than $400$mm is even less 
likely to happen.

But why am I inferring how likely is an event to happen in the future with data from the past?

I'm making some assumptions that are often implied working with histograms and measured data: the first assumption is that the data is representative for the variable in consideration, meaning that the data of rainfall was measured well, that it isn't measured just during winter for example, when we know rainfall is most common. The other big assumption is that things in the future will not change much from things in the past, so if we do the measure again for some time in the near future, the shape of the histogram is going to be more or less the same. These assumptions may or may not hold in the real events, but this doesn't mean there is something wrong with our analysis or how we model our data. It's just that we chose some assumptions that seem reasonable with the information we have. And we always have to make some assumptions to obtain answers.
"

# ╔═╡ cc3a3236-1949-11eb-3021-3d5a81bfa6a6
md"
So far we have been talking about histograms as probability distributions. Distributions such as these, that are built from the outcome of an experiment are called *empirical* distributions. This means that they arise from direct measurements, not from an underlying analytical function. When dealing with most real-world examples, histograms will represent distributions we will obtain for our updated beliefs, so they are a really important concept for what will come in the book.
"

# ╔═╡ d1aade6e-550d-11eb-1eea-7751ef152b7a
md"
All the concepts we developed about probability distributions, are directly applied to our Bayesian formalism. The prior, likelihood and posterior probabilities are really *probability distributions*, and that is really how we treat Bayes' theorem mathematically and computationally.
"

# ╔═╡ 3b8ea6fc-54f1-11eb-0a00-3f465d1f2d22
md"
### Example: Bayesian Bandits
Now we are going to tackle a famous problem that may help us to understand a little bit how to incorporate what we learned about Bayesian probability and some features of the Julia language. Here we present the **bandit** or **multi-armed bandit** problem. Altough it is conceived thinking about a strategy for a casino situation, there exist a lot of different settings where the same strategy could be applied.

The situation, in it's simpler form, goes like this: you are in a casino, with a limited amount of casino chips. In front of you there are some slot machines (say, three of them for simplicity). Each machine has some probability *$p_m$* of giving you \$1 associated with it, but every machine has a different probability. There are two main problems. First, we don't know these probabilities beforehand, so we will have to develop some explorative process in order to gather information about the machines. The second problem is that our chips –and thus our possible trials– are limited, and we want to take the most profit we can out of the machines. How do we do this? Finding the machine with the highest success probability and keep playing on it. This tradeoff is commonly known as *explore vs. exploit*. If we had one million chips we could simply play a lot of times in each machine and thus make a good estimate about their probabilities, but our reward may not be very good, because we would have played so many chips in machines that were not our best option. Conversely, we may have found a machine which we know that has a good success probability, but if we don't explore the other machines also, we won't know if it is the best of our options.
"

# ╔═╡ 86a1ea8c-54f1-11eb-194c-c93861393ab6
md"
This is a kind of problem that is very suited for the Bayesian way of thinking. We start with some information about the slot machines (in the worst case, we know nothing), and we will update our beliefs with the results of our trials. A methodology exists for these explore vs. exploit dilemmas, within many others, which is called **Thompson sampling**. The algorithm underlying the Thomposon sampling can be thought in these succesive steps:

1) First, assign some probability distribution for your knowledge of the success probability of each slot machine.
2) Sample randomly from each of these distributions and check which is the maximum sampled probability. 
3) Pull the arm of the machine corresponding to that maximum value.
4) Update the probability with the result of the experiment.
5) Repeat from step 2.

Here we will take some advantage about the math that can be used to model our situation. To model the generation of our data, we can use a distribution we have not  yet introduced, the *Binomial* distribution. This distribution arises when you repeat some experiment that has two possible outcomes, a number N of times. In each individual experiment, the outcomes have some probability $p$ and $1-p$ of happening (because there are only two). Let's see what this Binomial distribution looks like,
"

# ╔═╡ 105bebae-550d-11eb-197c-7d87fd8b1ffa
@bind p html"<input type=range min=0.01 max=0.99 step=0.01>"

# ╔═╡ 2ac93ef6-550d-11eb-1d4f-2194a8ddf8db
@bind N html"<input type=range min=1 max=500 step=1>"

# ╔═╡ 99ebac2a-550c-11eb-3645-4370e649df05
scatter(Binomial(N, p), xlim=300, label=false, title="Binomial distribution", size=(500, 350), xlabel="Number of succeses")

# ╔═╡ 8ae2936a-550c-11eb-291c-2955116ad4c5
md"
We choose this distribution as it models properly our situation, with $p$ being the probability we estimate of succeeding  with a particular machine, and $N$ the number of trials we make on the machine. The two possible outcomes are success (we win \$1) or fail (we don't win anything)

So we now use a prior tu set our knowledge before making a trial on the slot machine. The thing is, there exists a mathematical hack called *conjugate priors*. When a likelihood distribution is multiplied by its conjugate prior, the posterior distribution is the same as the prior with its corresponding parameters updated. This trick frees us from the need of using more computation-expensive techniques, that we will be using later in the book.
In the particular case of the Binomial distribution, the conjugate prior is the *Beta distribution*. This is a very flexible distribution, as we can obtain a lot of other distributions as particular cases of the Beta, with specific combinations of its parameters. Below you can see some of the fancy shapes this Beta distribution can obtain
"

# ╔═╡ 926a7e38-54f1-11eb-327d-9999beac2716
begin
	plot(Beta(1, 1), ylim=(0, 5), size=(400, 300), label=false, xlabel="x", ylabel="P(x)", title="Beta distribution shapes")
	plot!(Beta(0.5, 0.5), label=false)
	plot!(Beta(5, 5), label=false)
	plot!(Beta(10, 3), label=false)
	plot!(Beta(3, 10), label=false)
end

# ╔═╡ e4192172-550e-11eb-10ac-136508e689a3
md"
To start formalizing our problem a bit, we are going to start building our bandits. This is just a way to name our slot machines and some information associated with them. How will we do this? With the help of Julia's *struct*. These are objects we can create in Julia and that can be used to store information that has meaning as an entire block. In our case, some relevant information would be to store the probability of each slot machine, and the number of trials. It is more comfortable to carry all this information in one big block, as we later can start creating as many bandits we want, and it would be impossible to keep track of all the parameters.
Above we define a struct of a *beta bandit*, which will store the real probability of success of the bandit, the parameters $a$ and $b$ of the Beta distribution, and the total number of tries $N$ of the bandit. This would correspond to the first step in the Thompson sampling algorithm.
"

# ╔═╡ 99d86504-54f1-11eb-1091-63f3c1227714
begin
	mutable struct beta_bandit
		# the real success probability of the bandit
		p::Float64
		# a parameter from the beta distribution (successes)
		a::Int64
		# b parameter from the beta distribution (fails)
		b::Int64
		# total number of trials of bandit
		N::Int64
		# initialization of the Beta distribution with parameters a=1, b=1 (uniform distribution)
		beta_bandit(p=p, a=1, b=1, N=0) = new(p, a, b, N)
	end
end

# ╔═╡ f52d8be6-5519-11eb-3485-5969de539e2f
md"
Given that we have constructed our bandit and assigned a probability distribution to it, we define the function to sample from the distribution, as we will be needing it for the second step of the Thompson sampling algorithm.
"

# ╔═╡ a63a6824-54f1-11eb-21f7-93291f0669c3
sample_bandit(bandit::beta_bandit) = rand(Beta(bandit.a, bandit.b))

# ╔═╡ 55dfa6e8-551c-11eb-25e6-e30a5610c866
md"
Now we need some function to pull an arm of the slot machine and actually test if we get a success or not. This will help us in the second step of the algorithm.
"

# ╔═╡ 6583cf5c-551c-11eb-0b06-d766337f0b94
pull_arm(bandit::beta_bandit) = bandit.p > rand()

# ╔═╡ 4910dcda-551b-11eb-12bc-d5d56465989b
md"
Finally, we define another function to update the bandit information, based on the result of pulling an arm. This corresponds to the forth step in the Thompson sampling algorithm.
"

# ╔═╡ aef28744-54f1-11eb-033a-138128439906
function update_bandit(bandit::beta_bandit, outcome::Bool)
    if outcome
        bandit.a += 1
    else
        bandit.b += 1
    end
    bandit.N += 1
end

# ╔═╡ 1d2fded6-551d-11eb-3680-9d0faf78dc6f
md"
With all these functions defined, we are ready to make an experiment and actually see how our strategy works. We will define beforehand a number of trials and the true probabilities of the slot machines. When the experiment is over, we will see how well were the probabilities of each machine were estimated, and the reward we accumulated. If you come up with some other novel strategy, you can test it doing a similar experiment and see how well the probabilities were estimated and the final reward you got. First, we define the total number of trials we are going to make, and then the *true* probabilities of each slot machine. Ath the end, we'll see how well these probabilities were estimated, or, in other words, how well the Thompson sampling helped in the process of gathering information abiyt the bandits.
"

# ╔═╡ b5174e84-54f1-11eb-1fbb-afb237e1fdf2
N_TRIALS = 100

# ╔═╡ ba0851e0-54f1-11eb-2b22-1512dfc999f3
BANDIT_PROBABILITIES = [0.3, 0.5, 0.75]

# ╔═╡ c419fcce-54f1-11eb-02e9-8bad4e023977
function beta_bandit_experiment(band_probs, trials)
	bandits = [beta_bandit(p) for p in band_probs]
	reward = 0
	for i in 1:trials
#		_, mxidx = findmax([rand(Beta(bandit.a, bandit.b)) for bandit in bandits])
		_, mxidx = findmax([sample_bandit(bandit) for bandit in bandits])
		best_bandit = bandits[mxidx]
		exp = pull_arm(best_bandit)
		
		if exp
			reward += 1
		end
		
		update_bandit(best_bandit, exp)
	end
	
	plot()
	for i in 1:length(bandits)
		display(plot!(Beta(bandits[i].a, bandits[i].b), xlim=(0, 1), lw=2, 							xlabel="Success probability of bandit", ylabel="Probability density"))
	end
	
	return reward, current()
end

# ╔═╡ c822a558-54f1-11eb-162b-398bd542ded1
rew, bandit_plot = beta_bandit_experiment(BANDIT_PROBABILITIES, N_TRIALS);

# ╔═╡ e3b582b0-54f1-11eb-3ffa-67a92240e659
bandit_plot

# ╔═╡ 0d541d38-59a5-11eb-3404-f13d3e5150d4
md"
Considering that we have only tried 100 times, the probabilities have been estimated pretty well! Each distribution assigns a high-enough probability to the true value of the bandit probabilities and it's surroundings. Another strategies rather than the Thompson sampling can be tested to see how well they perform, this was just a simple example to apply Bayesian probability.
"

# ╔═╡ 32df0e98-35a2-11eb-1121-5f731785abbb
md"
### References
* [Bayesian Statistics the fun way](https://www.amazon.com/Bayesian-Statistics-Fun-Will-Kurt/dp/1593279566)
* [ThinkBayes](https://www.amazon.com/Think-Bayes-Bayesian-Statistics-Python/dp/1449370780)
* [ThinkStats](https://www.amazon.com/Think-Stats-Exploratory-Data-Analysis/dp/1491907339)
* [Mixture Distribution](https://www.johndcook.com/blog/mixture_distribution/)
* [A contextual bandit bake-off](https://arxiv.org/pdf/1802.04064.pdf)
* [Bandit Algs page](https://banditalgs.com/)
"

# ╔═╡ Cell order:
# ╟─84b10156-5116-11eb-1a6d-13f625300801
# ╠═2d9482ce-1252-11eb-0cc7-35ad9c288ef8
# ╠═e6ecfce4-54e5-11eb-2ff6-3bb479c286af
# ╠═8b06866e-5424-11eb-3cb6-f9afabefcd70
# ╠═351923ee-5436-11eb-2bf6-8d024a64e83e
# ╟─4a6f2768-543e-11eb-1846-f9e35aa961d2
# ╠═0ac3353a-543d-11eb-08fe-d35a4c0f0bbc
# ╠═ecec1854-543c-11eb-0d11-b342e4d246e1
# ╠═252c0524-543a-11eb-3ab1-156be15fcfa8
# ╟─6db26aa0-543e-11eb-3258-27c7b15323fb
# ╟─90c1b258-543e-11eb-3f8e-3f167fab2db0
# ╠═820e10b2-543e-11eb-3866-3b9fabe04884
# ╠═9eae0268-543e-11eb-27d0-c3a726d245d5
# ╟─49deb9d4-543f-11eb-2202-03ced64292a4
# ╟─fbaac2e0-1252-11eb-1d8a-e7ba0193ea9b
# ╠═e45d76d4-1250-11eb-14d7-c30fcb5a5b72
# ╟─748f8114-1483-11eb-15c0-879e4e1dec8c
# ╟─a1028154-1252-11eb-363b-1722388a481e
# ╟─be8cb9ee-1483-11eb-1637-f3770319f3ed
# ╠═14317216-1251-11eb-1912-ef5685acd473
# ╟─c770092e-12e6-11eb-0711-0196e27d573e
# ╟─178f5f72-12e7-11eb-2282-c19f2b58ae58
# ╟─6a45327a-1254-11eb-2334-07eb5a961b02
# ╟─cc3a3236-1949-11eb-3021-3d5a81bfa6a6
# ╟─d1aade6e-550d-11eb-1eea-7751ef152b7a
# ╟─3b8ea6fc-54f1-11eb-0a00-3f465d1f2d22
# ╟─86a1ea8c-54f1-11eb-194c-c93861393ab6
# ╠═105bebae-550d-11eb-197c-7d87fd8b1ffa
# ╠═2ac93ef6-550d-11eb-1d4f-2194a8ddf8db
# ╠═99ebac2a-550c-11eb-3645-4370e649df05
# ╟─8ae2936a-550c-11eb-291c-2955116ad4c5
# ╟─926a7e38-54f1-11eb-327d-9999beac2716
# ╟─e4192172-550e-11eb-10ac-136508e689a3
# ╠═99d86504-54f1-11eb-1091-63f3c1227714
# ╟─f52d8be6-5519-11eb-3485-5969de539e2f
# ╠═a63a6824-54f1-11eb-21f7-93291f0669c3
# ╟─55dfa6e8-551c-11eb-25e6-e30a5610c866
# ╠═6583cf5c-551c-11eb-0b06-d766337f0b94
# ╟─4910dcda-551b-11eb-12bc-d5d56465989b
# ╟─aef28744-54f1-11eb-033a-138128439906
# ╟─1d2fded6-551d-11eb-3680-9d0faf78dc6f
# ╠═b5174e84-54f1-11eb-1fbb-afb237e1fdf2
# ╠═ba0851e0-54f1-11eb-2b22-1512dfc999f3
# ╠═c419fcce-54f1-11eb-02e9-8bad4e023977
# ╠═c822a558-54f1-11eb-162b-398bd542ded1
# ╠═e3b582b0-54f1-11eb-3ffa-67a92240e659
# ╟─0d541d38-59a5-11eb-3404-f13d3e5150d4
# ╟─32df0e98-35a2-11eb-1121-5f731785abbb
