### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 4828c18e-2848-11eb-1ca1-37b2524cba9f
using DifferentialEquations, Plots, DiffEqSensitivity, StatsPlots

# ╔═╡ d7a65e08-2851-11eb-0b16-5135864960e4
using CSV, DataFrames

# ╔═╡ 5e4becd6-2855-11eb-3c87-cdcf7b5a849d
using Turing, MCMCChains

# ╔═╡ 1c68799c-8be2-11eb-3f11-a1861060b86d
md"### To do list
 
We are currently working on:
 
";


# ╔═╡ 74cc60be-2821-11eb-3ad7-e581052437bd
md"""# The Ultima Online Catastrophe

[Ultima online](https://uo.com/) is a fantasy massively multiplayer online role-playing game (MMORPG) created by [Richard Garriott](https://en.wikipedia.org/wiki/Richard_Garriott) between 1995 and 1997, when it was released.

The game consisted of a medieval fantasy world in which each player could build their own character. What was interesting and disruptive was that all players interacted with each other, and what one did had repercussions on the general map. So, the game was "live" in the sense that if two people were fighting in one area and another one came in, the latter could see that fight. Also, the warriors had to hunt and look for resources to get points and improve their skills and again, if a treasure was discovered, or an animal was hunted, it would no longer be available for the rest.

During the development process of the game, Garriott and his team realized that, due to the massiveness of the game, there was going to be a moment when they would not be able to create content at the same speed as the players were consuming it. So they decided to automate the process.

After a lot of work, one of the ideas they came up with was to generate a "Virtual Ecosystem". This was a really incredible idea in which a whole ecosystem in harmony was simulated inside the game. For example, if an area started to grow grass, the herbivorous animals would come and start eating it. If many animals arrived, they would surely end up eating all the food and would have to go look for other places, it could even happen that some of them were not lucky and died on the way, starving.  In the same way, the carnivorous animals (that is, the predators of the herbivores) would strive to hunt as many animals as they could, but if in doing so they killed a significant number of them, food would become scarce causing them to die as well. In this way, as in "real" nature, a beautiful balance was generated.

But how this was even possible?

### The Lotka-Volterra model for population dynamics

To begin to understand how this complex ecosystem was created, it makes sense to go to the roots and study a dynamic system in which the interaction between a prey and a predatory population is modeled.

The idea is the same as we mentioned above. In this case, we will have a "prey" population that will have such a reproduction rate that:
"""

# ╔═╡ 39dd435a-2840-11eb-02af-cd234775c966
md"$Prey Population_{t+1} \sim PreyPopulation_{t} * BirthRate$"

# ╔═╡ 88ea0418-2840-11eb-21c7-99f98c018463
md"And a mortality rate that will be also affected by the prey population"

# ╔═╡ 23d5b9a6-2841-11eb-107f-8f9b1a0a24a4
md"$Prey Population_{t+1} \sim PreyPopulation_{t}* MortalityRate$"

# ╔═╡ 3dc55be0-2842-11eb-0b8d-6ba99bfe4d4e
md"So, calling PreyPopulation as $Prey$, Birthrate as $b_{prey}$ and Mortality rate as $m_{prey}$ for simplicity, we can write this as:"

# ╔═╡ 488ff80a-2842-11eb-216a-71ec0e4c81c6
md"""$\frac{dPrey}{dt} = Prey*(b_{prey} - m_{prey})$
"""

# ╔═╡ dbf274d6-2844-11eb-2cb3-f78a78e14d92
md"""The population at time *t* multiplies at both rates because if the population is zero there can be no births or deaths. This leads us to the simplest ecological model, in which per capita growth is the difference between the birth rate and the mortality rate. 

#### Parentheses on differential equations

Before anyone freaks out, let's talk a little bit about that strange notation.

As we said above, the prey's population will **grow** proportionally to the birth rate and the actual population. And we also said that the population will **shrink** proportional to the mortality rate and its actual population. Can you realize that we are describing **change**? 

So that is exactly what the equation is saying! You can read that horrendous $d$ as change! So, the entire term $\frac{dPrey}{dt}=$ is just saying "The change of the population over time (that's why the $dt$ term is dividing there) is equal to..." and that's it!

This can be a difficult concept to understand because we are very used to work with **absolute** values. But sometimes (In fact, very often) it is much easier to describe change over absolute values. And this is one of these cases. But, for now, let's leave this up to here, we will take it up again in the next chapter. 

#### Returning to LotkaVolterra

But the model we are looking for has to explain the *interaction* between the two species. To do so, we must include the Predator Population in order to modify the mortality rate of the Prey, leaving us with:
"""

# ╔═╡ e0f34b58-2845-11eb-0480-9d200fc79403
md"$\frac{dPrey}{dt} = Prey*(b_{prey} - m_{prey}*Pred)$"

# ╔═╡ 0da79014-2846-11eb-22b1-ed2430951f98
md"In a similar way we can think the interaction on the side of the predator, were the mortality rate would be constant and the birth rate will depend upon the Prey population:"

# ╔═╡ cd219e94-2846-11eb-294b-53ed40d7f36d
md"$\frac{dPred}{dt} = Pred*(b_{pred}*Prey - m_{pred})$"

# ╔═╡ 30e52eac-2847-11eb-3f7c-3b48e2baf012
md"In this way we obtain the Lotka-Volterra model in which the population dynamics is determined by a system of coupled ordinal differential equations (ODEs). This is a very powerful model which tells us that two hunter-prey populations in equilibrium will oscillate without finding a stable value. In order to see it, we will have to use some [SciML](https://sciml.ai/) libraries"

# ╔═╡ 2afd1060-2848-11eb-067a-1f378247d404
md"#### SciML to simulate population dynamics"

# ╔═╡ 5da9eb00-2848-11eb-0dfa-17ca0490bd44
#Let's define our Lotka-Volterra model

function lotka_volterra(du,u,p,t)
  prey, pred  = u
  birth_prey, mort_prey, birth_pred, mort_pred = p
  du[1] = dprey = (birth_prey - mort_prey * pred)*prey
  du[2] = dpred = (birth_pred * prey - mort_pred)*pred
end

# ╔═╡ 4fee10b2-2849-11eb-1d6e-e7dfd2125e64
begin
	#And make explicit our example parameters, initial value and define our problem
	p = [1.1, 0.5, 0.1, 0.2]
	u0 = [1,1]
	prob = ODEProblem(lotka_volterra,u0,(0.0,40.0),p)
end;

# ╔═╡ 7efce850-284a-11eb-144a-cdf4794703bd
sol = solve(prob,Tsit5());

# ╔═╡ a259fb62-284a-11eb-132c-9f101f8e2f2a
plot(sol)

# ╔═╡ 4aff3714-284b-11eb-2047-814ca175e07b
md"""#### Obtaining the model from the data

Back to the terrible case of Ultima Online. Suppose we had data on the population of predators and prey that were in harmony during the game at a given time. If we wanted to venture out and analyze what parameters Garriott and his team used to model their great ecosystem, would it be possible? Of course it is, we just need to add a little Bayesianism.
"""

# ╔═╡ e3da565c-2851-11eb-0fa7-a3cd80bb9d63
data = CSV.read("ultima_online_data.csv", DataFrame)

# ╔═╡ 7c5509d4-2852-11eb-1888-5b9f04ff83a5
ultima_online = Array(data)'

# ╔═╡ 9b4ba8f6-2852-11eb-0cbd-19d36ac63a62
md"Probably seeing this data in a table is not being very enlightening, let's plot it and see if it makes sense with what we have been discussing:"

# ╔═╡ 012c3bc0-2853-11eb-0b54-e728d12af1a0
begin
	time = collect(0:2:30)
	scatter(time, ultima_online[1, :], label="Prey")
	scatter!(time, ultima_online[2, :], label="Pred")
end

# ╔═╡ 6585ddce-2853-11eb-1c57-99c9afbdb616
md"Can you spot the pattern? Let's connect the dots to make our work easier"

# ╔═╡ 99dc5b7a-2853-11eb-2fbe-03a4ccd858fa
begin
	plot(time, ultima_online[1,:], label=false)
	plot!(time, ultima_online[2, :], label=false)
	scatter!(time, ultima_online[1, :], label="Prey")
	scatter!(time, ultima_online[2, :], label="Pred")
end

# ╔═╡ 067e3d8e-2854-11eb-0bbe-21361e908a3a
md"Well, this already looks much nicer, but could you venture to say what are the parameters that govern it? 
This task that seems impossible a priori, is easily achievable with the SciML engine:"

# ╔═╡ 6b783782-2857-11eb-2f38-371de1067304
u_init = [1,1];

# ╔═╡ d96267ee-2856-11eb-0cc3-4bdba4e5e8e4
@model function fitlv(data)
    σ ~ InverseGamma(2, 3)
    birth_prey ~ truncated(Normal(1,0.5),0,2)
    mort_prey ~ truncated(Normal(1,0.5),0,2)
    birth_pred ~ truncated(Normal(1,0.5),0,2)
    mort_pred ~ truncated(Normal(1,0.5),0,2)

    k = [birth_prey, mort_prey, birth_pred, mort_pred]
    prob = ODEProblem(lotka_volterra,u_init,(0.0,30),k)
    predicted = solve(prob,Tsit5(),saveat=2)

    for i = 1:length(predicted)
        data[:,i] ~ MvNormal(predicted[i], σ)
    end
end

# ╔═╡ 30c1adee-2857-11eb-04de-6fab46e4754c
model = fitlv(ultima_online);

# ╔═╡ 46f9b992-2857-11eb-2682-6d5ad3200adc
posterior = sample(model, NUTS(.6),10000); 

# ╔═╡ 3c97037a-2858-11eb-206a-57dc08cde44f
plot(posterior)

# ╔═╡ d7ff20c8-28e3-11eb-007d-bd263220eb91
md"So, our model is pretty sure that the parameters used by Garriott for the birth and death rate were around 0.8 and 0.4 for the prey population. For the prey the values were around 0.2 and 0.4. As you can see the markov chains of the sampling process are really healthy, so we can be confident that the answers we obtain are correct.

Let's stop for a second to appreciate the really complex calculation that we have just done. Until now we always made Bayesian inference in linear models that anyway required us to use complex mechanisms to be able to sample the distributions a posteriori of our parameters. 

The powerful SciML engine allows us to make Bayesian inferences but from dynamic systems of differential equations! That is, now we can get into an even higher level of complexity for our models, keeping the advantage of being able to have a quantification of the uncertainty we are working with, among other advantages that the Bayesian framework gives us.

#### Visualizing the results

As always, it is very interesting to be able to observe the uncertainty that Bayesianism provides us *within* our model. Let's go for it!

First we should make a smaller sampling of the distributions of each parameter so that the number of models we plot does not become a problem when visualizing:
"

# ╔═╡ 5b7f3688-2919-11eb-39c8-fd9c478dbf7c
begin
	birth_prey_ = sample(collect(get(posterior, :birth_prey)[1]), 100)
	mort_prey_ = sample(collect(get(posterior, :mort_prey)[1]), 100)
	birth_pred_ = sample(collect(get(posterior, :birth_pred)[1]), 100)
	mort_pred_ = sample(collect(get(posterior, :mort_pred)[1]), 100)
end;

# ╔═╡ dee1f67c-291a-11eb-11ba-7d6b7129b15c
md"And now let's solve the system of differential equations for each of the combinations of parameters that we form, saving them in *solutions* so that later we can use this array in the plotting. You can scroll left and see the solution to the 101 models we propose (Notice that we add one final model using the mean of each parameter)"

# ╔═╡ 3794d5aa-291b-11eb-1e16-31c59b6d37a2
begin
	solutions = []
	for i in 1:length(birth_prey_)
		p = [birth_prey_[i], mort_prey_[i], birth_pred_[i], mort_pred_[i]]
		problem = ODEProblem(lotka_volterra,u0,(0.0,30.0),p)
		push!(solutions, solve(problem,Tsit5(), saveat = 0.1))
	end
	
	p_mean = [mean(birth_prey_), mean(mort_prey_), mean(birth_pred_), mean(mort_pred_)]
	
	problem1 = ODEProblem(lotka_volterra,u0,(0.0,30.0),p_mean)
	push!(solutions, solve(problem1, Tsit5(), saveat = 0.1))
end

# ╔═╡ 6244beac-291e-11eb-3f26-df3907063992
md"The last step is simply to plot each of the models we generate. I also added the data points with which we infer all the model, to be able to appreciate the almost perfect fit:"

# ╔═╡ 156fce66-291c-11eb-2f95-65b806ba3fd8
begin 
	#Plotting the differents models we infer
	plot(solutions[1], alpha=0.2, color="blue")
	for i in 2:(length(solutions) - 1)
		plot!(solutions[i], alpha=0.2, legend=false, color="blue")
	end
	plot!(solutions[end], lw = 2, color="red")
	
	#Contrasting them with the data
	scatter!(time, ultima_online[1, :], color = "blue")
	scatter!(time, ultima_online[2, :], color = "orange")
	
end

# ╔═╡ 1df62c6a-29a8-11eb-2079-f17cca94ad87
md"""And that's how we get our model fitted to the data, with a powerful visualization of the uncertainty we handle.

But let's stop for a second... The title of this chapter has the word "catastrophe" in it, but we just made a beautiful graph showing a Bayesian inference about the parameters of a system of differential equations. So, what gives that terrible name to our -for now- beautiful chapter?

#### The virtual catastrophe

So far we know that Garriott and his team created a gigantic and highly complex ecological system, where the animals interacted with each other reaching natural balances.

Also, as expected when the players were included, they would hunt some animals to find resources or to defend themselves from dangerous carnivores. This was also taken into account, making the dynamic system capable of absorbing this "new" source of mortality, and reaching a balance again.

This would be the equivalent of adding a player-induced mortality rate in the prey and predators of our Lotka-volterra model:
"""

# ╔═╡ 53495618-29c0-11eb-120b-c1aacab1bd10
function lotka_volterra_players(du,u,p,t)
  #Lotka-Volterra function with players that hunt
  prey, pred  = u
  birth_prey, mort_prey, birth_pred, mort_pred, players_prey, players_pred = p

  du[1] = dprey = (birth_prey - mort_prey * pred - players_prey)*prey
  du[2] = dpred = (birth_pred * prey - mort_pred - players_pred)*pred
end

# ╔═╡ bd5e3e50-29c1-11eb-1681-3d25bf811534
mean(collect(get(posterior, :birth_prey)[1]))	

# ╔═╡ 03832436-29c2-11eb-31c6-1be2908892f4
mean(collect(get(posterior, :birth_pred)[1]))

# ╔═╡ 11e1ded2-29c2-11eb-2d76-a7536d816519
mean(collect(get(posterior, :mort_prey)[1]))

# ╔═╡ 2bffb870-29c2-11eb-06a8-5dbd9be5acc5
mean(collect(get(posterior, :mort_pred)[1]))

# ╔═╡ 3a325512-29c2-11eb-1a39-67e0ab6f5d81
md"""We will then hypothesize that the parameters chosen to model the virtual ecology were 0.8 and 0.4, and 0.2 and 0.4 for the birth and death rates of the prey and predator, respectively. 

Let's see what would happen if the players added a mortality rate of 0.4 for both animals, which would be to assume that they kill as much as the "natural" deaths that were already occurring. """

# ╔═╡ a8d8c736-29c1-11eb-08d9-6bb68a91b39c
begin
	p1 = [0.8, 0.4, 0.2, 0.4, 0.4, 0.4] 
	#These last two 0.4 are the ones we are going to attribute to the players 
	u0_ = [1,1]
	prob_players = ODEProblem(lotka_volterra_players,u0_,(0.0,30.0),p1)
end;

# ╔═╡ 3088fd2e-29c6-11eb-2496-a7ad9348a2f2
sol_players = solve(prob_players,Tsit5());

# ╔═╡ 517243c6-29c6-11eb-2547-291c993759a0
plot(sol_players)

# ╔═╡ e0b4bf28-29c6-11eb-244b-5b74ee4e6aac
md"As you can see, the players could hunt enough to double the mortality rate of both animals, and the system would still be in balance. More herbivores would be observed (because they have a higher birth rate, and there would now be fewer carnivores) and the phase - the time it takes for a full cycle of population decline and rise - would be delayed.

The creators of the game even assumed that the players would hunt mostly carnivores, because they would be rewarded with higher scores and resources (and because they would also have to defend themselves from the fierce attacks of the carnivores). The balance would be maintained anyway:"

# ╔═╡ 2522aa16-29c8-11eb-28f8-074b0ccff797
begin
	p2 = [0.8, 0.4, 0.2, 0.4, 0.4, 0.6] 
	# 0.6 player-induced mortality rate for carnivores  
	prob_players_ = ODEProblem(lotka_volterra_players,u0_,(0.0,30.0),p2)
end;

# ╔═╡ 72b871fc-29c8-11eb-2346-254791abad53
sol_players_ = solve(prob_players_);

# ╔═╡ 9b7b362c-29c8-11eb-121b-c3f6eca222ce
plot(sol_players_, legend=false)

# ╔═╡ 7bed8934-29d1-11eb-3131-5737fd4fcf32
md"However, even with all the delicate planning of more than 3 years by Garriott and his team, the entire magnificent virtual ecosystem they had built was destroyed the very second the game was launched.

What they never imagined is that the players, in the same instant that the game started, began what was the biggest mass murder ever seen in the history of video games. All the logic was exceeded. The players were not attacking the carnivores in search of high scores and resources, but were completely focused on killing any animal that crossed their path. 

The motivation was to kill, rather than logically collect resources, so strategies such as minimizing the points obtained by hunting herbivores and increasing those obtained by hunting carnivores did not work. All logic was exceeded. 

This irrationality made the mortality rate of herbivores much higher than any possible birth rate, causing the whole ecosystem to break down. Without herbivores, there was no food for carnivores...
"

# ╔═╡ a95388be-29c8-11eb-14d3-97da51f5ec1a
begin
	crazy_killer_players = [0.8, 0.4, 0.2, 0.4, 1, 0.8] 
	prob_crazy_players = ODEProblem(lotka_volterra_players,u0_,(0.0,30.0),crazy_killer_players)
end;

# ╔═╡ 97e01ccc-29c9-11eb-3634-ab23af3c4163
sol_crazy_players = solve(prob_crazy_players);

# ╔═╡ b59baa88-29c9-11eb-1645-f103a056dbca
plot(sol_crazy_players, legend=false)

# ╔═╡ 0e53ba34-29d5-11eb-3540-bbc2a0127cf5
md"This sad story ends with the whole beautiful virtual ecosystem, planned for 3 years, destroyed in seconds. The animals of the medieval world that Garriott and his team had imagined had to be eliminated... In case you want to know more about this, you can listen to the story from the mouth of the protagonist himself [here](https://www.youtube.com/watch?v=KFNxJVTJleE&ab_channel=ArsTechnica)

But like every difficult moment, this one also left great lessons. From that moment on, the games started to be tested with real people during the whole development process. The idea that you could predict the behavior of millions of players was finished, and they started to test instead. 

This was the beginning of a very Bayesian way of thinking, in which we start with a priori hypotheses that are tested with reality to modify the old beliefs, and gain a deeper understanding of what is really happening. 

It makes sense, doesn't it? After all, getting comfortable with our beliefs is never a very good option, and going out into the world to learn new things seems like a more interesting one.

### Summary

In this chapter we have learned about the usefulness of differential equations for modeling complex relationships occurring in nature, specifically the Lotka-Volterra model. We used Turing and some SciML libraries to estimate the model parameters given some data points of two species, hunter and prey, interacting with each other. Finally, we build an intuition of how the system is modified by varying the value of certain parameters.
"

# ╔═╡ a71c7d44-35a8-11eb-1bb5-858fa2666109
md"### References

- [SciML](https://sciml.ai/)
- [Turing Bayesian Differential Equation](https://turing.ml/dev/tutorials/10-bayesiandiffeq/)
- [Garriott telling the Story](https://www.youtube.com/watch?v=KFNxJVTJleE&ab_channel=ArsTechnica)"

# ╔═╡ e00277e6-8b5f-11eb-2626-3d60478516a7
md" ### Give us feedback
 
 
This book is currently in a beta version. We are looking forward to getting feedback and criticism:
  * Submit a GitHub issue **[here](https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers/issues)**.
  * Mail us to **martina.cantaro@lambdaclass.com**
 
Thank you!
"


# ╔═╡ e112c96a-8b5f-11eb-06a3-5bf82866ea17
md"
[Next chapter](https://datasciencejuliahackers.com/12_ultima_continued.jl.html)
"


# ╔═╡ Cell order:
# ╟─1c68799c-8be2-11eb-3f11-a1861060b86d
# ╟─74cc60be-2821-11eb-3ad7-e581052437bd
# ╟─39dd435a-2840-11eb-02af-cd234775c966
# ╟─88ea0418-2840-11eb-21c7-99f98c018463
# ╟─23d5b9a6-2841-11eb-107f-8f9b1a0a24a4
# ╟─3dc55be0-2842-11eb-0b8d-6ba99bfe4d4e
# ╟─488ff80a-2842-11eb-216a-71ec0e4c81c6
# ╟─dbf274d6-2844-11eb-2cb3-f78a78e14d92
# ╟─e0f34b58-2845-11eb-0480-9d200fc79403
# ╟─0da79014-2846-11eb-22b1-ed2430951f98
# ╟─cd219e94-2846-11eb-294b-53ed40d7f36d
# ╟─30e52eac-2847-11eb-3f7c-3b48e2baf012
# ╟─2afd1060-2848-11eb-067a-1f378247d404
# ╠═4828c18e-2848-11eb-1ca1-37b2524cba9f
# ╠═5da9eb00-2848-11eb-0dfa-17ca0490bd44
# ╠═4fee10b2-2849-11eb-1d6e-e7dfd2125e64
# ╠═7efce850-284a-11eb-144a-cdf4794703bd
# ╠═a259fb62-284a-11eb-132c-9f101f8e2f2a
# ╟─4aff3714-284b-11eb-2047-814ca175e07b
# ╠═d7a65e08-2851-11eb-0b16-5135864960e4
# ╠═e3da565c-2851-11eb-0fa7-a3cd80bb9d63
# ╠═7c5509d4-2852-11eb-1888-5b9f04ff83a5
# ╟─9b4ba8f6-2852-11eb-0cbd-19d36ac63a62
# ╠═012c3bc0-2853-11eb-0b54-e728d12af1a0
# ╟─6585ddce-2853-11eb-1c57-99c9afbdb616
# ╠═99dc5b7a-2853-11eb-2fbe-03a4ccd858fa
# ╟─067e3d8e-2854-11eb-0bbe-21361e908a3a
# ╠═5e4becd6-2855-11eb-3c87-cdcf7b5a849d
# ╠═6b783782-2857-11eb-2f38-371de1067304
# ╠═d96267ee-2856-11eb-0cc3-4bdba4e5e8e4
# ╠═30c1adee-2857-11eb-04de-6fab46e4754c
# ╠═46f9b992-2857-11eb-2682-6d5ad3200adc
# ╠═3c97037a-2858-11eb-206a-57dc08cde44f
# ╟─d7ff20c8-28e3-11eb-007d-bd263220eb91
# ╠═5b7f3688-2919-11eb-39c8-fd9c478dbf7c
# ╟─dee1f67c-291a-11eb-11ba-7d6b7129b15c
# ╠═3794d5aa-291b-11eb-1e16-31c59b6d37a2
# ╟─6244beac-291e-11eb-3f26-df3907063992
# ╠═156fce66-291c-11eb-2f95-65b806ba3fd8
# ╟─1df62c6a-29a8-11eb-2079-f17cca94ad87
# ╠═53495618-29c0-11eb-120b-c1aacab1bd10
# ╠═bd5e3e50-29c1-11eb-1681-3d25bf811534
# ╠═03832436-29c2-11eb-31c6-1be2908892f4
# ╠═11e1ded2-29c2-11eb-2d76-a7536d816519
# ╠═2bffb870-29c2-11eb-06a8-5dbd9be5acc5
# ╟─3a325512-29c2-11eb-1a39-67e0ab6f5d81
# ╠═a8d8c736-29c1-11eb-08d9-6bb68a91b39c
# ╠═3088fd2e-29c6-11eb-2496-a7ad9348a2f2
# ╠═517243c6-29c6-11eb-2547-291c993759a0
# ╟─e0b4bf28-29c6-11eb-244b-5b74ee4e6aac
# ╠═2522aa16-29c8-11eb-28f8-074b0ccff797
# ╠═72b871fc-29c8-11eb-2346-254791abad53
# ╠═9b7b362c-29c8-11eb-121b-c3f6eca222ce
# ╟─7bed8934-29d1-11eb-3131-5737fd4fcf32
# ╠═a95388be-29c8-11eb-14d3-97da51f5ec1a
# ╠═97e01ccc-29c9-11eb-3634-ab23af3c4163
# ╠═b59baa88-29c9-11eb-1645-f103a056dbca
# ╟─0e53ba34-29d5-11eb-3540-bbc2a0127cf5
# ╟─a71c7d44-35a8-11eb-1bb5-858fa2666109
# ╟─e00277e6-8b5f-11eb-2626-3d60478516a7
# ╟─e112c96a-8b5f-11eb-06a3-5bf82866ea17
