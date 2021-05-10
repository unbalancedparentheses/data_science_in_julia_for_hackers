### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ fa3ab76e-5413-11eb-36f1-e5117d887fc7
begin
	using DifferentialEquations, DiffEqSensitivity, StatsPlots
	using Plots
	gr()
end

# ╔═╡ 7751b42a-5435-11eb-379e-217bd01097fc
begin
	using OrdinaryDiffEq
	using ModelingToolkit
	using DataDrivenDiffEq
	using LinearAlgebra, Optim
	using DiffEqFlux, Flux
end

# ╔═╡ 2139fac8-4ec7-11eb-1625-bf9aab9b1c2c
md"""# Letting the computer do science

Let's think a little. What do you think is the process by which scientific discoveries are made? 

First, you have some situation or event of interest from which you want to discover the rules that govern it. Second, you carefully design the experiments to get as much unbiased data as you can. Third, you analyze that data to gain some knowledge and, hopefully, you can begin to write some equations that condense the underling process. Finally, you keep doing experiments to confirm that the equations you have invented are correct. You are doing science, my friend!

Throughout the book, we were learning a wide variety of statistical methods that sought to be as general as possible, but that required us to define the model to be used. The equations, then, were already defined and the algorithm only had to find the best parameters (or distribution of them) to fit that model to the data. 

But what if I tell you that now we can start "talking" with the computer. That we can ask the computer to learn the model itself with the data. Not the parameters. But the equations that govern the process generating the data we give to the computer. Even more, that now we can "share" some incomplete knowledge that we have of some process and ask the computer to learn, with minimun data, the part of the knowledge that we lack. What? Is that even posible? Let´s see.   

## The language of science

In order to start understanding if that farytale is possible, first we need to understand the ways we have to "encoding" the dynamics of those processes. As [Steven Strogatz](http://www.stevenstrogatz.com/) said "Since Newton, mankind has come to realize that the law of physics are always expressed in the language of differential equations". And we can argue that it is a language that not only belongs to physics, but to all science and, in general, to the world in which we live. 

But before any of you run off in fear, let's demystify this subject a little. What is a differential equation and why are them useful?

Well the first thing to denote is that differential equations emerge whenever it´s easier to describe **change** than **absolute** values. As we saw in the Ultima Online Catastrophe, it is much easier to describe and define why populations grow or shrink, rather than explain why they have the particular absolute values in a particular point in time. Come on! it´s much more easy to comprehend that if there are lots of predators, the prey´s population will shrink than understand why there are, for example, 223,543 prays and 112,764 predators the 6 of may. Does this make sense?

$\frac{dPrey}{dt} = Prey*(b_{prey} - m_{prey}*Pred)$

$\frac{dPred}{dt} = Pred*(b_{pred}*Prey - m_{pred})$

Remember that *d* can be read as change and the hole expresion "$\frac{dPrey}{dt} =$" is just saying "The change of Prey´s population over time is equal to ..." and the other part, as we already saw in the last chapter, is answering "hey! that change is proportional to the Prey´s population (because they reproduce) and to the *interaction* with the Predator population, that contributes to the Prey´s mortality rate". Isn´t that beautiful? 

Now, try to think a way to put the *absolute* values of each population over time into equations. Have any clue? No? As we said, *change* is much easier to decribe.

Or you can take a much more familiar example: In Newtonian Mechanics motion is describe in terms of Force.

$F = m*a$

But Force determines acceleration, which itself is a statement about *change*. We are so familiar with that equation that we tend to forget that it **is** a differential equation (and as Steven mention, is the mother of all differential equations).

$F = m*\frac{dVelocity}{dt}$

$F = m*\frac{d^2Position}{dt^2}$

This transformation is just showing something that everyone already knows: Acceleration is the change of Velocity over time, and Velocity is the change of position over time. And that implies that Acceleration is the *second* derivative (change) on position over time.

We just learned that the language of differential equations is fundamental for doing science. So, if we want the computer to learn equations that explain scientific events, it must need to know how to deal with this type of equations. And this is easily solved by the Scientific Machine Learning ([SciML](https://sciml.ai/)) ecosystem.

## Scientific Machine Learning for model discovery

But dealing with differential equations is not the main thing that SciML has to offer us. Istead it give us the way to **do** science in cooperation **with** the artificial intelligence. What?? To be able to comprehen this, let´s rewiew how "classic" machine learning works.

It turns out that an neural network is *literally* a function. Is a function in the sense that it takes a bunch of numbers, applies a series of transformations, and return another bunch of numbers:

$f(x) = y <=> ANN(x) = y$

So, Artificial Neural Networks are functions. But they are especial function, as they can *change* the connections that made the specific function they represent. They do this in a process called *training* where they adjust its connections (parameters) in order to correctly predict. So, with only one neural network, we can "represent" lots of functions. What's more, there is this *Universal Approximation Theorem* that says that a neural network that is deep and wide enough (that is, has enough parameters) can approximate **any** function. You only need to feed it with enough data, so it can learn the optimal set of weights for its parameters.

This is why neural networks come hand in hand with big data: you need lot of data in order to let the neural network learn the correct weights. But there is a problem: Big data cost billions, or may not even be available! (if you don't believe me, ask the Large Hadron Collider scientists to run 1 million experiments to train a NN, I'm sure they'll be happy to help you :P)

Can you imagine a way to drastically reduce the data needed to train the NN in a significant way? Well, how about *incorporating* scientific knowledge into machine learning?. If we think it for a moment, we can realize that a scientific model is worth a thousand datasets. The equations works like a proxy of thousand of experiments, people investigating, years of research. in other words: tons of data. 

So if we create a way to inform all of that precious data, so it can focus in learning an specific part of the equation (some part that we don´t know), it could do it with a minimum quantity of data! Lucky us, [Christopher Rackauckas](https://github.com/ChrisRackauckas) and his team already found a way.

The concept about we are talking is called "Universal Differential Equations". Let´s use them to recover some missing equation components from the Virtual Catastrophe from the last chapter!

### Looking for the catastrophe culprit

So lets imagine again (yes, we imagine lots of things in this book) that we are [Richard Garriott](https://en.wikipedia.org/wiki/Richard_Garriott) a day before the release of his game. He was tuning the last details of his virtual ecosystem. The model is simple but powerful, and ready to go:

$\frac{dPrey}{dt} = Prey*(b_{prey} - m_{prey}*Pred) = Prey*(1.3 - 0.9*Pred)$

$\frac{dPred}{dt} = Pred*(b_{pred}*Prey - m_{pred}) = Pred*(0.8*Prey - 1.8)$

So after a delicate tuning, he determines that the best parameters for his virtual ecosystem are:

$b_{prey} = 1.3$
$m_{prey} = 0.9$
$b_{pred} = 0.8$
$m_{pred} = 1.8$

He smiles and happily goes to sleep, thinking that tomorrow is the big day.

Let´s see how were the system equilibrium that he decided. 

"""

# ╔═╡ 247a6e7e-5417-11eb-3509-3d349198ec43
begin
#The Lotka-Volterra model Garriot define for Ultima Online

function lotka_volterra(du,u,p,t)
  prey, pred  = u
  birth_prey, mort_prey, birth_pred, mort_pred = p
	
  du[1] = dprey = (birth_prey - mort_prey * pred)*prey
  du[2] = dpred = (birth_pred * prey - mort_pred)*pred
end
	
p0 = Float32[1.3, 0.9, 0.8, 1.8]
u0 = Float32[0.44249296,4.6280594]

prob_ = ODEProblem(lotka_volterra,u0,(0.0,40.0),p0)

end;

# ╔═╡ c64260e8-5417-11eb-2c5e-df8a41e3c0b5
sol = solve(prob_,Tsit5());

# ╔═╡ e776e5cc-5417-11eb-3754-55e9a04d9c99
plot(sol)

# ╔═╡ 5243b7b8-5418-11eb-031a-3bc8932730c5
md"""So the system seems in complete equilibrium.

### The infamous day begins.

And finally we arrive at the day when the madness begins.

Garriot wakes up early, doesn´t have any breakfast and goes to meet his team. Everything is ready. The countdown start: 3, 2, 1... And the game is online, running.

After the champagne, hugs and a little celebration Garriot returns to work and starts to analyze the metrics to see if everything is alright, and it does. He relax a little bit until something calls his attention: The curves of carnivorous and herbivorous animals are a little different than they should be. There are still **too few points** (only four hours from the release) to be alarmed, but he decides to do a deeper analysis. Luckily, a few days ago, he had read a paper on the Universal ODEs, so he thinks they can help him in this case.
"""

# ╔═╡ 3bb32294-5423-11eb-1c75-27dc2f242255
function lotka_volterra_players(du,u,p,t)
    #Lotka-Volterra function with players that hunt
	#Of course, Garriot doesn´t know about this new players part of the equation. 
	#He only saw some differences in the real curve vs the one he expected.
	
    birth_prey, mort_prey, birth_pred, mort_pred, players_prey, players_pred = p

    du[1]  = (birth_prey - mort_prey * u[2] - players_prey)*u[1]
    du[2]  = (birth_pred * u[1] - mort_pred - players_pred)*u[2]
end

# ╔═╡ 5940efe4-5423-11eb-027d-4fa9af65fab9
begin
tspan = (0.0f0,4.0f0)
p_ = Float32[1.3, 0.9, 0.8, 1.8, 0.4, 0.4]
prob = ODEProblem(lotka_volterra_players, u0,tspan, p_)
solution = solve(prob, Vern7(), abstol=1e-12, reltol=1e-12, saveat = 0.1)
end;

# ╔═╡ 8de32f8c-5423-11eb-24c6-5be06370cb3f
begin
scatter(solution, alpha = 0.25, title="The data Garriot was seeing")
plot!(solution, alpha = 0.5)
end

# ╔═╡ 21a71ea2-5426-11eb-34cc-ffa4656278ac
begin
expected_prob = ODEProblem(lotka_volterra, u0,tspan, p0)
expected_solution = solve(expected_prob, Vern7(), abstol=1e-12, reltol=1e-12, saveat = 0.1)
end;

# ╔═╡ 5d5c55a0-5426-11eb-0e93-27e67f42dc8e
begin
scatter(expected_solution, alpha = 0.25, title="The data Garriot was expecting to see")
plot!(expected_solution, alpha = 0.5)
end

# ╔═╡ d1854f4c-5432-11eb-0b97-bfa7c03dc941
md"""As you can see, the animals were taking more time to recover. The *period* of the cycle was longer than ir should be: A clear sing that something were killing them.
But he wanted to be sure. The Universal ODEs were key to do so.

So, he start thinking "I know that the model has to be running cause I can see it in the code! So maybe, something external is producing this divergence. Something that I don´t know. But something that a *Neural Network* could find out" Let´s see """

# ╔═╡ f7df46d0-5434-11eb-0ca4-8351f558b138
begin
X = Array(solution)	
#And let´s add some noise to make it more difficult. Why? Because its fun!	
Xₙ = X + Float32(1e-3)*randn(eltype(X), size(X))
end

# ╔═╡ 557c43da-5435-11eb-2e62-8fc988c6cc7a
begin
# Define the neueral network which learns L(x, y, y(t-τ))
L = FastChain(FastDense(2, 32, tanh),FastDense(32, 32, tanh), FastDense(32, 2))
p = initial_params(L)

function dudt_(u, p,t)
    prey, pred = u
    z = L(u,p)
    [p_[1]*prey - p_[2]*prey*pred + z[1],
    -p_[4]*pred + p_[3]*prey*pred + z[2]]
end
end

# ╔═╡ a0b0497a-5436-11eb-0bad-f564c6033968
md"""
So lets stop for a minute to analize the code that Garriot just propose.

In the first two lines, he just define the Neural Network that is going to learn the missing components of the two equations (one for the dynamics of the Pray and other for the dynamics of the Predator) and fill the variable p with its untrained parameters.

Then, he is defining the Universal Differential Equation. Where he is specifying the parts of the model that he knows, and adding a Neural Network to learn others things that might be happening (and we know that indeed **were** happening). In other words, he is proposing:

$\frac{dPrey}{dt} = Prey*(1.3 - 0.9*Pred) + ANN_1(prey, pred)$

$\frac{dPred}{dt} = Pred*(0.8*Prey - 1.8) + ANN_2(prey, pred)$

So, as we already know, he is just adding a **function**. Which one? We already know that those are $Prey*players_{prey}$ and $Pred*players_{pred}$ (and $players_{pred}=players_{prey}=0.4$), but Garriot doesn´t, and is exactly what the Neural Network is going to learn for him.

"""

# ╔═╡ 14377ea6-5444-11eb-3c70-c319fd48119a
begin
	prob_nn = ODEProblem(dudt_,u0, tspan, p)
	sol_nn = solve(prob_nn, Tsit5(), u0 = u0, p = p, saveat = solution.t)
end;

# ╔═╡ 20ca18fe-5449-11eb-2a59-839edec5d0cc
begin
plot(solution)
plot!(sol_nn, title="The untrained NN is far from the real curve")
end

# ╔═╡ e35c05ac-5445-11eb-2f6d-d7785cac5672
function predict(θ)
    Array(solve(prob_nn, Vern7(), u0 = u0, p=θ, saveat = solution.t,
                         abstol=1e-6, reltol=1e-6,
                         sensealg = InterpolatingAdjoint(autojacvec=ReverseDiffVJP())))
end

# ╔═╡ 14453c92-5446-11eb-3c54-ef42a9852046
function loss(θ)
    pred = predict(θ)
    sum(abs2, Xₙ .- pred), pred 
end

# ╔═╡ 853efea0-5447-11eb-3dfe-954e9722ddfb
begin
	
const losses = []

#just adding a callback to supervise the network´s learning
callback(θ,l,pred) = begin
    push!(losses, l)
    if length(losses)%50==0
        println("Current loss after $(length(losses)) iterations: $(losses[end])")
    end
    false
end
	
end

# ╔═╡ afafd092-5447-11eb-0514-9da00c6d4aeb
md"And lets train the NN!!"

# ╔═╡ c3027938-5447-11eb-2cdb-99753d146a6e
# First train with ADAM for better convergence
res1 = DiffEqFlux.sciml_train(loss, p, ADAM(0.01), cb=callback, maxiters = 200);

# ╔═╡ d84d16c2-5447-11eb-0caf-6d099ef176a7
# Train with BFGS
res2 = DiffEqFlux.sciml_train(loss, res1.minimizer, BFGS(initial_stepnorm=0.01), cb=callback, maxiters = 10000);

# ╔═╡ d9ec41a0-5448-11eb-09f9-ffbb2a896a64
# Plot the losses
plot(losses, yaxis = :log, xaxis = :log, xlabel = "Iterations", ylabel = "Loss")

# ╔═╡ 03e26dea-5449-11eb-38dc-957ea73db154
begin
# Neural network guess
L̂ = L(Xₙ,res2.minimizer)
# Plot the data and the approximation
NNsolution = predict(res2.minimizer)
# Trained on noisy data vs real solution
plot(solution.t, NNsolution')
plot!(solution.t, X', title="The trained NN have fitted well")
end

# ╔═╡ 58a1294c-544c-11eb-27ca-8512bc3d5461
md"""Nice! Now that we have our Neural Network already learned the **Input-Output** relation in order to the entire system behave as the data Garriot were seeing in that Infamous morning, we need to transform that Input-Output behaviour into some function. We do this in order to *gain* interpretability of what may be happening and, in a scientific frame, learn the underling model. We do this by creating a [Function Space](https://en.wikipedia.org/wiki/Function_space) in order to the NN learn which function (or linear combination of those) is the best one to describe that Input-Output relation. The loss function to do so is designed in a way that the result will be the least complex one, that is, the answer will be the simplest function that behave like the NN.
"""

# ╔═╡ b38b9410-544e-11eb-220b-5746f897b5f4
begin
## Sparse Identification 

# Create a Basis
@variables u[1:2]
# Lots of polynomials
polys = Operation[1]

for i ∈ 1:5
    push!(polys, u[1]^i)
    push!(polys, u[2]^i)
    for j ∈ i:5
        if i != j
            push!(polys, (u[1]^i)*(u[2]^j))
            push!(polys, u[2]^i*u[1]^i)
        end
    end
end
	
end

# ╔═╡ d58d6d84-544e-11eb-17b8-91723456fc15
begin
# And some other stuff
h = [cos.(u)...; sin.(u)...; polys...]
basis = Basis(h, u)
	
h
end

# ╔═╡ 5a6dcdc8-5451-11eb-2a2f-cbc4f35844c0
basis

# ╔═╡ 23be1198-5451-11eb-07b7-e76b21ff565a
md"So, as you can see above, we just created a **Function Space** of 29 dimensions. That space include *every* possible [linear combination](https://en.wikipedia.org/wiki/Linear_combination#:~:text=From%20Wikipedia%2C%20the%20free%20encyclopedia,a%20and%20b%20are%20constants) of each dimension. And we are going to ask to SINDy to give us the simplest function that shows the same Input-Output behaviour the Neural Network just learned.

Without saying more, let's do it!"

# ╔═╡ 9de34578-5452-11eb-14cb-d5d1cdb91e63
begin
# Create an optimizer for the SINDy problem
opt = SR3()
# Create the thresholds which should be used in the search process
λ = exp10.(-7:0.1:3)
# Target function to choose the results from; x = L0 of coefficients and L2-Error of the model
g(x) = x[1] < 1 ? Inf : norm(x, 2)
	
Ψ = SINDy(Xₙ[:, 2:end], L̂[:, 2:end], basis, λ,  opt, g = g, maxiter = 10000, normalize = true, denoise = true)
end

# ╔═╡ 6fc293fa-5453-11eb-0965-e917ffac7340
Ψ.equations[1]

# ╔═╡ afe5bf5e-5456-11eb-1a8b-911da79f528e
Ψ.equations[2]

# ╔═╡ b722e5ec-5456-11eb-3ae3-0b849ec39a4c
md"""OMG! The equations were perfectly restored! You can read this as:

$ANN_1(prey, pred) = p_1*u_1 = p_1*Prey$

$ANN_2(prey, pred) = p_2*u_2 = p_2*Pred$

$\frac{dPrey}{dt} = Prey*(1.3 - 0.9*Pred) + p_1*Prey = Prey*(1.3 - 0.9*Pred + p1)$

$\frac{dPred}{dt} = Pred*(0.8*Prey - 1.8) + p_2*Pred = Pred*(0.8*Prey - 1.8 + p2)$

So, Remembering that we define the data Garriot was seeing as:

$\frac{dPrey}{dt} = Prey*(1.3 - 0.9*Pred - players_{prey})$

$\frac{dPred}{dt} = Pred*(0.8*Prey - 1.8 - players_{pred})$

And that we also define that $players_{prey} = players_{pred} = 0.4$, the recover parameter from de NN **should** $-0.4$. Does it makes sense?

Lets ask for the parameters then:
"""

# ╔═╡ 0a14775c-5457-11eb-24a6-13ed65f9eae3
parameters(Ψ)

# ╔═╡ 2241f33a-5457-11eb-0edf-3f7ef29075bc
md"""So, the parameters are a bit off. But now that we have the equations restored, we can run another SINDy to gain much more accuracy:"""

# ╔═╡ 520b2d00-5457-11eb-349f-3bec665738fd
begin
unknown_sys = ODESystem(Ψ)
unknown_eq = ODEFunction(unknown_sys)

# Just the equations
b = Basis((u, p, t)->unknown_eq(u, [1.; 1.], t), u)

# Retune for better parameters -> we could also use DiffEqFlux or other parameter estimation tools here.
Ψf = SINDy(Xₙ[:, 2:end], L̂[:, 2:end], b, STRRidge(0.01), maxiter = 100, convergence_error = 1e-18)
end

# ╔═╡ fef7edba-54dd-11eb-3025-35fe9ffae6ac
parameters(Ψf)

# ╔═╡ fe88958e-54e5-11eb-12bc-01ad625d85c5
md"So we recover the equations and its parameters with an outstanding acurracy. And that is even more incredible if we remember that we did this with a **minimum** of data."

# ╔═╡ e6ec4364-54eb-11eb-1bf6-83db426cd32f
md"After seeing that, Garriot took a big deep breath. He immediately understood what was going on. The players were mass killing the animals. He called his team and start planning the strategy to face this, not knowing that already was a lost cause...  "

# ╔═╡ aac56d4e-54e7-11eb-2d8a-1f21c386ef8d
md"""### References

* [Universal Differential Equations for Scientific Machine Learning Paper](https://arxiv.org/abs/2001.04385)

* [Universal Differential Equations - Christopher Rackauckas](https://github.com/ChrisRackauckas/universal_differential_equations)
"""

# ╔═╡ Cell order:
# ╟─2139fac8-4ec7-11eb-1625-bf9aab9b1c2c
# ╠═fa3ab76e-5413-11eb-36f1-e5117d887fc7
# ╠═247a6e7e-5417-11eb-3509-3d349198ec43
# ╠═c64260e8-5417-11eb-2c5e-df8a41e3c0b5
# ╠═e776e5cc-5417-11eb-3754-55e9a04d9c99
# ╟─5243b7b8-5418-11eb-031a-3bc8932730c5
# ╠═3bb32294-5423-11eb-1c75-27dc2f242255
# ╠═5940efe4-5423-11eb-027d-4fa9af65fab9
# ╠═8de32f8c-5423-11eb-24c6-5be06370cb3f
# ╠═21a71ea2-5426-11eb-34cc-ffa4656278ac
# ╠═5d5c55a0-5426-11eb-0e93-27e67f42dc8e
# ╟─d1854f4c-5432-11eb-0b97-bfa7c03dc941
# ╠═7751b42a-5435-11eb-379e-217bd01097fc
# ╠═f7df46d0-5434-11eb-0ca4-8351f558b138
# ╠═557c43da-5435-11eb-2e62-8fc988c6cc7a
# ╟─a0b0497a-5436-11eb-0bad-f564c6033968
# ╠═14377ea6-5444-11eb-3c70-c319fd48119a
# ╠═20ca18fe-5449-11eb-2a59-839edec5d0cc
# ╠═e35c05ac-5445-11eb-2f6d-d7785cac5672
# ╠═14453c92-5446-11eb-3c54-ef42a9852046
# ╠═853efea0-5447-11eb-3dfe-954e9722ddfb
# ╟─afafd092-5447-11eb-0514-9da00c6d4aeb
# ╠═c3027938-5447-11eb-2cdb-99753d146a6e
# ╠═d84d16c2-5447-11eb-0caf-6d099ef176a7
# ╠═d9ec41a0-5448-11eb-09f9-ffbb2a896a64
# ╠═03e26dea-5449-11eb-38dc-957ea73db154
# ╟─58a1294c-544c-11eb-27ca-8512bc3d5461
# ╠═b38b9410-544e-11eb-220b-5746f897b5f4
# ╠═d58d6d84-544e-11eb-17b8-91723456fc15
# ╠═5a6dcdc8-5451-11eb-2a2f-cbc4f35844c0
# ╟─23be1198-5451-11eb-07b7-e76b21ff565a
# ╠═9de34578-5452-11eb-14cb-d5d1cdb91e63
# ╠═6fc293fa-5453-11eb-0965-e917ffac7340
# ╠═afe5bf5e-5456-11eb-1a8b-911da79f528e
# ╟─b722e5ec-5456-11eb-3ae3-0b849ec39a4c
# ╠═0a14775c-5457-11eb-24a6-13ed65f9eae3
# ╟─2241f33a-5457-11eb-0edf-3f7ef29075bc
# ╠═520b2d00-5457-11eb-349f-3bec665738fd
# ╠═fef7edba-54dd-11eb-3025-35fe9ffae6ac
# ╟─fe88958e-54e5-11eb-12bc-01ad625d85c5
# ╟─e6ec4364-54eb-11eb-1bf6-83db426cd32f
# ╟─aac56d4e-54e7-11eb-2d8a-1f21c386ef8d