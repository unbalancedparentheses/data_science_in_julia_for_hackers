### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ a4f0a914-1ec9-11eb-3c22-db87a9776aaa
begin
	using JSON
	using DataFrames
end

# ╔═╡ 5f83510e-1fc5-11eb-3c40-83a844bf2907
using Turing

# ╔═╡ 3312a490-577d-11eb-08b2-9917572d77a3
using LinearAlgebra

# ╔═╡ ed4b583a-8bde-11eb-3537-a580e9e706d0
md"### To do list
 
We are currently working on:
 
";


# ╔═╡ 2414104e-1d41-11eb-37cb-9b5cee78a98b
md"## Creating our conjectures"

# ╔═╡ 3b7f8a1e-1d42-11eb-1ab1-c11fda416e80
md"""If there is one thing we can all agree on, it is that the reality in which we live is complex. The explanation for the things we usually see, and have naturalized in our daily lives, is usually quite complex and requires abstraction from what "is simply seen".

In order to give an explanation and gain a deeper understanding of the things we see, we tend to generate models that seek to explain them in a simple and generalized way. In this way we can reduce the noise of our observations to general rules that "govern" them.

For example, it is obvious to everyone that if we push a glass it will move in the same direction as we did. We also know that if we keep pushing it and it goes beyond the limits of the table, it will fall to the floor. But one thing is to have the intuition of what's going to happen, and another is to have an understanding of the laws that govern that movement. In this case, they are the Newton´s Law´s of motion:

"""

# ╔═╡ 4e4385b4-203b-11eb-0c5b-cbe41156401b
md"$ \vec{F}^{\} = m*\vec{a}^{\}$"

# ╔═╡ 2dca2f42-203b-11eb-2cb3-0d6a3823cdcd
md"""In this way, and with only one formula, it is possible to gain an understanding that is generalizable to many aspects of reality. 

#### Observable variables vs Latent variables

Now, it is worth noting that in this case all the variables that make up our model are observable. This means that they can be measured directly.

In the case of a glass, we could weigh it with a scale. Then, by pushing it, we could measure the acceleration it acquired and from these two measurements we could obtain the force we applied to it. So, every parameter of the model is fully defined.

However, as we try to advance in our understanding of reality, we arrive at more and more complex models and many times we are not so lucky to be able to define them with simple observable variables.

For example, this is very common in the economic sciences, where models are created with variables such as "quality of life". Economists will try to measure this latent variable with other variables that can be observed (such as GDP per capita, schooling rate, number of hospitals for a certain number of inhabitants, etc), but that do not have an obvious and direct relationship as if they had newton's equations.

This type of latent variables are used in different models to gain greater abstraction and to be able to obtain information that is not found at first sight in the data. For example, in the case of economics, from concrete measures of a country's economy it is possible to generalize knowledge and be able to infer an abstract variable such as quality of life.

### Bayesian hierarchical models

The Bayesian framework allows us to build statistical models that can generalize the information obtained from the data and make inferences from latent variables. 

A nice way to think about this kind of models is that they allow us to build our "story" about which are the variables that generate the data we are observing. Basically, they allow us to increase the "depth" of our model by indicating that the parameters of our prior distributions also follow other probability distributions.

This sure is sounding very strange. Don't worry, let's move on to an example to clarify it.

#### Football analysis

Let's imagine for a moment that we are brilliant statisticians. We find ourselves looking for new interesting challenges to solve and we come across a sports bookmaker. They tell us that they want to expand into football betting and that they would like us to be able to build a model that allows them to analyze the strengths and weaknesses of English Premier League teams. They are interested because they want to be able to predict possible outcomes and thus be able to price the bets. 

The problem is that, as they have never worked in this sector before, they only have the results of the league matches. So what can we do? """

# ╔═╡ 0c0268dc-1ed3-11eb-2f73-b3706305b298
md"We have the data stored in a specific format called JSON, so the first thing to do is to parse and visualize it"

# ╔═╡ cbaaf72c-1eb4-11eb-3509-932b337f270b
begin
england_league = JSON.parsefile("matches_England.json")
matches_df = DataFrame(home = [], away = [], score_home = [], score_away = [])
end;

# ╔═╡ ab6fcb22-1ed2-11eb-2749-3bef16911972
begin
	matches = []
	for match in england_league
		push!(matches, split(match["label"], ","))
end
end

# ╔═╡ d2a81a14-1ed2-11eb-1307-bfb169aebbb4
begin
for match in matches
	home, away = split(match[1], " - ")
	score_home, score_away = split(match[2], " - ")
	
	push!(matches_df,[home, away, parse(Int,score_home), parse(Int,score_away)])
end
end	

# ╔═╡ dd80fc38-1ed2-11eb-0e8c-49859d27c72c
matches_df

# ╔═╡ 7f0c72d4-1f9e-11eb-06f1-cb587d7e5436
teams = unique(collect(matches_df[:,1]))

# ╔═╡ 868e5c8c-1ed3-11eb-291c-fb26d512c103
md"""So, we have the data of the 380 matches that were played in the Premier League 2017/2018 and our challenge is to be able to analyze the characteristics of these teams. 

A priori it may seem that we are missing data, that with the data we have we cannot infer "characteristics" specific to each team. At most, it might be possible to see who the teams that scored the most goals, the averages of goals per game or how the positions were after the tournament, but to obtain characteristics of the teams? how could we face this problem?

#### Creating our stories

Let's see what information we have from our data: 
On one hand we have specified the names of each team and which one is local. On the other hand, we have the number of goals scored.

A possible approach to this data is to realize that the goals scored by each team can be modeled with a poisson distribution. 

Why? You have to remember that this distribution describes "arrivals" - discrete events - in a continuum. For example, it is widely used to describe customer arrivals to a location as time passes or failures in continuous industrial processes (e.g. failure in the production of a pipe). 

In this particular case, we could propose that the goals scored by a team are the discrete events that occur in the time continuum that the game last:

"""

# ╔═╡ 04a8f16c-1ed5-11eb-3979-af35c6d9dea1
md"$Score \sim Poisson(θ)$"

# ╔═╡ 9f1e1618-1edb-11eb-02af-9fa5c8904163
md"""Well, we have an improvement. We've already told our model how to think about goals scored. 

Now we can use the flexibility of Bayesianism to indicate what the "goal rate" of our Poisson depends on.  You can think of it literally as the number of goals a team scores per unit of time. And this is where we have to take advantage of all the information provided by the data set.

As expected, this rate has to be particular to each match the team plays and take into account the opponent. We can therefore propose that the scoring rate of each team (in each particular match) depends on the "attacking power" of the team on the one hand, and the "defensive power" of the opponent on the other:

"""

# ╔═╡ 42104900-1f80-11eb-019f-a7c561ca3e4b
md"$θ_{team1} \sim att_{team1} + def_{team2}$" 

# ╔═╡ 9d0f3a1e-1f80-11eb-3422-fb7b4696cc13
md"""In this way we could be capturing, from the results of each game, the attack and defence strengths of each team. 

Another latent variable that we could obtain, given the data, is if there is an effect that increases (or decreases) the goal rate related to whether the team is local or not. This would also help - in case there is indeed an effect - in not the attack and defence parameters be disrupted by having to "contain" that information."""

# ╔═╡ 0b1f9c68-1f83-11eb-11e7-e7614c021c05
md"$θ_{home} \sim home + att_{home} + def_{away}$
$θ_{away} \sim att_{away} + def_{home}$"

# ╔═╡ 043c438c-1f84-11eb-2cd7-6dd07a125910
md"""This leaves one attack and one defense parameter for each team, and a global league parameter that indicates the effect of being local on the scoring rate.

#### Letting the information flow 

We are already getting much closer to the initial goal we set. As a last step, we must be able to make the information flow between the two independent poissons that we proposed to model the score of each of the two teams that are playing. We need to do that precisely because we have proposed that the poissons are independent, but we need that when making the inference of the parameters the model can access the information from both scores so it can catch the correlation between them. In other words, we have to find a way to interconnect our model.

And that is exactly what hierarchical Bayesian models allow us to do. How? By letting us choose probability distributions for the parameters that represent the characteristics of both equipment. With the addition that these parameters will share the same prior distributions. Let's see how:

The first thing to do, as we already know, is to assign the prior distributions of our attack and defense parameters. A reasonable idea would be to propose that they follow a normal distribution since it is consistent that there are some teams that have a very good defense, so the parameter would take negative values; or there may be others that have a very bad one, taking positive values (since they would "add up" to the goal rate of the opposing team). The normal distribution allows us to contemplate both cases.

Now, when choosing the parameters we are not going to stop and assign fixed numbers, but we will continue to deepen the model and add another layer of distributions:

"""

# ╔═╡ 4a31541e-1f97-11eb-038e-736446224c21
md"$att_{t} \sim Normal(μ_{att}, σ_{att})$
$def_{t} \sim Normal(μ_{def}, σ_{def})$"

# ╔═╡ e3a99868-1f97-11eb-1872-79c8f6abe1be
md"Where the t sub-index is indicating us that there are a couple of these parameters for each team.

Then, as a last step to have our model defined, we have to assign the priority distributions that follow the parameters of each normal distribution. We have to define our hyper priors.

"

# ╔═╡ c3ca1cc4-1f98-11eb-3c23-33acb95fbc03
md"$μ_{att}, μ_{def} \sim Normal(0, 0.1)$
$σ_{att}, σ_{def} \sim Exponential(1)$"

# ╔═╡ 4106e55a-1f99-11eb-110e-b79221774f12
md"We must not forget the parameter that represents the advantage of being local"

# ╔═╡ bff4fdae-1f99-11eb-2d94-aba7bf9d097f
md"$home \sim Normal(0,1)$"

# ╔═╡ 2b135202-1fa7-11eb-324d-93a5eda41e3e
md"""Now that our model is fully define, let's add one last restriction to the characteristics of the teams to make it easier to compare them: subtract the average of all the attack and defence powers from each one. In this way we will have the features centred on zero, with negative values for the teams that have less attacking power than the average and positive values for those that have more. As we already said, the opposite analysis applies to the defence, negative values are the ones that will indicate that a team has a strong defence as they will be "subtracting" from the scoring rate of the opponent. This is equivalent to introducing the restriction:
"""

# ╔═╡ ddc7b166-203a-11eb-0ac2-056c309bb590
md"$\sum att_{t} = 0$
$\sum def_{t} = 0$"

# ╔═╡ 8e164be0-203b-11eb-293a-6b32dba96133
md"Let's translate all this into Turing code:"

# ╔═╡ 51a309bc-2033-11eb-10c0-ed17545df33d
begin
	@model function football_matches(home_teams, away_teams, score_home, score_away, teams)
	#hyper priors
	σatt ~ Exponential(1)
	σdeff ~ Exponential(1)
	μatt ~ Normal(0,0.1)
	μdef ~ Normal(0,0.1)
	
	home ~ Normal(0,1)
		
	#Team-specific effects	
	att ~ filldist(Normal(μatt, σatt), length(teams))
	def ~ filldist(Normal(μatt, σdeff), length(teams))
	
	dict = Dict{String, Int64}()
	for (i, team) in enumerate(teams)
		dict[team] = i
	end
		
	#Zero-sum constrains
	offset = mean(att) + mean(def)
	
	log_θ_home = Vector{Real}(undef, length(home_teams))
	log_θ_away = Vector{Real}(undef, length(home_teams))
		
	#Modeling score-rate and scores (as many as there were games in the league) 
	for i in 1:length(home_teams)
		#score-rate
		log_θ_home[i] = home + att[dict[home_teams[i]]] + def[dict[away_teams[i]]] - offset
		log_θ_away[i] = att[dict[away_teams[i]]] + def[dict[home_teams[i]]] - offset
		#scores
		score_home[i] ~ LogPoisson(log_θ_home[i])
		score_away[i] ~ LogPoisson(log_θ_away[i])
	end
	
	end
end

# ╔═╡ f3f0b6f8-2033-11eb-0f9e-d951d791001d
md"""As you can see, the turing code is very clear and direct. In the first block we define our hyperpriors for the distributions of the characteristics of the equipment.

In the second one, we define the priors distributions that will encapsulate the information about the attack and defense powers of the teams. With the *filldist* function we are telling Turing that we need as many of these parameters as there are teams in the league *length(teams)*

Then, we calculate the average of the defense and attack parameters that we are going to use to centralize those variables, and we use the LogPoisson distribution to allow the theta to take some negative value in the inference process and give more sensitivity to the parameters that make it up.

As we said before, we will model the thetas for each game played in the league, that's why the *for* of the last block goes from 1 to *length(home_teams)*, which is the list that contains who was the local team of each game played.

So let´s run it and see if all of this effort was worth it:
"""

# ╔═╡ f3f4bfba-203f-11eb-142c-a187112744d2
model = football_matches(matches_df[:,1], matches_df[:,2], matches_df[:,3], matches_df[:,4], teams)

# ╔═╡ 2ce4435c-2040-11eb-1670-e39ad4cc690c
posterior = sample(model, NUTS(),3000);

# ╔═╡ 8c1dd9de-2040-11eb-35a3-39e8196577a1
md"#### Analyzing the results
In order to compare and corroborate that the inference of our model makes sense, it is key to have the ranking table of how the teams actually performed in the 2017/2018 Premier League.
"

# ╔═╡ 0f9406ae-2054-11eb-3f0c-1d03ba779f18
begin
	table_positions = 
	[11, 5, 9, 4, 13, 14, 1, 15, 12, 6, 2, 16, 10, 17, 20, 3, 7, 8, 19, 18]
	
	games_won = 
	[32, 25, 23, 21, 21, 19, 14, 13, 12, 12, 11, 11, 10, 11, 9, 9, 7, 8, 7, 6]
	
	teams_ = []
	for i in table_positions
		push!(teams_, teams[i])
	end
	
	table_position_df = DataFrame(Table_of_positions = teams_, Wins = games_won)

end

# ╔═╡ 099e4188-2054-11eb-1e7e-69bdb2b0202c
md"Let's now explore a little bit the a posteriori values we obtained."

# ╔═╡ 16572944-2045-11eb-38d0-fb20d981e3e9
begin
	post_att = collect(get(posterior, :att)[1])
	post_def = collect(get(posterior, :def)[1])
	post_home = collect(get(posterior, :home)[1])
end;

# ╔═╡ 4ae7d968-206f-11eb-1925-c5b5a31e6940
begin
	using Plots
	gr()
histogram(post_home, legend=false, title="Posterior distribution of home parameter")
end

# ╔═╡ 8cec9318-206e-11eb-3caa-3bad9d788d3c
md"As a first measure to analyze, it is interesting to see and quantify (if any) the effect that being local has on the score rate:"

# ╔═╡ 8b77d12c-206f-11eb-19a5-f557157ac05e
mean(post_home)

# ╔═╡ b56df7ea-206f-11eb-18b9-0544cc596ca5
md"So, to include in the model the parameter home was a good idea. indeed being local provides a very big advantage. 

Beyond the fact that it is interesting to be able to quantify how much the location influences the scoring rate of the teams, including it in the analysis allow us to have better estimates of the defense and attack parameters of the teams. This is true because if it had not been included, this positive effect would have manifested itself in the only parameters it would have found, the attack and defense parameters, deforming the real measure of these.

So, being confident that we are on the right track, let´s find the attack and defence parameters of each team."

# ╔═╡ 554b4ef0-2045-11eb-3218-050ec936f1aa
begin
	teams_att = []
	teams_def = []
	for i in 1:length(post_att)
		push!(teams_att, post_att[i])
		push!(teams_def, post_def[i])
	end
end

# ╔═╡ 8a4df438-2045-11eb-2798-af592dbbffb5
md"This way we obtain all the samples of the posterior distributions for each one of the parameters of each equipment. Scroll right to explore the entire array."

# ╔═╡ 6b1a1520-2045-11eb-1302-0778b4e7a836
teams_att

# ╔═╡ da93bf52-2045-11eb-2b6f-3f31f57d8653
md"For example, if we would like to se the posterior distribution of the attack parameter for Burnley:"

# ╔═╡ 1fa92570-2046-11eb-3541-e5fccf7afabd
teams[1]

# ╔═╡ 255c4d08-2046-11eb-1cf0-b32d2cd711bf
histogram(teams_att[1], legend=false, title="Posterior distribution of Burnley´s attack power")

# ╔═╡ 473e6a46-205b-11eb-2731-7b47b99d86a5
mean(teams_att[1])

# ╔═╡ 917d4550-2058-11eb-174b-65436a4e6cc8
md"Comparing it to the attacking power of Manchester City, champion of the Premier league:"

# ╔═╡ c2de4714-2058-11eb-1a0d-f1bf96649844
teams[11]

# ╔═╡ 0103406e-2059-11eb-333f-7b5814f21a54
begin
	histogram(teams_att[11], legend=false, title="Posterior distribution of Manchester City´s attack power")
end

# ╔═╡ 579a4d9e-205b-11eb-2352-83beca145211
mean(teams_att[11])

# ╔═╡ 6924f372-2059-11eb-2b98-6f4b65b777f4
md"When comparing the league champion against a mid-table team, we can clearly see the superiority in attack. For now, it seems that the inference comes in handy. 

Let's try now to have an overview of the attacking powers of each team. To do this, just take the average of each and plot it next to the standard deviation 
"

# ╔═╡ ece1d052-2060-11eb-2b50-ef46663ed88f
begin
	teams_att_μ = mean.(teams_att)
	teams_def_μ = mean.(teams_def)
	teams_att_σ = std.(teams_att)
	teams_def_σ = std.(teams_def)
end;

# ╔═╡ 43a39b30-2061-11eb-28c5-37cbc4aed84b
md"""Remember that the "." operator is used for broadcasting. This means that it will apply the function to each component of the array"""

# ╔═╡ 41ca2316-2062-11eb-3fe6-f33a789fd578
begin
	teams_att_μ
	sorted_att = sortperm(teams_att_μ)
	abbr_names = [t[1:3] for t in teams]
end;

# ╔═╡ 0ef8a16e-2063-11eb-1391-6b3b959de541
begin
	abbr_names[5] = "Mun"
	abbr_names[10] = "Whu"
	abbr_names[11] = "Mci"
	abbr_names[16] = "Bou"
	abbr_names[18] = "Wba"
	abbr_names[19] = "Stk"
	abbr_names[20] = "Bha"
end;

# ╔═╡ 1eb73246-2063-11eb-0f20-416e433b5144
sorted_names = abbr_names[sorted_att]

# ╔═╡ abace764-2062-11eb-2949-fd9e86b50f17
begin
	scatter(1:20, teams_att_μ[sorted_att], grid=false, legend=false, yerror=teams_att_σ[sorted_att], color=:blue, title="Premier league 17/18 teams attack power")
	annotate!([(x, y + 0.238, text(team, 8, :center, :black)) for (x, y, team) in zip(1:20, teams_att_μ[sorted_att], sorted_names)])

	ylabel!("Mean team attack")
end

# ╔═╡ ebd267a4-2064-11eb-02a7-b93465de6319
md"""Although there is a high correlation between the attacking power of each team and its position on the table after the league ends, it is clear that this is not enough to explain the results. For example, Manchester City was the league's sub-champion, but only appeared in fifth place.

Let's explore what happens to the defence power: """

# ╔═╡ f6ad5f52-2065-11eb-0be7-f159941e0d89
begin
	sorted_def = sortperm(teams_def_μ)
	sorted_names_def = abbr_names[sorted_def]
end

# ╔═╡ 539e68b4-2066-11eb-09c2-b337241c36bc
begin
	scatter(1:20, teams_def_μ[sorted_def], grid=false, legend=false, yerror=teams_def_σ[sorted_def], color=:blue, title="Premier league 17/18 teams defence power")
	annotate!([(x, y + 0.2, text(team, 8, :center, :black)) for (x, y, team) in zip(1:20, teams_def_μ[sorted_def], sorted_names_def)])
	ylabel!("Mean team defence")
end

# ╔═╡ 69e7e54c-2067-11eb-21a1-cb72f4b423cd
md"To read this graph we have to remember that the defense effect is better the more negative it is, since it is representing the scoring rate that takes away from the opponent team. As we already said:"

# ╔═╡ f59d488a-2067-11eb-1d4b-1d9dd97ea39e
md"$θ_{team1} \sim att_{team1} + def_{team2}$"

# ╔═╡ 27d5a290-2068-11eb-06f5-0b16f6ec6cc5
md"As the $def_{team2}$ is adding up in the equation, if it take negative values, it is going to start substracting the scoring rate of the oponent.

Things, then, begin to make a little more sense. Now we can see that Manchester United is the team with the strongest defence, so being second in the overall is not extrange.

To gain a deeper understanding of what´s going on here, let's chart both characteristics together. This is going to let us see the combined effect they have. Also i´m going to add the final position of each team to improve the interpretability."

# ╔═╡ b8f9bae8-206a-11eb-1426-031f6fd05fd6
begin
	table_position = 
	[11, 5, 9, 4, 13, 14, 1, 15, 12, 6, 2, 16, 10, 17, 20, 3, 7, 8, 19, 18]
	position = sortperm(table_position)
end

# ╔═╡ ee45d48e-206a-11eb-0edf-2b8b893bb583
begin
	scatter(teams_att_μ, teams_def_μ, legend=false)
	annotate!([(x, y + 0.016, text(team, 6, :center, :black)) for (x, y, team) in zip(teams_att_μ, teams_def_μ, abbr_names)])
	
	annotate!([(x, y - 0.016, text(team, 5, :center, :black)) for (x, y, team) in zip(teams_att_μ, teams_def_μ, position)])

	xlabel!("Mean team attack")
	ylabel!("Mean team defence")
end

# ╔═╡ c794f45e-206b-11eb-33c4-05bc429ba846
md"""Well, great! Now we have some interesting information to analyze the teams and the league in general. It´s easier now to perceive how the two features interact with each other, comparing between teams and being able to see how that affects the final position. 

For example, looking at the cases of Liverpool and Tottenham, or Leicester City and Everton; one could say (against general common sense) that the power of defense has a greater effect on the performance of each team than the attack. But we leave you to do those analysis for the betting house.

Well, we went from having a problem that seemed almost impossible to have a solid solution, with a quantitative analysis of the characteristics of each team. We even know how much the localization of the teams increases the scoring rate. We were able to achieve this thanks to the hierarchical framework that Bayesianism provides us. Using this tool allows us to create models proposing latent variables that cannot be observed, to infer them and to gain a much deeper and more generalized knowledge than we had at first. You just have to imagine a good story.

## Simulate possible realities

So we close our laptop and go with all this analysis to the sport bookmarker and start explain it to them. They are fascinated with it as now they have lot more precious information about each team, in order to make data grounded bets. Its a total victory!

We are about to go when suddenly, one guy that have been quiet the hole time, say "in two weeks is the 2017–18 UEFA Champions League´s quarter-final and Manchester City plays against the Liverpool, two teams that be have already analize! Can any analysis be done to see the possible results and their probabilities?" 

We think for a moment: "Yes, we have each teams strengths and weaknesses and they are also from the same league, so the home parameter would be the same"... Okey, we said, lets give it a try!

Can you imagine a way to solve this problem?

Well, we have the posterior characteristics of each team. And we have inferred from the data of football metches that the have played. So maybe we can do the opposite and, given the parameters of attack, defense and location of each teams, we could simulate a series of matches between them. We could actually simulate millions of these matches! Then we should only see which results occurred the most and with that we could obtain the **probability** of occurrence. At least sounds great, doesn´t it?

First, lets see the parameters that we alredy have:
"""

# ╔═╡ ce82fbea-5779-11eb-2c2f-d9174c989e58
begin
	mci_att_post = collect(get(posterior, :att)[:att])[11][:,1];
	mci_def_post = collect(get(posterior, :def)[:def])[11][:,1];
	liv_att_post = collect(get(posterior, :att)[:att])[4][:,1];
	liv_def_post = collect(get(posterior, :def)[:def])[4][:,1];
end

# ╔═╡ f414cdfc-5779-11eb-194a-f3e052d6acb9
begin
	ha1 = histogram(mci_att_post, title="Manchester City attack", legend=false)
	ha2 = histogram(liv_att_post, title="Liverpool attack", legend=false)
	plot(ha1, ha2, layout=(1,2))
end

# ╔═╡ 19844c48-577a-11eb-3bea-99ae3a6aeaa8
begin
	hd1 = histogram(mci_def_post, title="Manchester City defense", legend=false)
	hd2 = histogram(liv_def_post, title="Liverpool defense", legend=false)
	plot(hd1, hd2, layout=(1,2))
end

# ╔═╡ 9d5734ae-577a-11eb-2208-c1ec0795197e
md"So it seems that the Manchester City have a little advantage over Liverpool. And this is reasonable. The Manchester City was the champion of the Premier League that year while the Liverpool came only fourth. But let stop talking, and start to simulate outcomes! "

# ╔═╡ 5d05b034-577b-11eb-2fb0-332df95dd04f
# This function simulates matches given the attack, defense and home parameters.
# The first pair of parameters alwas correspond to the home team.

function simulate_matches_(att₁, def₁, att₂, def₂, home, n_matches, home_team = 1)
    if home_team == 1
        logθ₁ = home + att₁ + def₂
        logθ₂ = att₂ + def₁

    elseif home_team == 2
        logθ₁ = att₁ + def₂
        logθ₂ = home + att₂ + def₁
    else
        return DomainError(home_team, "Invalid home_team value")
    end
    
    scores₁ = rand(LogPoisson(logθ₁), n_matches)
    scores₂ = rand(LogPoisson(logθ₂), n_matches)
    
    results = [(s₁, s₂) for (s₁, s₂) in zip(scores₁, scores₂)]
    
    return results
end

# ╔═╡ 6234b58c-577b-11eb-1272-a9fd7c56349b
function simulate_matches(team1_att_post, team1_def_post, team2_att_post, team2_def_post, home_post, n_matches)
    
    team1_as_home_results = Tuple{Int64,Int64}[]
    team2_as_home_results = Tuple{Int64,Int64}[]
    
    for (t1_att, t1_def, t2_att, t2_def, home) in zip(team1_att_post, team1_def_post, 
                                                      team2_att_post, team2_def_post,
                                                      home_post)
        
        team1_as_home_results = vcat(team1_as_home_results, 
									 simulate_matches_(t1_att, t1_def, t2_att,
													   t2_def, home, n_matches, 1))
        
        team2_as_home_results = vcat(team2_as_home_results,
									 simulate_matches_(t1_att, t1_def, t2_att, 															   t2_def, home, n_matches, 2))
    end
    
    max_t1_as_home = maximum(map(x -> x[1], team1_as_home_results))
    max_t2_as_away = maximum(map(x -> x[2], team1_as_home_results))
    
    max_t1_as_away = maximum(map(x -> x[1], team2_as_home_results))
    max_t2_as_home = maximum(map(x -> x[2], team2_as_home_results))

    matrix_t1_as_home = zeros(Float64, (max_t1_as_home + 1, max_t2_as_away + 1))
    matrix_t2_as_home = zeros(Float64, (max_t1_as_away + 1, max_t2_as_home + 1))
    
    for match in team1_as_home_results
        matrix_t1_as_home[match[1] + 1, match[2] + 1] += 1
    end
    
	normalize!(matrix_t1_as_home, 1)
    
    for match in team2_as_home_results
        matrix_t2_as_home[match[1] + 1, match[2] + 1] += 1
    end
    
	normalize!(matrix_t2_as_home, 1)
    
    return matrix_t1_as_home, matrix_t2_as_home
end

# ╔═╡ 0c43bfbc-577c-11eb-1a03-b78035d5057c
md"""So what are those functions exactly doing? 

Well, the first one is the simplest. It just simulates matches with a specific set of attack, defense and location parameters. So we have the parameters that define the Poisson´s rate parameters "$θ$" fixed (here we have to remember that every match is a sample from the two $LogPoisson$ distributions, each one modelating each teams score in a given match). And it simulates as many matches as the $n_{matches}$ parameter indicates in order to get a broad sampling of the two poisson distributions, that is, to have a good sampling of possible match results with those fixed parameters. That way we can obtain, given those parameters, which are the most likely results to occur. Lets take the parameter´s approximate mean (you can check them in the histograms of above) as an example to see what happen :"""

# ╔═╡ e4e3350e-59ad-11eb-3132-574bd9505a7f
mean(mci_att_post)

# ╔═╡ e6bd3b9a-59a5-11eb-3c64-93fa5eaf192c
simulate_matches_(0.75, -0.35, 0.55, -0.2, 0.33, 1000, 2)

# ╔═╡ f5b332d0-59ad-11eb-1e93-8da5b52be991
md"""As you can see, we just generated 1000 simulated matches with an specific set of fix parameters. The "2" is just indicating that the liverpool (second team) is local. But as good bayesians that we are, we don´t want to use only the parameters mean, we want to use the hole distribution. And that´s what the second function is doing: It takes each parameter distribution as input and generate 1000 simulations for each posterior distributions points. As we made 3000 iterations in the calculation of the posterior, the function is going to simulate 3,000,000 matches. Sounds good, isn´t it?

Finally, It creates a matrix in which each of its positions is indicating a possible outcome and the value it takes will indicate the number of times over the 3,000,000 simulations in which that result came out. For example, the position (1,1) (top left of the matrix), is representing the matches whose results were 1 to 1. Also, the maximum length of the matrix is given by the maximum number of goals that have been scored in the simulation. Does it makes sense? 

The $normalize!(matrix\_t1\_as\_home, 1)$ line is only converting the absolute number of times a result came up, into a proportion. That is, in this case, is going to divide all positions by 3,000,000. 

So, lets see it in action!"""

# ╔═╡ 650c93ee-577c-11eb-02ef-3fcd1f442fda
mci_as_home_simulations, 
liv_as_home_simulations = simulate_matches(mci_att_post, mci_def_post, 
										   liv_att_post, liv_def_post,                                                            post_home, 1000)

# ╔═╡ 801ed646-59b2-11eb-23d0-03607ec04dc9
md"Looking those matrices could be not as enlightening as we wanted to. A good way to fix this is graphing them with a heatmap"

# ╔═╡ df9ac5a8-59b2-11eb-3e09-21c5ca6d68d3
function match_heatmaps(matrix_t1_as_home, matrix_t2_as_home,
                        team1_name="Team 1", team2_name="Team 2")    
    gr()   

    x_t1_home = string.(0:10)
    y_t1_home = string.(0:10)
    heat_t1_home = heatmap(x_t1_home,
                           y_t1_home,
                           matrix_t1_as_home[1:11, 1:11],
                           xlabel="$team2_name score", ylabel="$team1_name score",
                           title="$team1_name as home")
    
    x_t2_home = string.(0:10)
    y_t2_home = string.(0:10)
    heat_t2_home = heatmap(x_t2_home,
                           y_t2_home,
                           matrix_t2_as_home[1:11, 1:11],
                           xlabel="$team2_name score", ylabel="$team1_name score",
                           title="$team2_name as home")
    
    plot(heat_t1_home, heat_t2_home, layout=(1,2), size=(900, 300))
    current()   
end

# ╔═╡ ea212ed6-59b2-11eb-24ae-9f1a9a4da974
match_heatmaps(mci_as_home_simulations, liv_as_home_simulations, "Manchester City", "Liverpool")

# ╔═╡ 07f12d6c-59b3-11eb-2efe-cd96a6ee2867
md"And Voilà! We have our beautiful heatmaps indicating which of the possible outcomes are the most probable! As we expected chances favour the Manchester City. To make this analysis even more quantitative, we can add up the probabilities of all outcomes that mean a win for one of the teams to get the overall probability of Manchester City winning, Liverpool winning or a draw occurring:"

# ╔═╡ 1ef1447a-59b8-11eb-2fd8-f900fb3ce02c
function win_and_lose_probability(simulation)
    
    team1_winning_prob = 0
    team2_winning_prob = 0
    draw_prob = 0
    
    for i in 1:size(simulation, 1)
        for j in 1:size(simulation, 2)
            if i > j
                team1_winning_prob += simulation[i,j]
            elseif i < j
                team2_winning_prob += simulation[i,j]
            else
                draw_prob += simulation[i,j]
            end
        end
    end
    
    return team1_winning_prob, team2_winning_prob, draw_prob
end

# ╔═╡ 821f397a-59c8-11eb-09d2-9b8102128ca5
win_and_lose_probability(liv_as_home_simulations)

# ╔═╡ 239ddf2e-59b8-11eb-153d-af38e52f4a8f
win_and_lose_probability(mci_as_home_simulations)

# ╔═╡ 74355b96-59c8-11eb-1998-497b28294071
md"So the probability of winning for the Manchester City were 0.41 (or 41%) in the first match of the quarters final, with Liverpool as home, 0.37 for the Liverpool and 0.22 probability of a draw. In the second, with Manchester City as home, the chances were 0.65, 0.17 and 0.18 respectively.

We also can ask for the probability of a specific score:"

# ╔═╡ 11b43056-59cc-11eb-3d29-917205fe9592
get_score_probability(score1::Int64, score2::Int64, simulation) = simulation[score1+1, score2+1]

# ╔═╡ 46306124-59cc-11eb-2919-97f8ced0b8bd
get_score_probability(1, 1, liv_as_home_simulations)

# ╔═╡ 105c4540-59d1-11eb-05a3-4f895c782785
get_score_probability(2, 1, mci_as_home_simulations)

# ╔═╡ 78ab3b6a-59cc-11eb-1705-273fd202ced3
md"So the most possible outcomes accumulates around 8-9% of probability

What really happened wasn't expected. The Liverpool won 3-0 being home in the first round of the quarters final. And then Liverpool won 2-1 in Manchester´s estadium! It was really unexpected. The Manchester was the favorite by far, the probability was on his side, and still could not beat Liverpool."

# ╔═╡ a80d9bc0-59cf-11eb-22aa-bff0f84cf6b5
get_score_probability(0, 3, liv_as_home_simulations)

# ╔═╡ 85bcf944-59cf-11eb-0834-fd898b31a776
get_score_probability(1, 2, mci_as_home_simulations)

# ╔═╡ cbe72dd2-59d0-11eb-34fe-31533b6139f7
md"Still, the model assigns some probability to those results. Here is the information, then, you have to decide what to do with it.

As data scientist that we are, our labor is to came up with possible solutions to a problem, try it, have fun, and learn from it in order to be able to came up with better solutions. It is a very good practice to constructively criticize the models that we develop. So, can you think of improvements for our model? Well, I help you with some ideas: 

The logic of a cup tournament is different than the league. In the first one, if you lose, you have to return to your house and the other advances to the next round. And in the league, you have to be consistent to the hole year. Maybe a draw is good for you, as your goal is to make the most difference in points. So try to extrapolate the model to other tournament maybe questionable. 

Other thing is that we suppose that the two matches were independent, when the second one is conditioned to the first! As the Liverpool won the first match, the Manchester had to played to the second game with the aim of making at least 3 goals while Liverpool were only focus in the defence.


Anyway, we just learned that modeling is not a easy task. But the way to get better is proposing them, testing them and learning from them. In other words, the only way to learn is doing them (as any other skill in life). So, relax, model and have fun :)

## Summary

In this chapter we have learned about bayesian hierarchical models and how to use simulations to count different possible outcomes. First, we talked about latent variables and how important they are for gaining more abstraction in our models. After explaning the pro's of the hierarchical models, we proceed on building a model to get a deeper understanding of the Premier League. After inferring its parameters, we have used visualizations to understand the influence of attack and defense power in the league. Finally, we ran a simulation in order to calculate the probabilities of each possible outcome of a match between Liverpool and Manchester City.

"

# ╔═╡ fcb7e8d2-2071-11eb-020d-7bb1d53f8a6d
md"### Bibliography 

- [Paper of Gianluca Baio and Marta A. Blangiardo](https://discovery.ucl.ac.uk/id/eprint/16040/1/16040.pdf)
- [Post of Daniel Weitzenfeld](http://danielweitzenfeld.github.io/passtheroc/blog/2014/10/28/bayes-premier-league/)

"

# ╔═╡ 094c4b94-8b57-11eb-3731-f9d63210182c
md" ### Give us feedback
 
 
This book is currently in a beta version. We are looking forward to getting feedback and criticism:
  * Submit a GitHub issue **[here](https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers/issues)**.
  * Mail us to **martina.cantaro@lambdaclass.com**
 
Thank you!
 
"


# ╔═╡ 0a39835a-8b57-11eb-3b0e-97a3dd382dbb
md"
[Next chapter](https://datasciencejuliahackers.com/08_basketball_shots.jl.html)
"
 



# ╔═╡ Cell order:
# ╟─ed4b583a-8bde-11eb-3537-a580e9e706d0
# ╟─2414104e-1d41-11eb-37cb-9b5cee78a98b
# ╟─3b7f8a1e-1d42-11eb-1ab1-c11fda416e80
# ╟─4e4385b4-203b-11eb-0c5b-cbe41156401b
# ╟─2dca2f42-203b-11eb-2cb3-0d6a3823cdcd
# ╠═a4f0a914-1ec9-11eb-3c22-db87a9776aaa
# ╟─0c0268dc-1ed3-11eb-2f73-b3706305b298
# ╠═cbaaf72c-1eb4-11eb-3509-932b337f270b
# ╠═ab6fcb22-1ed2-11eb-2749-3bef16911972
# ╠═d2a81a14-1ed2-11eb-1307-bfb169aebbb4
# ╠═dd80fc38-1ed2-11eb-0e8c-49859d27c72c
# ╠═7f0c72d4-1f9e-11eb-06f1-cb587d7e5436
# ╟─868e5c8c-1ed3-11eb-291c-fb26d512c103
# ╟─04a8f16c-1ed5-11eb-3979-af35c6d9dea1
# ╟─9f1e1618-1edb-11eb-02af-9fa5c8904163
# ╟─42104900-1f80-11eb-019f-a7c561ca3e4b
# ╟─9d0f3a1e-1f80-11eb-3422-fb7b4696cc13
# ╟─0b1f9c68-1f83-11eb-11e7-e7614c021c05
# ╟─043c438c-1f84-11eb-2cd7-6dd07a125910
# ╟─4a31541e-1f97-11eb-038e-736446224c21
# ╟─e3a99868-1f97-11eb-1872-79c8f6abe1be
# ╟─c3ca1cc4-1f98-11eb-3c23-33acb95fbc03
# ╟─4106e55a-1f99-11eb-110e-b79221774f12
# ╟─bff4fdae-1f99-11eb-2d94-aba7bf9d097f
# ╟─2b135202-1fa7-11eb-324d-93a5eda41e3e
# ╟─ddc7b166-203a-11eb-0ac2-056c309bb590
# ╟─8e164be0-203b-11eb-293a-6b32dba96133
# ╠═5f83510e-1fc5-11eb-3c40-83a844bf2907
# ╠═51a309bc-2033-11eb-10c0-ed17545df33d
# ╟─f3f0b6f8-2033-11eb-0f9e-d951d791001d
# ╠═f3f4bfba-203f-11eb-142c-a187112744d2
# ╠═2ce4435c-2040-11eb-1670-e39ad4cc690c
# ╟─8c1dd9de-2040-11eb-35a3-39e8196577a1
# ╟─0f9406ae-2054-11eb-3f0c-1d03ba779f18
# ╟─099e4188-2054-11eb-1e7e-69bdb2b0202c
# ╠═16572944-2045-11eb-38d0-fb20d981e3e9
# ╟─8cec9318-206e-11eb-3caa-3bad9d788d3c
# ╠═4ae7d968-206f-11eb-1925-c5b5a31e6940
# ╠═8b77d12c-206f-11eb-19a5-f557157ac05e
# ╟─b56df7ea-206f-11eb-18b9-0544cc596ca5
# ╠═554b4ef0-2045-11eb-3218-050ec936f1aa
# ╟─8a4df438-2045-11eb-2798-af592dbbffb5
# ╠═6b1a1520-2045-11eb-1302-0778b4e7a836
# ╟─da93bf52-2045-11eb-2b6f-3f31f57d8653
# ╠═1fa92570-2046-11eb-3541-e5fccf7afabd
# ╠═255c4d08-2046-11eb-1cf0-b32d2cd711bf
# ╠═473e6a46-205b-11eb-2731-7b47b99d86a5
# ╟─917d4550-2058-11eb-174b-65436a4e6cc8
# ╠═c2de4714-2058-11eb-1a0d-f1bf96649844
# ╠═0103406e-2059-11eb-333f-7b5814f21a54
# ╠═579a4d9e-205b-11eb-2352-83beca145211
# ╟─6924f372-2059-11eb-2b98-6f4b65b777f4
# ╠═ece1d052-2060-11eb-2b50-ef46663ed88f
# ╟─43a39b30-2061-11eb-28c5-37cbc4aed84b
# ╠═41ca2316-2062-11eb-3fe6-f33a789fd578
# ╟─0ef8a16e-2063-11eb-1391-6b3b959de541
# ╠═1eb73246-2063-11eb-0f20-416e433b5144
# ╠═abace764-2062-11eb-2949-fd9e86b50f17
# ╟─ebd267a4-2064-11eb-02a7-b93465de6319
# ╠═f6ad5f52-2065-11eb-0be7-f159941e0d89
# ╠═539e68b4-2066-11eb-09c2-b337241c36bc
# ╟─69e7e54c-2067-11eb-21a1-cb72f4b423cd
# ╟─f59d488a-2067-11eb-1d4b-1d9dd97ea39e
# ╟─27d5a290-2068-11eb-06f5-0b16f6ec6cc5
# ╠═b8f9bae8-206a-11eb-1426-031f6fd05fd6
# ╠═ee45d48e-206a-11eb-0edf-2b8b893bb583
# ╟─c794f45e-206b-11eb-33c4-05bc429ba846
# ╠═ce82fbea-5779-11eb-2c2f-d9174c989e58
# ╠═f414cdfc-5779-11eb-194a-f3e052d6acb9
# ╠═19844c48-577a-11eb-3bea-99ae3a6aeaa8
# ╟─9d5734ae-577a-11eb-2208-c1ec0795197e
# ╠═3312a490-577d-11eb-08b2-9917572d77a3
# ╠═5d05b034-577b-11eb-2fb0-332df95dd04f
# ╠═6234b58c-577b-11eb-1272-a9fd7c56349b
# ╟─0c43bfbc-577c-11eb-1a03-b78035d5057c
# ╠═e4e3350e-59ad-11eb-3132-574bd9505a7f
# ╠═e6bd3b9a-59a5-11eb-3c64-93fa5eaf192c
# ╟─f5b332d0-59ad-11eb-1e93-8da5b52be991
# ╠═650c93ee-577c-11eb-02ef-3fcd1f442fda
# ╟─801ed646-59b2-11eb-23d0-03607ec04dc9
# ╠═df9ac5a8-59b2-11eb-3e09-21c5ca6d68d3
# ╠═ea212ed6-59b2-11eb-24ae-9f1a9a4da974
# ╟─07f12d6c-59b3-11eb-2efe-cd96a6ee2867
# ╠═1ef1447a-59b8-11eb-2fd8-f900fb3ce02c
# ╠═821f397a-59c8-11eb-09d2-9b8102128ca5
# ╠═239ddf2e-59b8-11eb-153d-af38e52f4a8f
# ╟─74355b96-59c8-11eb-1998-497b28294071
# ╠═11b43056-59cc-11eb-3d29-917205fe9592
# ╠═46306124-59cc-11eb-2919-97f8ced0b8bd
# ╠═105c4540-59d1-11eb-05a3-4f895c782785
# ╟─78ab3b6a-59cc-11eb-1705-273fd202ced3
# ╠═a80d9bc0-59cf-11eb-22aa-bff0f84cf6b5
# ╠═85bcf944-59cf-11eb-0834-fd898b31a776
# ╟─cbe72dd2-59d0-11eb-34fe-31533b6139f7
# ╟─fcb7e8d2-2071-11eb-020d-7bb1d53f8a6d
# ╟─094c4b94-8b57-11eb-3731-f9d63210182c
# ╟─0a39835a-8b57-11eb-3b0e-97a3dd382dbb
