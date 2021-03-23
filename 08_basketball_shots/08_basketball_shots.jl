### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ fa821e30-2293-11eb-3ba4-e3a7ca987312
begin
	using Random
	Random.seed!(1234)
end;

# ╔═╡ e3bc0914-204e-11eb-3677-aba2e235ef3b
begin
	using CSV
	using DataFrames
	using StatsPlots
	
	season_2007 = CSV.read("./data/seasons/shots_season_2006_2007.csv", DataFrame)

	#shots = vcat(season_2007, season_2008, season_2009);
	shots = season_2007

	shots[!, :distance] = sqrt.( shots.x .^ 2 +  shots.y .^ 2)
	shots[!, :angle] = atan.( shots.y ./ shots.x )
	filter!(x-> x.distance>1, shots)
end;

# ╔═╡ edeabd04-204e-11eb-1c63-118f10ca070a
begin
	using Images
	img = load("./images/basket_court.png")
end

# ╔═╡ 66aee544-2072-11eb-2a78-37d0f33e66e6
begin
	using Turing
	using StatsFuns: logistic
end

# ╔═╡ 79145330-8bdf-11eb-1153-a7a081365531
md"### To do list
 
We are currently working on:
 
";


# ╔═╡ b4257f94-204e-11eb-258e-0524565c4d41
md"# Basketball: how likely is it to score? "

# ╔═╡ cc25e57c-204e-11eb-23a6-7d5a88113776
md" When playing basketball we can ask ourself: how likely is it to score given a position in the court? To answer this question we are going to use data from NBA games from the season 2006 - 2007. We will consider all types of shots. "

# ╔═╡ 8e40725c-235c-11eb-1401-0f6312dbc5ad
first(shots)

# ╔═╡ e915d9bc-204e-11eb-0f8c-d52fc2084322
md"
But how do we interpret the data?

Below we show a sketch of a basketball court, its dimensions and how to interpret the data in the table."

# ╔═╡ f2c2b5b6-204e-11eb-2fec-21e285391c03
md"
So, the *x* and *y* axis have their origin at the hoop, and we compute the distance from this point to where the shot was made.
Also, we compute the angle with respect to the *x* axis, showed as θ in the sketch. 
In the data we have the period, which can take values from 1 to 4, meaning the period in which the shot was made.
"

# ╔═╡ f7e32184-204e-11eb-2e22-efc3d9821674
md"We now plot where the shots where made:"

# ╔═╡ f1b51206-2056-11eb-2ef9-7de142b32797
begin
	histogram2d(shots.y[1:10000], shots.x[1:10000], bins=(50,30))
	ylabel!("y axis")
	xlabel!("x axis")
end

# ╔═╡ 326336c4-2058-11eb-23bd-e5cc758bc9c2
md"We see that the shots are very uniformly distributed near the hoop, except for distances very near to the hoop, to see this better, we plot the histograms for each axis, *x* and *y*. "

# ╔═╡ 41395aac-205d-11eb-29e2-77b28ded5aef
md"But we are interested in the shots that were scored, so we filter now the shots made and plot the histogram of each axis."

# ╔═╡ 04c41c34-2066-11eb-16d8-d7a662b362fe
shots_made = filter(x->x.result==1, shots);

# ╔═╡ 0638a720-2065-11eb-3d6f-99ce0f308867
begin
	using StatsBase
	h = fit(Histogram, (shots_made.y, shots_made.x), nbins=40)
	#plot(h) # same as histogram2d
	wireframe(midpoints(h.edges[2]), midpoints(h.edges[1]), h.weights, zlabel="counts", xlabel="y", ylabel="x", camera=(40,40))
title!("Histogram of shots scored")
end

# ╔═╡ e0524328-2063-11eb-1f81-5535a281701f
begin
	histogram(shots_made.y[1:10000], legend=false, nbins=40)
	xlabel!("x axis")
	ylabel!("Counts")
end

# ╔═╡ 475af57e-2064-11eb-0aa8-e3e07cf6b7c9
begin
	histogram(shots_made.x[1:10000], legend=false, nbins=45)
	xlabel!("y axis")
	ylabel!("Counts")
end

# ╔═╡ 8190de9e-2068-11eb-03b2-25f3b9183dbe
md"If we plot a 3d plot of the count we obtain the plot wireplot shown below." 

# ╔═╡ 121240e2-2394-11eb-3865-fd2d94281d57
md" We see that more shot are made as we get near the hoop, as expected.

It is important to notice that we are not showing the probability of scoring, we are just showing the distribution of shot scored, not how likely is it to score."

# ╔═╡ 8dd89dca-2394-11eb-2d34-2d584b8e8fbd
md"### Modeling the probability of scoring"

# ╔═╡ 3d1794bc-2066-11eb-0ab3-7320911a9964
md" The first model we are going to propose is a *Bernoulli* model.

*Why a Bernoulli Distribution?*

A Bernoulli Distribution results from an experiment in which we have 2 possible outcomes, one that we usually called a *success* and another called a *fail*. In our case our *success* is scoring the shot and the other possible event is failing it.

The only parameter needed in a bernoulli distribution is the probability *p* of having a success. We are going to model this parameter as a logistic function:
" 

# ╔═╡ 3d9b284e-2073-11eb-0b69-e7bcb7241843
begin
plot(logistic, legend=false)
ylabel!("Probability")
xlabel!("x")
title!("Logistic function (x)")
end

# ╔═╡ bb2a837a-2073-11eb-0109-e76c0f370cea
md"*Why a logistic function?*

We are going to model the probability of shoot as a function of some variables, for example the distance to the hoop, and we want that our probability of scoring increases as we are getting closer to it. Also out probability needs to be between 0 an 1, so a nice function to map our values is the logistic function.
"

# ╔═╡ 29426866-2075-11eb-114a-674a286cc586
md" So, the model we are going to propose is: 

$p\sim logistic(a+ b*distance[i] + c*angle[i])$
$outcome[i]\sim Bernoulli(p)$
"

# ╔═╡ 901ad6f8-2075-11eb-13fc-f3d501387757
md"*But what values and prior distributions are we going to propose to the parameters a, b and c?*

Let's see:
"

# ╔═╡ c312e2a4-2075-11eb-2faf-d55d61c9d39c
md"## Prior Predictive Checks: Part I"

# ╔═╡ d4ce7370-2075-11eb-220d-136d89b3daa9
md"Suppose we say that our prior distributions for *a*, *b* and *c* are going to be 3 gaussian distributions with mean 0 and variance 1. Lets sample and see what are the possible posterior distributions for our probability of scoring *p*:

$a\sim N(0,1)$
$b\sim N(0,1)$
$c\sim N(0,1)$
"

# ╔═╡ 5c0afe60-2299-11eb-2985-399ae5501578
begin
possible_distances = 0:0.01:1
possible_angles = 0:0.01:π/2
angle = π/2
n_samples = 100
a_prior_sampling = rand(Normal(0,1), n_samples)
b_prior_sampling = rand(Normal(0,1), n_samples)
predicted_p = []
for i in 1:n_samples
		push!(predicted_p, logistic.(a_prior_sampling[i] .+ b_prior_sampling[i].*possible_distances))
end
	end

# ╔═╡ 35970552-229a-11eb-1786-7d5ae736a89d
begin
	plot(possible_distances, predicted_p[1], legend = false, color="blue")
	for i in 2:n_samples
		plot!(possible_distances, predicted_p[i], color=:blue)
	end
	xlabel!("Normalized distance")
	ylabel!("Predicted probability")
	title!("Prior predictive values for p")
	current()
end

# ╔═╡ c9bc18da-229a-11eb-266b-69c6be868c1e
md"We see that some of the predicted behaviours for *p* don't make sense. For example, if *b* takes positive values, we are saying that as we increase our distance from the hoop, the probability of scoring also increase. So we propose instead the parameter *b* to be the negative values of a LogNormal distribution. The predicted values for *p* are shown below."

# ╔═╡ 71ff112e-229f-11eb-3c78-b9e8a77b0b65
md" So our model now have as priors distributions:

$a\sim Normal(0,1)$
$b\sim LogNormal(1,0.25)$
$c\sim Normal(0,1)$
"

# ╔═╡ b99b3b7a-229f-11eb-238f-73ea6d44f206
md"and sampling values from those prior distributions, we obtain the plot shown below for the predicted values of *p*."

# ╔═╡ f207b090-229c-11eb-3567-d5bd1c42d9b4
begin
b_prior_sampling_negative = rand(LogNormal(1,0.25), n_samples)
predicted_p_inproved = []
for i in 1:n_samples
		push!(predicted_p_inproved, logistic.(a_prior_sampling[i] .- b_prior_sampling_negative[i].*possible_distances))
end
	end

# ╔═╡ 36ced550-229d-11eb-1dbd-df184e970a68
begin
	plot(possible_distances, predicted_p_inproved[1], legend = false, color=:blue)
	for i in 2:n_samples
		plot!(possible_distances, predicted_p_inproved[i], color=:blue)
	end
	xlabel!("Normalized distance")
	ylabel!("Predicted probability")
	title!("Prior predictive values for p with negative LogNormal prior")
	current()
end

# ╔═╡ 5b229308-22a0-11eb-1805-d7b1fbd63e5c
md"Now that we have the expected behaviour for *p*, we define our model and calculate the posterior distributions with our data points."

# ╔═╡ 9823f6a4-22b2-11eb-0c36-a9bfc81e09e0
md"### Defining our model and computing posteriors"

# ╔═╡ ad764842-2076-11eb-2aad-778de3b5c484
md"Now we define our model to sample from it:"

# ╔═╡ 9cf51b04-228f-11eb-0de9-1d79c084d9db
@model logistic_regression(distances, angles, result,n) = begin
  N = length(distances)
  # Set priors.
	a ~ Normal(0,1) 
	b ~ LogNormal(1,0.25)
	c ~ Normal(0,1)
 	for i in 1:n
		p = logistic( a -  b*distances[i] + c*angles[i])
        result[i] ~ Bernoulli(p)
	end
end

# ╔═╡ 44276f54-2299-11eb-2dd1-f96d8a232987
n=1000;

# ╔═╡ c971fae4-2396-11eb-1070-e7fa7f4f6cc4
md"The output of the sampling  tell us also some information about sampled values for our parameters, like the mean, the standard deviation and some other computations."

# ╔═╡ 4bfeeb80-2299-11eb-1c8c-55b953664f5a
# Sample using HMC.
chain = mapreduce(c -> sample(logistic_regression(shots.distance[1:n] ./ maximum(shots.distance[1:n] ), shots.angle[1:n], shots.result[1:n], n), NUTS(), 1500),
    chainscat,
    1:3
);


# ╔═╡ 1dba6ec6-2371-11eb-0ebf-c94f7620bab7
md"#### Traceplot

In the plot below we show a *traceplot* of the sampling. 

*What is a traceplot?* 

When we run a model and calculate the posterior, we obtain sampled values from the posterior distributions. We can tell our sampler how many sampled values we want. A traceplot is just showing them in sequential order. We also can plot the distribution of those values, and this is what is showed next to each traceplot.
"

# ╔═╡ 240d2902-2069-11eb-0a57-878337b4c980
plot(chain, dpi=60)

# ╔═╡ 8bd6e516-22a1-11eb-0082-95cf09350dbd
begin
	a_mean = mean(chain[:a])
	b_mean = mean(chain[:b])
	c_mean = mean(chain[:c])
end;

# ╔═╡ 7ee40f42-22a5-11eb-2fc0-f579fe0917be
md"Now plotting the probability of scoring using the posterior distributions of *a*, *b* and *c* for an angle of 45°, we obtain:"

# ╔═╡ d4143c48-22a1-11eb-00f3-afc11310b56b
begin
p_constant_angle = []
	for i in 1:length(chain[:a])
		push!(p_constant_angle, logistic.(chain[:a][i] .- chain[:b][i].*possible_distances .+ chain[:c][i].*π/4));
		end
	end

# ╔═╡ d9720614-22ad-11eb-1dde-1f243605ee34
begin
plot(possible_distances,p_constant_angle[1], legend=false, alpha=0.1, color=:blue)
	for i in 2:1000
		plot!(possible_distances,p_constant_angle[i], alpha=0.1, color=:blue)
	end
	xlabel!("Normalized distance")
	ylabel!("Probability")
	title!("Scoring probability vs Normalized distance (angle=45°)")
	current()
end

# ╔═╡ ad665eb4-22b0-11eb-022a-ffd6a969392e
md"The plot shows that the probability of scoring is higher as our distance to the hoop decrease, which makes sense, since the difficulty of scoring increase.

We plot now how the probability varies with the angle for a given distance. Here we plot for a mid distance, corresponding to 0.5 in a normalized distance."

# ╔═╡ 18a2518e-22b0-11eb-1a12-edb99072a6c5
begin
p_constant_distance = []
	for i in 1:length(chain[:a])
		push!(p_constant_distance, logistic.(chain[:a][i] .- chain[:b][i].*0.5 .+ chain[:c][i].*possible_angles));
		end
	end

# ╔═╡ 333b9190-22b0-11eb-2ac5-b1ec28e7d258
begin
plot(rad2deg.(possible_angles),p_constant_distance[1], legend=false, alpha=0.1, color=:blue)
	for i in 2:1000
		plot!(rad2deg.(possible_angles),p_constant_distance[i], alpha=0.1, color=:blue)
	end
	xlabel!("Angle [deg]")
	ylabel!("Probability")
	title!("Scoring probability vs Angle (mid distance)")
	current()
end

# ╔═╡ f2a57c44-22ae-11eb-3f24-bda8faec4762
md"We see that the model predict an almost constant probability for the angle. "

# ╔═╡ 7adfd7ca-22b2-11eb-1334-5985564fd195
md"## New model and prior predictive checks: Part II"

# ╔═╡ b24672a0-22b2-11eb-35e3-97f9ef153243
md"Now we propose another model with the form: 

$p\sim logistic(a+ b^{distance[i]} + c*angle[i])$

*But for what values of b the model makes sense?

We show below the plot for 4 function with 4 possible values of *b*, having in mind that the values of *x*, the normalized distance, goes from 0 to 1. 
"

# ╔═╡ 39cc64c2-22b4-11eb-0ac8-918f817537d2
begin
	f1(x) = 0.3^x
	f2(x) = 1.5^x
	f3(x) = -0.3^x
	f4(x) = -1.5^x
end;

# ╔═╡ 90fbe58e-22b3-11eb-376f-7b525f5ac609
begin
	plot(0:0.01:1, f1, label="f1: b<1 & b>0", xlim=(0,1), ylim=(-2,2), lw=3)
	plot!(0:0.01:1, f2, label="f2: b>1", lw=3)
	plot!(0:0.01:1, f3, label="f3: b<0 & b>-1", lw=3)
	plot!(0:0.01:1, f4, label="f3: b<-1", lw=3)
	xlabel!("Normalized distance")
	title!("Prior Predictive influence of distance")
end
	

# ╔═╡ 5fb5edb0-22b5-11eb-0ff4-291bf910d4ca
md"Analysing the possible values for *b*, the one that makes sense is the value proposed in f1, since we want an increasing influence of the distance in the values of *p* as the distance decreases, since the logistic function has higher values for higher values of x."

# ╔═╡ a4daf2aa-2427-11eb-3fbc-89ba6b2f14ec
md"So now that we know the values the our parameter *b* can take, we propose for it a beta distribution with parameters α=2 and β=5, showed in the plot below."

# ╔═╡ 597bc46e-22b6-11eb-0a13-cfac61e8f7b0
begin
plot(Beta(2,5), xlim=(-0.1,1), legend=false)
title!("Prior distribution for b")
end

# ╔═╡ 1378ab6e-22bb-11eb-22fa-a9aeb36344f9
md"### Defining the new model and computing posteriors"

# ╔═╡ 3091f30c-2428-11eb-1489-edcc26610813
md"We define then our model and calculate the posterior as before."

# ╔═╡ 3b9e03bc-22b6-11eb-2ae5-23eefb618fc7
@model logistic_regression_exp(distances, angles, result, n) = begin
  N = length(distances)
  # Set priors.
	a ~ Normal(0,1) 
	b ~ Beta(2,5)
	c ~ Normal(0,1)
 	for i in 1:n
		p = logistic( a +  b .^ distances[i] + c*angles[i])
        result[i] ~ Bernoulli(p)
	end
end

# ╔═╡ db4c533a-22b6-11eb-2afa-47c5379ff7a3
# Sample using HMC.
chain_exp = mapreduce(c -> sample(logistic_regression_exp(shots.distance[1:n] ./ maximum(shots.distance[1:n] ), shots.angle[1:n], shots.result[1:n], n), HMC(0.05, 10), 1500),
    chainscat,
    1:3
);


# ╔═╡ 8bec6010-2429-11eb-30a1-29cee0e4df0f
md"Plotting the traceplot we see again that the variable angle has little importance since the parameter *c*, that can be related to the importance of the *angle* variable for the probability of scoring, is centered at 0."

# ╔═╡ 21cb52b8-22b7-11eb-221e-4d614103652d
plot(chain_exp, dpi=55)

# ╔═╡ 307dbd5a-22b7-11eb-3ed6-9bb6fe3066e3
begin
p_exp_constant_angle = []
	for i in 1:length(chain_exp[:a])
		push!(p_exp_constant_angle, logistic.(chain_exp[:a][i] .+ chain_exp[:b][i].^possible_distances .+ chain_exp[:c][i].*π/4));
		end
	end

# ╔═╡ 72762930-242a-11eb-3526-2da82f4f9af0
md"Employing the posteriors distributions computed, we plot the probability of scoring as function of the normalized distance and obtain the plot shown below."

# ╔═╡ 5f7eaac4-22b7-11eb-00d5-9b9dd02d9d94
begin
plot(possible_distances,p_exp_constant_angle[1], legend=false, alpha=0.1, color=:blue)
	for i in 2:1000
		plot!(possible_distances,p_exp_constant_angle[i], alpha=0.1, color=:blue)
	end
	xlabel!("Normalized distance")
	ylabel!("Probability")
	title!("Scoring probability vs Normalized distance (angle=45°)")
	current()
end

# ╔═╡ 0ba9956a-242b-11eb-12b3-8d84d80d0634
md"Given that we have 2 variables, we can plot the mean probability of scoring as function of the two and obtain a surface plot. We show this below."

# ╔═╡ a7e7e342-22b8-11eb-0ae2-211dc1ec64d8
begin 
	angle_ = collect(range(0, stop=π/2, length=100))
	dist_ = collect(range(0, stop=1, length=100))
	it = Iterators.product(angle_, dist_)
	matrix = collect.(it)
	values = reshape(matrix, (10000, 1))
	angle_grid = getindex.(values,[1]);
	dist_grid = getindex.(values,[2]);
	z = logistic.(mean(chain_exp[:a]) .+ mean(chain_exp[:b]).^dist_grid .+ mean(chain_exp[:c]).*angle_grid);
end;

# ╔═╡ 04457280-22b9-11eb-27bf-07b8a704f5b5
im3 =  load("./images/img1.png")

#begin
#plotly()
#plot(dist_grid, rad2deg.(angle_grid), z, color=:blue, zlabel="Probability", legend=false, camera=(10,0))	
#xlabel!("Normalized distance")
#ylabel!("Angle [deg]")

#title!("Mean Probability of scoring from posterior sampled values")
#end


# ╔═╡ 998c9058-242b-11eb-1668-51cdca9a8449
md"The plot show the behaviour expected, an increasing probability of scoring as we get near the hoop. We also see that there is almost no variation of the probability with the angle."

# ╔═╡ 5badb748-22bf-11eb-32bd-11992bb6c4ed
md"## Does the Period affect the probability of scoring?"

# ╔═╡ dc97ac06-22bf-11eb-23e7-81c6aff82de2
md"Now we will try to answer this question. We propose then a model, and calculate the posterior for its parameters with data of one of each of the four possible periods. We define the same model for all four periods. Also, we don't take into account now the angle variable, since we have seen before that this variable is of little importance.

We filter then our data by its period and proceed to estimate our posterior distributions."

# ╔═╡ 6a6c10ec-235d-11eb-3177-4118c883e56a
shots_period1= filter(x->x.period==1, shots);

# ╔═╡ e89ee0ea-236f-11eb-0b37-b3ab0cfae682
@model logistic_regression_period(distances, result,n) = begin
  N = length(distances)
  # Set priors.
	a ~ Normal(0,1) 
	b ~ Beta(2,5)
 	for i in 1:n
		p = logistic( a +  b .^ distances[i])
        result[i] ~ Bernoulli(p)
			end
end

# ╔═╡ 95897106-2368-11eb-167e-75f75d28fe45
n_ = 500

# ╔═╡ 4a887f0e-235d-11eb-131f-0d90540bd708
# Sample using HMC.
chain_period1 = mapreduce(c -> sample(logistic_regression_period(shots_period1.distance[1:n_] ./ maximum(shots_period1.distance[1:n_] ),shots_period1.result[1:n_], n_), HMC(0.05, 10), 1500),
    chainscat,
    1:3
);

# ╔═╡ 623fa138-2365-11eb-1470-d7739f7d80e8
shots_period2= filter(x->x.period==2, shots);

# ╔═╡ 5cbe6528-2365-11eb-282d-23b1322b782c
# Sample using HMC.
chain_period2 = mapreduce(c -> sample(logistic_regression_period(shots_period2.distance[1:n_] ./ maximum(shots_period2.distance[1:n_] ), shots_period2.result[1:n_], n_), HMC(0.05, 10), 1500),
    chainscat,
    1:3
);

# ╔═╡ 6d63e6dc-2365-11eb-2a64-c9ab02d45d8d
shots_period3= filter(x->x.period==3, shots);

# ╔═╡ 95f42abc-2365-11eb-28b4-ad5dfa234a3a
# Sample using HMC.
chain_period3 = mapreduce(c -> sample(logistic_regression_period(shots_period3.distance[1:n_] ./ maximum(shots_period3.distance[1:n_] ), shots_period3.result[1:n_], n_), HMC(0.05, 10), 1500),
    chainscat,
    1:3
);

# ╔═╡ a37d3d9a-2365-11eb-26a4-8f37750427bb
shots_period4 = filter(x->x.period==4, shots);

# ╔═╡ 768611a8-2366-11eb-0073-0bb804405f74
# Sample using HMC.
chain_period4 = mapreduce(c -> sample(logistic_regression_period(shots_period4.distance[1:n_] ./ maximum(shots_period4.distance[1:n_]), shots_period4.result[1:n_], n_), HMC(0.05, 10), 1500),
    chainscat,
    1:3
);

# ╔═╡ 6b5ca676-2360-11eb-3cf7-33602907075c
begin
p_period1 = logistic.(mean(chain_period1[:a]) .+ mean(chain_period1[:b]).^possible_distances )
p_period1_std = logistic.((mean(chain_period1[:a]).+std(chain_period1[:a])) .+ (mean(chain_period1[:b]).+std(chain_period1[:a])).^possible_distances)
p_period2 = logistic.(mean(chain_period2[:a]) .+ mean(chain_period2[:b]).^possible_distances )
p_period2_std = logistic.((mean(chain_period2[:a]).+std(chain_period2[:a])) .+ (mean(chain_period2[:b]).+std(chain_period2[:a])).^possible_distances)
p_period3 = logistic.(mean(chain_period3[:a]) .+ mean(chain_period3[:b]).^possible_distances)
p_period3_std = logistic.((mean(chain_period3[:a]).+std(chain_period3[:a])) .+ (mean(chain_period3[:b]).+std(chain_period3[:a])).^possible_distances)
p_period4 = logistic.(mean(chain_period4[:a]) .+ mean(chain_period4[:b]).^possible_distances )
p_period4_std = logistic.((mean(chain_period4[:a]).+std(chain_period4[:a])) .+ (mean(chain_period4[:b]).+std(chain_period4[:a])).^possible_distances )
end;

# ╔═╡ a873acde-242e-11eb-31d7-0165fc71d465
md"We plot now for each period the probability of scoring for each period, each mean and one standard deviation from it."

# ╔═╡ 5d4fcd4a-2367-11eb-1c5f-fb9961b9a3d4
begin
	plot(possible_distances, p_period4,ribbon=p_period4_std.-p_period4,  color=:magenta, label="period4", fillalpha=.3, ylim=(0,0.6))
	plot!(possible_distances, p_period2, color=:green, ribbon=p_period2_std.-p_period2, label="period2", fillalpha=.3)
	plot!(possible_distances, p_period3, color=:orange, ribbon=p_period3_std.-p_period3, label="period3",fillalpha=.3)
		plot!(possible_distances, p_period1,ribbon=p_period1_std.-p_period1, color=:blue, label="period1", fillalpha=.3)
	xlabel!("Normalized distance")
	ylabel!("Scoring probability")
	
end

# ╔═╡ 60defa1c-242f-11eb-13b2-1f77ecbe291f
md"Finally, we see that for the periods 1 and 4, the first and the last periods, the probabity of scoring is slightly higher than the other two periods, meaning that players are somewhat better scoring in those periods."

# ╔═╡ 6341de9e-836a-11eb-371d-e9b4a3a2f743
md"
### Summary
In this chapter, we used the NBA shooting data of the season 2006-2007 to analyze how the scoring probability is affected by some variables, such as the distance from the hoop and the angle of shooting.


First, we inspected the data by plotting a heatplot of all the shots made and making histograms of the ones that scored.
As our goal was to study the probability of scoring, which is a Bernoulli trial situation, we decided to use a Bernoulli model.
Since the only parameter needed in a Bernoulli distribution is the probability *p* of having a success, we modeled *p* as a logistic function: $p\sim logistic(a+ b*distance[i] + c*angle[i])$

We set the prior probability of the parameters *a* and *c* to a normal distribution and *b* to a log-normal one. 
Thus, we constructed our logistic regression model and sampled it using the Markov Monte Carlo algorithm.
To gain a better understanding of the sampling process, we made a traceplot that shows the sampled values in a sequential order.

Later, we decided to try with a more complex logistic regression model, similar to the first one but this time modifying the distance parameter: $p\sim logistic(a+ b^{distance[i]} + c*angle[i])$ 


We set the prior distribution of *b* to a beta distribution and constructed the second logistic regression model, sampled it and plotted the results.

Finally, we analyzed the results to see if the period of the game affects the probability of scoring.
"

# ╔═╡ 0cab33d6-8b5c-11eb-3d54-4945548bbf39
md" ### Give us feedback
 
 
This book is currently in a beta version. We are looking forward to getting feedback and criticism:
  * Submit a GitHub issue **[here](https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers/issues)**.
  * Mail us to **martina.cantaro@lambdaclass.com**
 
Thank you!
"


# ╔═╡ 0c12a7d8-8b5c-11eb-2dad-bb312eb48da9
md"
[Next chapter](https://datasciencejuliahackers.com/09_optimal_pricing.jl.html)
"


# ╔═╡ Cell order:
# ╟─79145330-8bdf-11eb-1153-a7a081365531
# ╟─b4257f94-204e-11eb-258e-0524565c4d41
# ╠═fa821e30-2293-11eb-3ba4-e3a7ca987312
# ╟─cc25e57c-204e-11eb-23a6-7d5a88113776
# ╠═e3bc0914-204e-11eb-3677-aba2e235ef3b
# ╠═8e40725c-235c-11eb-1401-0f6312dbc5ad
# ╟─e915d9bc-204e-11eb-0f8c-d52fc2084322
# ╠═edeabd04-204e-11eb-1c63-118f10ca070a
# ╟─f2c2b5b6-204e-11eb-2fec-21e285391c03
# ╟─f7e32184-204e-11eb-2e22-efc3d9821674
# ╠═f1b51206-2056-11eb-2ef9-7de142b32797
# ╟─326336c4-2058-11eb-23bd-e5cc758bc9c2
# ╟─41395aac-205d-11eb-29e2-77b28ded5aef
# ╠═04c41c34-2066-11eb-16d8-d7a662b362fe
# ╠═e0524328-2063-11eb-1f81-5535a281701f
# ╠═475af57e-2064-11eb-0aa8-e3e07cf6b7c9
# ╟─8190de9e-2068-11eb-03b2-25f3b9183dbe
# ╠═0638a720-2065-11eb-3d6f-99ce0f308867
# ╟─121240e2-2394-11eb-3865-fd2d94281d57
# ╟─8dd89dca-2394-11eb-2d34-2d584b8e8fbd
# ╟─3d1794bc-2066-11eb-0ab3-7320911a9964
# ╠═66aee544-2072-11eb-2a78-37d0f33e66e6
# ╟─3d9b284e-2073-11eb-0b69-e7bcb7241843
# ╟─bb2a837a-2073-11eb-0109-e76c0f370cea
# ╟─29426866-2075-11eb-114a-674a286cc586
# ╟─901ad6f8-2075-11eb-13fc-f3d501387757
# ╟─c312e2a4-2075-11eb-2faf-d55d61c9d39c
# ╟─d4ce7370-2075-11eb-220d-136d89b3daa9
# ╟─5c0afe60-2299-11eb-2985-399ae5501578
# ╠═35970552-229a-11eb-1786-7d5ae736a89d
# ╟─c9bc18da-229a-11eb-266b-69c6be868c1e
# ╟─71ff112e-229f-11eb-3c78-b9e8a77b0b65
# ╟─b99b3b7a-229f-11eb-238f-73ea6d44f206
# ╟─f207b090-229c-11eb-3567-d5bd1c42d9b4
# ╠═36ced550-229d-11eb-1dbd-df184e970a68
# ╟─5b229308-22a0-11eb-1805-d7b1fbd63e5c
# ╟─9823f6a4-22b2-11eb-0c36-a9bfc81e09e0
# ╟─ad764842-2076-11eb-2aad-778de3b5c484
# ╠═9cf51b04-228f-11eb-0de9-1d79c084d9db
# ╠═44276f54-2299-11eb-2dd1-f96d8a232987
# ╟─c971fae4-2396-11eb-1070-e7fa7f4f6cc4
# ╠═4bfeeb80-2299-11eb-1c8c-55b953664f5a
# ╟─1dba6ec6-2371-11eb-0ebf-c94f7620bab7
# ╠═240d2902-2069-11eb-0a57-878337b4c980
# ╟─8bd6e516-22a1-11eb-0082-95cf09350dbd
# ╟─7ee40f42-22a5-11eb-2fc0-f579fe0917be
# ╟─d4143c48-22a1-11eb-00f3-afc11310b56b
# ╠═d9720614-22ad-11eb-1dde-1f243605ee34
# ╟─ad665eb4-22b0-11eb-022a-ffd6a969392e
# ╟─18a2518e-22b0-11eb-1a12-edb99072a6c5
# ╠═333b9190-22b0-11eb-2ac5-b1ec28e7d258
# ╟─f2a57c44-22ae-11eb-3f24-bda8faec4762
# ╟─7adfd7ca-22b2-11eb-1334-5985564fd195
# ╟─b24672a0-22b2-11eb-35e3-97f9ef153243
# ╠═39cc64c2-22b4-11eb-0ac8-918f817537d2
# ╟─90fbe58e-22b3-11eb-376f-7b525f5ac609
# ╟─5fb5edb0-22b5-11eb-0ff4-291bf910d4ca
# ╟─a4daf2aa-2427-11eb-3fbc-89ba6b2f14ec
# ╟─597bc46e-22b6-11eb-0a13-cfac61e8f7b0
# ╟─1378ab6e-22bb-11eb-22fa-a9aeb36344f9
# ╟─3091f30c-2428-11eb-1489-edcc26610813
# ╠═3b9e03bc-22b6-11eb-2ae5-23eefb618fc7
# ╠═db4c533a-22b6-11eb-2afa-47c5379ff7a3
# ╟─8bec6010-2429-11eb-30a1-29cee0e4df0f
# ╠═21cb52b8-22b7-11eb-221e-4d614103652d
# ╟─307dbd5a-22b7-11eb-3ed6-9bb6fe3066e3
# ╟─72762930-242a-11eb-3526-2da82f4f9af0
# ╠═5f7eaac4-22b7-11eb-00d5-9b9dd02d9d94
# ╟─0ba9956a-242b-11eb-12b3-8d84d80d0634
# ╟─a7e7e342-22b8-11eb-0ae2-211dc1ec64d8
# ╟─04457280-22b9-11eb-27bf-07b8a704f5b5
# ╟─998c9058-242b-11eb-1668-51cdca9a8449
# ╟─5badb748-22bf-11eb-32bd-11992bb6c4ed
# ╟─dc97ac06-22bf-11eb-23e7-81c6aff82de2
# ╠═6a6c10ec-235d-11eb-3177-4118c883e56a
# ╠═e89ee0ea-236f-11eb-0b37-b3ab0cfae682
# ╟─95897106-2368-11eb-167e-75f75d28fe45
# ╠═4a887f0e-235d-11eb-131f-0d90540bd708
# ╠═623fa138-2365-11eb-1470-d7739f7d80e8
# ╠═5cbe6528-2365-11eb-282d-23b1322b782c
# ╠═6d63e6dc-2365-11eb-2a64-c9ab02d45d8d
# ╠═95f42abc-2365-11eb-28b4-ad5dfa234a3a
# ╠═a37d3d9a-2365-11eb-26a4-8f37750427bb
# ╠═768611a8-2366-11eb-0073-0bb804405f74
# ╟─6b5ca676-2360-11eb-3cf7-33602907075c
# ╟─a873acde-242e-11eb-31d7-0165fc71d465
# ╠═5d4fcd4a-2367-11eb-1c5f-fb9961b9a3d4
# ╟─60defa1c-242f-11eb-13b2-1f77ecbe291f
# ╟─6341de9e-836a-11eb-371d-e9b4a3a2f743
# ╟─0cab33d6-8b5c-11eb-3d54-4945548bbf39
# ╟─0c12a7d8-8b5c-11eb-2dad-bb312eb48da9
