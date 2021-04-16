### A Pluto.jl notebook ###
# v0.12.2

using Markdown
using InteractiveUtils

# ╔═╡ 07eb1de4-1888-11eb-1839-7b588f633065
begin 
	using Images
	im_1 = load("./images/trajectory.png")
end

# ╔═╡ 0f132432-1869-11eb-3a5f-038fe65a919c
begin
using Plots
using Turing
using StatsPlots
end

# ╔═╡ 8b60ead6-187a-11eb-1993-558456e7d356
md"# Escaping from Mars!

Suppose you landed on Mars by mistake and you want to leave that rocky planet and return home. To escape from a planet you need a very important piece of information: the escaping velocity from the planet. 

What on Mars is the escape velocity?


We are going to use the same experiment that Newton thought when thinking about escaping from the gravity of Earth. Gravity pulls us down, so if we shoot a cannonball, as in the sketch shown below, what will happen? For some velocities, the cannonball will return to Earth, but there's a velocity at which it scapes since the gravitational pull is not enough to bring it back to the surface. That velocity is called **escape velocity**."

# ╔═╡ 972d18fe-1acc-11eb-0b4f-4d1fdc1a4d2c
begin 
	im_0 = load("./images/cannonball_.png")
	#img_small = imresize(im_0, ratio=1/3)

	
end

# ╔═╡ 9e309302-1ada-11eb-3bb0-f90dbdea8bb9
md"To simplify, we approximate the escape velocity as:

$v_{escape}=\sqrt{2*g_{planet}*r_{planet}}$

where *r* is the radius of the planet and *g* the constant of gravity at the surface. Suppose that we remember from school that the velocity of scape from Earth is $11\frac{km}{s}$ and that the radius of Mars if half of the earth's. "

# ╔═╡ b92e1dfa-1acb-11eb-3aae-a90766806c63
md"
We remember that the gravity of Earth at its surface is $9.8\frac{m}{s^2}$, so all we need to estimate the escape velocity of Mars is the gravity of the planet at its surface. So we decide to make an experiment and gather some data. But what exactly do you need to measure? Let's see.
"

# ╔═╡ b54dec82-1883-11eb-0a61-313724e1a335
md"We are going to calculate the constant $g_{mars}$ just throwing stones. We are going to explain a bit the equations regarding the experiment. The topic we need to revisit is *Proyectile Motion*. "

# ╔═╡ 424b96de-1884-11eb-06fe-032b13ea20eb
md" ## Proyectile Motion"

# ╔═╡ 4aa3534c-1884-11eb-0c30-e387db85affe
md" Gravity pulls us down to Earth, or in our case, to Mars. This means that we have an acceletation, since there is a force. Recalling the newton equation:

$\overrightarrow{F} = m * \overrightarrow{a}$
 where *m* is the mass of the object, $\overrightarrow{F}$ is the force(it's what make us fall) and $\overrightarrow{a}$ is the acceleration, in our case is what we call gravity $\overrightarrow{g}$. The arrow $\overrightarrow{}$ over the letter means that the quantity have a direction in space, in our case, gravity is pointing to the center of the Earth, or Mars.

*How can we derive the motion of the stones with that equation?*

In the figure below we show a sketch of the problem: We have the 2 axis, *x* and *y*, the *x* normally is parallel to the ground and the *y* axis is perpendicular, pointing to the sky. We also draw the initial velocity $v_0$ of the proyectile, and the angle $\theta$ with respect to the ground. Also it's important to notice that the gravity points in the opposite direction of the *y* axis."

# ╔═╡ 677b95c2-1888-11eb-18be-0de8ca145819
md" *But what are the trayectory of the proyectile? and how the coordinates *x* and *y* evolve with time?*

If we remember from school, the equations of *x* and *y* over time is: 
"

# ╔═╡ 1b1054a2-1888-11eb-030c-eb8400485617
md"
$x(t) = v_0*t*cos(θ)$

$y(t) = v_0*t*sin(θ) -\frac{g*t^2}{2}$"

# ╔═╡ b590c3a2-188a-11eb-1e4f-39df9e837c1e
md"where $t$ is the time at which we want to know the coordinates.

*What the equations tell us?*

If we see the evolution of the projectile in the *x* axis only, it follows a straight line (until it hits the ground) and in the *y* axis the movement follows a parabola, but how we interpret that? 

We can imagine what happens if we trow a stone to the sky: the stone starts to go up and then, at some point, it reaches the highest position it can go. Then, the stone starts to go down. 

*How does the velocity evolve in this trajectory?*

Since the begining, the velocity starts decreasing until it has the value of 0 at the highest point, where the stone stops for a moment, then it changes its direction and start to increase again, pointing towards the ground. Ploting the evolution of the height of the stone, we obtain the plot shown below.  We see that, at the begining the stone starts to go up fast and then it slows down. We see that for each value of *y* there are 2 values of *t* that satisfies the equation, thats because the stone pass twice for each point, except for the highest value of *y*."

# ╔═╡ a7a85d46-1938-11eb-08a0-89db330ff595
begin 
	im_3 = load("./images/img90_.png")
end

# ╔═╡ 1fec143a-1942-11eb-39da-199d7106c3f2
md"So, in the example we ahve just explained, we have that the throwing angle is θ=90°, so sin(90°)=1, the trajectory in *y* becomes:"

# ╔═╡ 6b3f00d0-1942-11eb-3b05-e58cdfb0684c
md"
$y(t) = v_0*t -\frac{g*t^2}{2}$"

# ╔═╡ 87865fce-1942-11eb-202d-37905d0b0bfc
md" And the velocity, which is the derivative of the above equation becomes: "


# ╔═╡ 9988dd44-1942-11eb-20f7-2f168e4fafc1
md"$v_{y}(t) = v_{0} -g*t$

Those two equations are the ones plotted in the previous sketch, a parabola and a straight line that decreases with time."


# ╔═╡ 2606d934-1947-11eb-3b59-7d8982c70a2a
md" It's worth to notice that at each value *y* of the trajectory, the velocity could have 2 values, just differing in its sign, meaning it can has 2 directions, but with the same magnitude. *So keep in mind that when you throw an object to the sky, when it returns to you, the velocity will be the same with the one you threw it.*"

# ╔═╡ ca26b694-1d14-11eb-27ec-dd65c1decce8
md"## Calculating the constant g of Mars"

# ╔═╡ a26eaa4c-1938-11eb-1e8c-a1e95af7fe04
md"Now that we have understood the equations we will work with, we ask:

*how do we set the experiment and what do we need to measure?*

The experiment set up will go like this:
- One person will be throwing stones with an angle.
- The other person will be far, watching from some distance, measuring the time since the other throw the stone and it hits the ground. The other measurement we will need is the distance Δx the stone travelled.
- Also, for the first iteration of the experiment, suppose we only keep the measurements with and initial angle θ~45° (we will loosen this constrain in a bit). 
"

# ╔═╡ 55fbe884-1882-11eb-1136-3f32a8e9e7d8
begin 
	im = load("./images/sketch_2.png")
end

# ╔═╡ 05917a0c-194b-11eb-0f57-b59592b84943
md"Suppose we did the experiment and we have measured then the 5 points, Δx and Δt, shown below:"

# ╔═╡ 49184b70-194b-11eb-3630-5dcbb941f1d3
Δx_measured = [25.94, 38.84, 52.81, 45.54, 17.24]

# ╔═╡ 7eebe662-194b-11eb-1d7c-138e738b9b28
t_measured = [3.91, 4.57, 5.43, 4.85, 3.15]

# ╔═╡ 745b181c-194b-11eb-031b-b39abb04e353
md"*Now, how we estimate the constant g from those points?*

Using the equations of the trajectory, when the stone hits the ground, y(t) = 0, since we take the start of the *y* coordinate in the ground (negleting the initial height with respect to the maximum height), so finding the other then the initial point that fulfill this equation, we find that:

$t_{f} = \frac{2*v_{0}*sin(θ)}{g}$

where $t_{f}$ is the time at which the stone hits the ground, the time we have measured."

# ╔═╡ a0ae111e-194e-11eb-2bff-419e2f86a8b6
md"And replacing this time in the x(t) equation we find that:

$Δx=t_{f}*v_{0}*cos(θ)$

where Δx is the distance traveled by the stone.
"

# ╔═╡ 00385e50-194f-11eb-18f7-9f511dd55256
md" So, solving for $v_{0}$m, the initial velocity, an unknown quantity, we have:

$v_{0}=\frac{Δx}{t_{f}cos(θ)}$
"

# ╔═╡ 8e38f6a6-194f-11eb-29a2-ad835ecc8580
md"Then replacing it in the equation of $t_{f}$ and solving for $\Delta x$ we obtain:

$Δx=\frac{g*t_{f}^2}{2*tg(θ)}$
"

# ╔═╡ 1048b23c-1951-11eb-0040-0d17e5c05670
md"So, the model we are going to propose is a **linear regression**. A linear equation has the form:

$y=m*x +b$

where *m* is the slope of the curve and *b* is called the intercept. In our case, if we take *x* to be $\frac{t_{f}^2}{2}$, the slope of the curve is g and the intercep is 0. So, in our linear model we are going to propose that each point in the curve is:

$\mu = m*x + b$

$y \sim Normal(\mu,\sigma^2)$

So, what this says is that each point of the regresion is drawn from a gaussian distribution with its center correnponding with a point in the line, as shown in the plot below."

# ╔═╡ f64badec-1a12-11eb-19a6-8db5a0f7de03
begin 
	im_4 = load("./images/line_.png")
end

# ╔═╡ 7a7cbe9c-1a15-11eb-1453-27607b90fa9a
md" So, our linear model will be:

$g \sim Distribution\_to\_be\_proposed()$
$\mu[i] = g*\frac{t_{f}^2[i]}{2}$
$\Delta x[i]= Normal(\mu[i],\sigma^2)$

"

# ╔═╡ 15913052-1a16-11eb-3c85-5d9f5c40a4bb
md"Where *g* has a distribution we will propose next. The first distribution we are going to propose is a *Uniform distribution* for g, between the values of 0 and 10"

# ╔═╡ f5623f04-1a17-11eb-1d92-4ff256b15332
begin
plot(Uniform(0,10),xlim=(-1,11), ylim=(0,0.2), legend=false, fill=(0, .5,:lightblue))
title!("Uniform prior distribution for g")
xlabel!("g_mars")
ylabel!("Probability")
end

# ╔═╡ 65bd4262-1a18-11eb-1c46-2561bbdb7297
md"Now we define the model in Turing and sample from the posterior distribution."

# ╔═╡ b1c26356-1a0c-11eb-3257-bb441670d40f
begin
@model gravity_uniform(t_final, x_final, θ) = begin
    # The number of observations.
	g ~ Uniform(0,10)
	μ = g .* (t_final.*t_final./2)
		
	N = length(t_final)
    for n in 1:N
			x_final[n] ~ Normal(μ[n], 10)
	    end
end;
end

# ╔═╡ b3d511d4-1a0c-11eb-213a-9dc628b75d5d
begin
iterations = 10000
ϵ = 0.05
τ = 10
end;

# ╔═╡ de2c1e8c-1a0c-11eb-281d-cfd0e038f61d
begin
θ = 45
chain_uniform = sample(gravity_uniform(t_measured, Δx_measured, θ), HMC(ϵ, τ), iterations, progress=false);
end;

# ╔═╡ 8197a7de-1a18-11eb-34f5-69527c179e4f
md"Plotting the posterior distribution for p we that the values are mostly between 2 and 5, with the maximun near 3,8. Can we narrow the values we obtain?"

# ╔═╡ bcaa8d3e-1a0c-11eb-0118-d59af31cc354
begin
	histogram(chain_uniform[:g], xlim=[1,6], legend=false, normalized=true)
	xlabel!("g_mars")
	title!("Posterior distribution for g with uniform distribution")
end

# ╔═╡ 9769da36-1a19-11eb-21ec-63f612b19380
md"As a second obtion, we can propose a *Gaussian distribution* instead of a uniforn distribution for *g*, like the one shown below, with a mean of 5 and a variance of 2, and let the model update its beliefs with the points we have."

# ╔═╡ bb570a5e-1a19-11eb-26ca-0dd1a523dc5d
begin
plot(Normal(5,2), legend=false, fill=(0, .5,:lightblue))
title!("Normal prior distribution for g")
xlabel!("g_mars")
ylabel!("Probability")
end

# ╔═╡ f61779cc-1a1b-11eb-02ae-9332216c7760
md" We define then the model with a gaussian distribution as a prior for *g*:"

# ╔═╡ 950c347a-1952-11eb-2bef-1fd9c4223209
begin
@model gravity_normal(t_final, x_final, θ) = begin
    # The number of observations.
	N = length(t_final)
	g ~ Normal(6,2)
	μ = g .* (t_final.*t_final./2)
		
    for n in 1:N
			x_final[n] ~ Normal(μ[n], 3)
	    end
end;
end

# ╔═╡ ef7350d2-19f0-11eb-1ffa-9991926d4dd9
md"Now we sample values from the posterior distribution and plot and histogram with the values obtained:"

# ╔═╡ ea26e290-1952-11eb-2459-19bc54917685
begin
chain_normal = sample(gravity_normal(t_measured, Δx_measured, θ), HMC(ϵ, τ), iterations, progress=false);
end;

# ╔═╡ fcdda73e-1952-11eb-01dc-83bb0830da47
begin
	histogram(chain_normal[:g], xlim=[3,4.5],legend=false, normalized=true)
	xlabel!("g_mars")
	title!("Posterior distribution for g with Normal distribution")

end

# ╔═╡ 73734d22-1953-11eb-0b03-7dda4b7d450d
md"We see that the plausible values for the gravity have a clear center in 3.7 and now the distribution is narrower, that's good, but we can do better.

If we observe the prior distribution proposed of *g*, we see that some values are negative, which has no sense because if that would the case when you trow the stone, it would go up and up, escaping from the planet. 

We propose then a new model for not allowing the negative values to happen. The distribution we are interested in is a LogNormal distribution. In the plot below is the prior distribution for g, a LogNormal distribution with mean 1.5 and variance of 0.5."

# ╔═╡ 7b5a92a8-19f7-11eb-027a-c9c04f88b6dc
begin
plot(LogNormal(1,0.5), xlim=(0,10), legend=false, fill=(0, .5,:lightblue))
title!("Prior LogNormal Distribution for g")
ylabel!("Probability")
xlabel!("g")
end

# ╔═╡ 69235290-1a20-11eb-0dfd-77c64ba4b78b
md"The model *gravity_lognormal* defined below has now a LogNormal prior. We sample the posterior distribution after updating with the data measured."

# ╔═╡ faf37432-19fc-11eb-3bfe-534cdbd6102d
begin
@model gravity_lognormal(t_final, x_final, θ) = begin
    # The number of observations.
	N = length(t_final)
	g ~ LogNormal(0.5,0.5)
	μ = g .* (t_final.*t_final./2)
    for n in 1:N
			x_final[n] ~ Normal(μ[n], 3)
	end
end;
end

# ╔═╡ 736ec5da-19fc-11eb-038a-15db3980fa42
begin
chain_lognormal = sample(gravity_lognormal(t_measured, Δx_measured, θ), HMC(ϵ, τ), iterations, progress=false);
end;

# ╔═╡ 944976d0-19fc-11eb-22ad-8d8d33b55d7c
begin
	histogram(chain_lognormal[:g], xlim=[3,4.5], legend=false, normalized=true)
		xlabel!("g_mars")
	title!("Posterior distribution for g with LogNormal distribution")

end

# ╔═╡ 156381ee-1a22-11eb-28bb-d9f8ae75bc39
md"## Optimizing the throwing angle"

# ╔═╡ f816003a-1a23-11eb-2124-e59991aa0e5e
md"Now that we have a good understanding of the equations and the overall problem, we are going to add some difficulties and we will loosen a constrain we have imposed: Suppose that the device employed to measure the angle has an error of 15°, no matter the angle. 

*We want to know what are the most convenient angle to do the experiment and to measure or if it doesn't matter.*"

# ╔═╡ 730d6e62-1a25-11eb-09cd-4133b7f6c59a
md"To do the analysis we need to see how the angle influence the computation of *g*, so solving the equation for *g* we have:

$g = \frac{2*tg(\theta)*\Delta x}{t^{2}_f}$
"

# ╔═╡ c32ae204-1ab5-11eb-0600-ab56ad81dad2
md"We can plot then the tangent of θ, with and error of 15° and see what is its maximum and minimun value:"

# ╔═╡ 430ac8b8-1ab6-11eb-0a54-710704913cd8
begin
angles = 0:0.1:70
error = 15/2
μ = tan.(deg2rad.(angles))
ribbon = tan.(deg2rad.(angles .+ error)) - μ
plot(angles, μ, ribbon=ribbon, color="lightblue", legend=false)
ylabel!("tan(θ)")
xlabel!("θ [deg]")
title!("tan(θ) and its error")
end

# ╔═╡ 7fcc0952-1d21-11eb-3d4b-079bf2e35934
md"But we don't care about the absolute value of the error, we want the relavite error, so plotting the percentual error we have:"

# ╔═╡ efcdbdd8-1ab8-11eb-0dc8-f531dc2623af
begin
er= tan.(deg2rad.(angles .+ error)) .- tan.(deg2rad.(angles .- error))
perc_error = er .* 100 ./ μ
plot(angles, er .* 100 ./ μ, xlim=(5,70), ylim=(0,200), color="lightblue", legend=true, lw=3, label="Percentual error")
vline!([angles[findfirst(x->x==minimum(perc_error), perc_error)]], lw=3, label="Minimum error")
ylabel!("Δtan(θ)/θ")
xlabel!("θ [deg]")
title!("Percentual error")
end

# ╔═╡ 5ee992ac-1abf-11eb-130a-d50b32ce707c
md"So, now we see that the lowest percentual error is obtained when we work in angles near 45°, so we are good to go and we can use the data we measured adding the error in the angle."

# ╔═╡ fe1996b6-1ac0-11eb-0f46-230fdebf0395
md"We now define the new model, where we include an **uncertainty in the angle**. We propose an *Uniform prior* for the angle centered at 45°, the angle we think the measurement was done."

# ╔═╡ a24746ca-1ac1-11eb-044a-4dc162d82062
begin
@model gravity_angle_uniform(t_final, x_final, θ) = begin
    # The number of observations.
	error = 15
	angle ~ Uniform(45-error/2, 45 + error/2)
	g ~ LogNormal(log(4),0.3)
	μ = g .* (t_final.*t_final./(2 * tan.(deg2rad(angle))))
		
	N = length(t_final)
    for n in 1:N
			x_final[n] ~ Normal(μ[n], 10)
	    end
end;
end

# ╔═╡ 0bd63e34-1ac2-11eb-3120-2da6ed463b0c
begin
chain_uniform_angle = sample(gravity_angle_uniform(t_measured, Δx_measured, θ), HMC(ϵ, τ), iterations, progress=false);
end;

# ╔═╡ 1a6181fc-1ac2-11eb-125d-31fe76288708
begin
	histogram(chain_uniform_angle[:g], legend=false, normalized=true)
	xlabel!("g_mars")
	ylabel!("Probability")
	title!("Posterior distribution for g, including uncertainty in the angle")
end

# ╔═╡ abcfe840-1ae0-11eb-01bb-e1f7f6576c47
md"### Calculating the escape velocity"

# ╔═╡ c45349a2-1ae0-11eb-3f6e-ebb0e02c01f2
md"Now that we have calculated the gravity, we are going to calculate the escape velocity. 

*What data do we have until now?*

we know from the begining that:

$R_{Earth}\approxeq 2R_{Mars}$
$g_{Earth}\approxeq 9.8$

and we have also computed the distribution of the plausible values of $g_{Mars}$.

So, replacing them in the equation of the escape velocity:

$\frac{v_{Mars}}{v_{Earth}} =\sqrt{\frac{g_{Mars}*R_{Mars}}{g_{Earth}*R_{Earth}}}$

so,

$\frac{v_{Mars}}{11} =\sqrt{\frac{g_{Mars}*2*\cancel{R_{Mars}}}{9.8*\cancel{R_{Mars}}}} \qquad \left[\frac{km}{s} \right]$

$v_{Mars} =11 * \sqrt{\frac{g_{Mars}}{9.8*2}} \qquad \left[\frac{km}{s} \right]$
"

# ╔═╡ fcf260ce-1ae3-11eb-28a4-556a8fbd5335
begin
	v = 11 .* sqrt.(chain_uniform_angle[:g] ./ (9.8*2))
	histogram(v, legend=false, normalized=true)
	title!("Escape velocity from Mars")
	xlabel!("Escape Velocity of Mars [km/s]")
	ylabel!("Probability")
	
end

# ╔═╡ 22ea7608-1ae5-11eb-0e4d-b15d79ea5b59
md"Finally, we obtained the escape velocity scape from Mars."

# ╔═╡ 37847564-186a-11eb-399a-c1023c4ea7ed
v0 = [10, 12, 14, 13, 8]; #m/s

# ╔═╡ Cell order:
# ╟─8b60ead6-187a-11eb-1993-558456e7d356
# ╟─972d18fe-1acc-11eb-0b4f-4d1fdc1a4d2c
# ╟─9e309302-1ada-11eb-3bb0-f90dbdea8bb9
# ╟─b92e1dfa-1acb-11eb-3aae-a90766806c63
# ╟─b54dec82-1883-11eb-0a61-313724e1a335
# ╟─424b96de-1884-11eb-06fe-032b13ea20eb
# ╟─4aa3534c-1884-11eb-0c30-e387db85affe
# ╟─07eb1de4-1888-11eb-1839-7b588f633065
# ╟─677b95c2-1888-11eb-18be-0de8ca145819
# ╟─1b1054a2-1888-11eb-030c-eb8400485617
# ╟─b590c3a2-188a-11eb-1e4f-39df9e837c1e
# ╟─a7a85d46-1938-11eb-08a0-89db330ff595
# ╟─1fec143a-1942-11eb-39da-199d7106c3f2
# ╟─6b3f00d0-1942-11eb-3b05-e58cdfb0684c
# ╟─87865fce-1942-11eb-202d-37905d0b0bfc
# ╟─9988dd44-1942-11eb-20f7-2f168e4fafc1
# ╟─2606d934-1947-11eb-3b59-7d8982c70a2a
# ╟─ca26b694-1d14-11eb-27ec-dd65c1decce8
# ╟─a26eaa4c-1938-11eb-1e8c-a1e95af7fe04
# ╟─55fbe884-1882-11eb-1136-3f32a8e9e7d8
# ╟─05917a0c-194b-11eb-0f57-b59592b84943
# ╠═49184b70-194b-11eb-3630-5dcbb941f1d3
# ╠═7eebe662-194b-11eb-1d7c-138e738b9b28
# ╟─745b181c-194b-11eb-031b-b39abb04e353
# ╟─a0ae111e-194e-11eb-2bff-419e2f86a8b6
# ╟─00385e50-194f-11eb-18f7-9f511dd55256
# ╟─8e38f6a6-194f-11eb-29a2-ad835ecc8580
# ╟─1048b23c-1951-11eb-0040-0d17e5c05670
# ╟─f64badec-1a12-11eb-19a6-8db5a0f7de03
# ╟─7a7cbe9c-1a15-11eb-1453-27607b90fa9a
# ╟─15913052-1a16-11eb-3c85-5d9f5c40a4bb
# ╟─f5623f04-1a17-11eb-1d92-4ff256b15332
# ╟─65bd4262-1a18-11eb-1c46-2561bbdb7297
# ╠═0f132432-1869-11eb-3a5f-038fe65a919c
# ╠═b1c26356-1a0c-11eb-3257-bb441670d40f
# ╠═b3d511d4-1a0c-11eb-213a-9dc628b75d5d
# ╠═de2c1e8c-1a0c-11eb-281d-cfd0e038f61d
# ╟─8197a7de-1a18-11eb-34f5-69527c179e4f
# ╟─bcaa8d3e-1a0c-11eb-0118-d59af31cc354
# ╟─9769da36-1a19-11eb-21ec-63f612b19380
# ╟─bb570a5e-1a19-11eb-26ca-0dd1a523dc5d
# ╟─f61779cc-1a1b-11eb-02ae-9332216c7760
# ╠═950c347a-1952-11eb-2bef-1fd9c4223209
# ╟─ef7350d2-19f0-11eb-1ffa-9991926d4dd9
# ╟─ea26e290-1952-11eb-2459-19bc54917685
# ╟─fcdda73e-1952-11eb-01dc-83bb0830da47
# ╟─73734d22-1953-11eb-0b03-7dda4b7d450d
# ╟─7b5a92a8-19f7-11eb-027a-c9c04f88b6dc
# ╟─69235290-1a20-11eb-0dfd-77c64ba4b78b
# ╠═faf37432-19fc-11eb-3bfe-534cdbd6102d
# ╠═736ec5da-19fc-11eb-038a-15db3980fa42
# ╟─944976d0-19fc-11eb-22ad-8d8d33b55d7c
# ╟─156381ee-1a22-11eb-28bb-d9f8ae75bc39
# ╟─f816003a-1a23-11eb-2124-e59991aa0e5e
# ╟─730d6e62-1a25-11eb-09cd-4133b7f6c59a
# ╟─c32ae204-1ab5-11eb-0600-ab56ad81dad2
# ╟─430ac8b8-1ab6-11eb-0a54-710704913cd8
# ╟─7fcc0952-1d21-11eb-3d4b-079bf2e35934
# ╟─efcdbdd8-1ab8-11eb-0dc8-f531dc2623af
# ╟─5ee992ac-1abf-11eb-130a-d50b32ce707c
# ╟─fe1996b6-1ac0-11eb-0f46-230fdebf0395
# ╠═a24746ca-1ac1-11eb-044a-4dc162d82062
# ╠═0bd63e34-1ac2-11eb-3120-2da6ed463b0c
# ╟─1a6181fc-1ac2-11eb-125d-31fe76288708
# ╟─abcfe840-1ae0-11eb-01bb-e1f7f6576c47
# ╟─c45349a2-1ae0-11eb-3f6e-ebb0e02c01f2
# ╠═fcf260ce-1ae3-11eb-28a4-556a8fbd5335
# ╟─22ea7608-1ae5-11eb-0e4d-b15d79ea5b59
# ╟─37847564-186a-11eb-399a-c1023c4ea7ed
