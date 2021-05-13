### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# ╔═╡ ca9a04c0-1567-11eb-39f6-3fac127be101
begin
using Plots

a_ = 5000
c_ = -0.5
P_ = 1:100
Q_ = a_.*(P_.^c_)

plot(P_, Q_, legend=false, title="Quantity vs Price model")#: $Q=aP^c$")
xlabel!("Price")
ylabel!("Quantity")
end

# ╔═╡ 2f0d4ada-156f-11eb-094d-dff28b630402
using Turing

# ╔═╡ 82d4d8a4-156f-11eb-16af-41dd2d739186
begin
using StatsPlots

plot(-10:0.01:10,Cauchy(), xlim=(-10,10),label="Cauchy(0,1)")
plot!(Normal(), xlim=(-10,10), label="Normal(0,1)")
end

# ╔═╡ 39b6c758-8be0-11eb-30cb-7d7442920974
md"### To do list
 
We are currently working on:
 
";


# ╔═╡ 5f171c4c-1567-11eb-0d69-f116e79738b5
md"# Overview

In a bayesian framework we can work intrinsically with the uncertainty of the data. It allows us to include it in our models. This is especially beneficial when we want to make a decision based on the results of a model. In this type of problem, if we optimize the expected value of the function we want to maximize, we obtain just a number, losing all the information and richness uncertainty can give us.

In real-life scenarios, when making decisions we almost never have all the necessary information and therefore we have to deal with uncertainty. So it's important to be able to take into account how certain we are of the information we have. It may be the case that the value that maximizes (or minimizes) certain problem comes with a lot of uncertainty so it would be more appropriate to choose other with a better optimization-uncertainty trade off.

Bayesian inference allows us to do this because of its approach of a statistical problem. From its point of view, the data obtained on an event is fixed. They are observations that have already happened and there is nothing stochastic about it. So the data is deterministic.

On the contrary, the parameters of the models we propose to describe such data are stochastic, following a given probability distribution. In this way, the inference that is made is on the complete distributions of our parameters, which allows us, precisely, to include the uncertainty into our models."

# ╔═╡ b53fe140-1567-11eb-134b-39d6066eb06d
md"## Optimal pricing

---------------
Pricing a product is not an easy task. Multiple factors intervene in a customer's decision to buy a product. Also, a price can be fixed for some unknown business' decision. Now suppose you have a new product you want to introduce in the local market and you need to set a price for it. Also, as a businessman, you want to have the maximum profit.

If the kind of product you intend to produce were already in the market, you could use this information to have an initial guess. If the price is too high, you probably won't sell much. Conversely, if it’s too low, you probably sell more, but since the production process has an associated cost, you have to be careful and take it into account when you do the math.

### Price vs Quantity model

We are going to use a known equation to model the relationship between price of a product and the quantity demanded, the equation (1). The figure 1 shows its behavior for some value of *a* and *c*. This equation tells us that the higher the price, the less we sell, and  if we continue raising the price, eventually our product it's so expensive that nobody is interested."

# ╔═╡ 821ba35e-1568-11eb-3a08-f988ebc1b1e3
md"You can imagine this as when you buy a luxury bread at the bakery: 

In the beginning, if the price of this bread is very low, you will surely buy many of them, even giving some away so that others can try them. If one day you wake up and see that the price of this tasty bread is now double, you will surely stop buying too much and just concentrate on having it for a nice breakfast. Now, if a couple of months later the bakery became famous thanks to its delicious bread and they decided to sell it five times more expensive than before, you would start looking for another bakery.

#### Power law distributions

Okay, so we agree that our model has to express that as the price goes up the quantity tends to go down. However, one could ask why use a decreasing exponential function and not another one, for example a linear relationship with a negative slope. 

The answer to this question is not straightforward. To start building an intuition, we must think about how people's income is distributed. 

Surely many of you have the main idea: income is not distributed equally across the population. 

In general, a few people concentrate most of the income, and only a little of the income is distributed in the majority of the population. The distributions that describe this phenomenon are called 'power laws'. The best known is perhaps the Pareto distribution or 80-20 distribution. A distribution widely used in business management referring to the fact that, for example, 20% of the mix of products sold are those that generate 80% of the profits. 

In economics this idea is presented with the Lorenz curve:"

# ╔═╡ c8cbd94e-1569-11eb-27b2-513b849460eb
begin
function lorenz(y)  
	n = length(y)
    y = sort(y)
    s = zeros(n + 1)
    s[2:end] = cumsum(y)
    cum_people = zeros(n + 1)
    cum_income = zeros(n + 1)
    for i in collect(1: (n ))
        cum_people[i] = i / n
        cum_income[i] = s[i] / s[n]
	end
    return cum_people, cum_income
end
	
w = exp.(randn(100))

f_vals, l_vals = lorenz(w)
	
plot(f_vals, label="Lorenz curve",l_vals, l=3,xlabel="Cumulative population", xaxis=0:0.1:1)
plot!(f_vals, label="Perfect equality", f_vals, l=3, ylabel="Cumulative income",yaxis=0:0.1:1)
end

# ╔═╡ 0d3fe04c-1570-11eb-2fd7-c5a366cbc13f
md"*Lorenz curve. A graphical representation of income inequality.*"

# ╔═╡ 1247d9d6-156a-11eb-35d2-d9264c933280
md"In this graph, the x-axis represents the accumulated population and the y-axis the accumulated income. Going from left to right and as you move along the x-axis, more and more income is accumulated by fewer people. For example, the first 10% of the population barely accumulates 1% of income while the richest 10% on the right accumulates 40%. An ideal society with a perfectly distributed income would have a straight 45º Lorenz curve.

With this in mind we can already generate an intuition that will help us answer the initial question: why use a decreasing exponential and not a negative-slope line?

Well, since a great majority of people have a small relative income and a minority has a large one, as we increase the price of the product, a large number of people with low income can no longer afford it. This process continues until only people with a high income are left and their consumption preferences are not greatly affected by the price increase.

The exponential distribution is useful to describe this.

### Price elasticity of demand

A very important factor to consider is the price elasticity of demand of the product in question. What does this mean? It relates how much the quantity demanded by customers of a product changes when its price is changed by one unit.

Mathematically, price elasticity is defined as:

$e_{(p)}=\frac{dQ/Q}{dP/P}$    

For example, the price elasticity of demand of a medicine for a terminal illness is not the same as that of chocolate with peanuts.

While some might argue that chocolate is vital for their life, the difference between these two products is that users of the medicine cannot afford not to consume it. No matter how much the price increases, the nature of their need forces them to buy it anyway. It is said then that the medicine is inelastic, that is, it is not sensitive to price."

# ╔═╡ 888f8de8-156a-11eb-27f4-698b94d26234
begin
	a__ = 500
	c__ = -0.05
	P__ = 1:100
	Q__ = a__.+ c__.*P__
	
	plot(P__, Q__, legend=false, ylims = (400,550))
	xlabel!("Price")
	ylabel!("Quantity")
end

# ╔═╡ 15c0f7be-156c-11eb-1c9d-8b473d8f7d7f
md"*Inelastic demand of an important medicine. As it is vital for life the price hardly affects the quantity demanded*"

# ╔═╡ ee449794-156c-11eb-04e9-89c9258ea95d
md"On the contrary, if we see that the price of chocolates goes up a lot, we will probably stop consuming it, since it is not vital for our health. Well, that's relative."

# ╔═╡ 6c11796c-156d-11eb-0d7d-fda4ca4f50eb
begin
	a___ = 500
	c___ = -0.9
	P___ = 1:100
	Q___ = a___.*(P___.^c___)
	
	plot(P___, Q___, legend=false)
	xlabel!("Price")
	ylabel!("Quantity")
end

# ╔═╡ efe7fb74-156f-11eb-1d4e-c32b49970387
md"*Possible demand curve for non chocolate lovers. As the price goes up the quantity goes down a lot.*"

# ╔═╡ a1e9eb50-156d-11eb-0224-d93a772766c9
md"Perhaps you are wondering the importance of being able to have clarity about the elasticity of a product. To explain it, let's remember how the sales (in money) we get when trading a product are calculated:

$Sales = Quantity * Price$"

# ╔═╡ d9f8435c-156d-11eb-1044-b7a799dc2401

md"So it is vitally important to analyze how much one variable varies when moving the other.

It is evident that in the case of inelastic goods, it is always convenient to raise the price in terms of increasing the profit. On the other hand, when we work with a good that has some kind of elasticity, the increase generated by setting a higher price can be offset by an even greater drop in the amount sold. So we have to understand very well that behavior in order to define the optimal price level.

#### Dealing with uncertanty

Anyway, if our product is a new idea, the problem depicted above gets a lot more complicated if the product is brand new, an invention, and the approach it's different. That's the problem we are about to solve:

Suppose you are about to release a completely new and disrupting product. Your product is so different that you don't have others to compare with, at least in the local market, so you are not sure about what price to choose. You don't want to lose money of course, so you want the maximum profit you could get. To test the waters, a common choice is to run a pilot test, offering your product at different prices and see how customers react. So you record how much you sell at what price, but how do we proceed?

Now, given the model and the data available, we define it 

So, given our exponential model to describe the relationship between the price of a good and the quantity demanded, We want to estimate its parameters:"


# ╔═╡ f4484e86-156e-11eb-1c2a-d9a9f13a25aa
md"
$Q = aP^{c}$

In order to do this, an intelligent strategy is to linearize the relationship in order to perform a simple linear regression. Simply taking the logarithm of both sides of the equation achieves the goal:

$log(Q)=log(a) + clog(P)$

Now, the only thing left to do is to define the model in a bayesian framework for Julia, called Turing, which is used to do probabilistic programming."

# ╔═╡ 0ccc8cce-156f-11eb-370d-d31a19ae38db
begin
	@model function quantity(qval,p0)
	loga ~ Cauchy()
	c ~ Cauchy()
	logμ0_ = loga .+ c*(log.(p0) .- mean(log.(p0)))
	μ0_ = exp.(logμ0_)
	for i in eachindex(µ0_)
		qval[i] ~ Poisson(μ0_[i])
	end
end
end

# ╔═╡ 47780236-156f-11eb-1f12-4fb312e8c3c3
md"How do we interpret this model?

#### Priors: our previous knowledge

Remember that Bayesian models always ask us to choose previous distributions for their parameters. In this particular example we propose that *log a* and *c* follow a Cauchy distribution. *Why did we do this?* Basically they are very flat distributions that are going to leave a lot of freedom for the model to learn from the data what the value of the parameters are. "

# ╔═╡ d6ca0448-156f-11eb-363f-7363cfd89f9c
md"*Normal and Cauchy distributions. The Cauchy distribution is said to be fat tailed as it allows for extreme values*"

# ╔═╡ e2b3b394-156f-11eb-3a1e-2b5b13db8e03
md"""Is doing this the best choice? Definitely not. Having the possibility to choose the previous distributions allows us to introduce previous knowledge to our problem. For example, if you were doing a linear regression to find the relationship between people's weight and their height, you could already "tell" the model that it would not make sense for the relationship to be negative, that is, it does not seem right to affirm that as a person weighs more, he or she would be shorter.

Another very important use of priors is to define the scale of the problem. In the example of height and weight it would be useful to say something like 'It doesn't make sense that for every additional kilogram of weight, a person will measure one meter more. At most a few centimeters'. All this information can be communicated to our model through the priors we choose. Let's leave it there for now.

Returning to the code. Julia allows us to easily define the variables that are probability distributions using the ~ operator. Once we know *c* and *log a* for a given value of price, we can univocally determine the quantity, therefore the variables $\log(\mu_0)$ (and $\mu_0$) are defined with the = operator, indicating a deterministic relation. 

In addition, since the quantity of product sold is a discrete one and it comes from adding independent purchases, they are modeled as a poisson distribution.

But why do we subtract the mean for the price values?  It's a good practice to avoid a common problem: multicollinearity. With multicollinearity, the models tend to be more certain about the plausible values of our model, meanwhile models with more normalized data are more conservative and they are less prone to overfitting, an unwanted effect we need to avoid if we expect our model to work good with new. As a rule of thumb, it is always good to standardize our data. That is, subtract their average and divide each by its standard deviation.

#### Updating our beliefs

In our problem, we said we have already recorded some points of the curve for our product. And to do it we simply run the pilot test, fixing a price and counting the amount of product we sold. We can infer employing this data the “demand curve”, then we can propose a profit function for the new product and finally find the price that maximizes our profit. In figure 2 we plot the points recorded in the pilot test. At first sight they seem to follow the expected relationship but it is not a perfect curve, right? They have some kind of "noise". Well, after all we could say that the reality is noisy."""

# ╔═╡ 785a8984-1570-11eb-3b51-131d970de8d3
begin
	#Our points from the pilot test
	Price = [1500, 2500, 4000, 5000] 
	Quantity = [590, 259, 231, 117]
	
	scatter(Price, Quantity, markersize=6, color="orange", legend=false, xlim=(1000,6000), ylim=(0,1100))
	xlabel!("Price")
	ylabel!("Quantity")
end

# ╔═╡ 80bd1d26-1572-11eb-0966-7d68095843e2
md"As we said, in a bayesian framework our previous knowledge are the distributions we propose for each of the parameters and the relationship known between price and quantity.

With this bayesian approach, our previous knowledge are the distributions we propose for each of the parameters and the relationship known between price and quantity. What we do now is to update our believes, incorporating in our model the data points we have recoded from our pilot test as show in the code bellow, instantiating our model with the points *Quantity* and *Price*. Our model now has computed what is called the *posterior distributions* for the parameters *log a* and *c*, our updated beliefs for the plausible values for this two parameters."

# ╔═╡ d3b37d5c-1572-11eb-31b8-cde9ffaa91c0
begin
	model = quantity(Quantity, Price)
	posterior = sample(model, NUTS(),1000)
end;

# ╔═╡ a10644ee-1573-11eb-2ac0-b511c0333c19
begin
	post_loga = collect(get(posterior, :loga))
	post_c = collect(get(posterior, :c))
	
	hist_loga = histogram(post_loga, normed=true, bins=20, label = false, xlabel="log a")
	hist_c = histogram(post_c, normed=true, legend=false, bins=20, xlabel="c")
	plot(hist_loga, hist_c, layout=(1,2))
end

# ╔═╡ d779e92c-1573-11eb-1089-2d728a5d1691
md"*Posterior distributions for the parameters log a and c.*"

# ╔═╡ 02207a56-1574-11eb-0436-67fe6b08448d
md"Let's stop for a moment and analyze this. We defined our model and asked Turing to return the best possible estimate of our parameters, taking into account our initial beliefs and the information obtained from the pilot test, and what Turing returned was a distribution of possibilities for those parameters.

But, our model is defined by a single value of a and c. So what do we do? One option would be to take the mean of our distributions."

# ╔═╡ 0fcff67e-1574-11eb-150b-27c1c36fd7c4
mean(post_loga[1])

# ╔═╡ 16aa6662-1574-11eb-3c7b-072455b11d30
mean(post_c[1])

# ╔═╡ 1c6fd97e-1574-11eb-18e0-7fb1cc959de4
md"So Log(a) would be 5.55 and c -1.18, and we should only have to replace those values in our model equation to get the answer to our problem:"

# ╔═╡ 4dd96e64-1574-11eb-3f78-1541470c0e77
md"""$ Log(Q)=5.55 - 1.18Log(P) $


This would make sense? Not even close. By doing this we would be throwing away a lot of precious information that the Bayesian framework gives us: The uncertainty about our inference.

#### Making uncertainty our ally

Instead of getting rid of the uncertainty of our measurements, we have to use them to our advantage. This way instead of keeping only one model, we will use all possible models that can be built having the distributions of their parameters. That is, to sample our parameter distributions and build different models with each combination of them. Let's see it:"""

# ╔═╡ 66d56e52-1574-11eb-09eb-c73670c14ce5
begin
p = range(1000,9000,step = 10);
q = zeros(length(p),length(post_c[1]))

for i in collect(1:length(post_c[1]))
	q[:,i] = exp.(post_loga[1][i] .+ post_c[1][i] .* (log.(p) .- mean(log.(Price))))
end
end

# ╔═╡ 7cf67c6e-1574-11eb-3953-cd88073b6879
md"Here we are creating an array of as many rows as price values we want to observe and with as many columns as samples we have of each of our log and c parameters, that is, as many columns as models we have at our disposal. Let's plot them all and see what happen:"

# ╔═╡ 855ae83e-1574-11eb-2b2a-5b6371a7f110
begin
	plot(p,q[:,1], xlim=(1000,6000))
	for i in collect(1:length(post_c[1]))
		plot!(p,q[:,i], color="blue", legend=false, alpha = 0.1)
	end
	plot!(p, mean(q, dims=2), color="red", lw=2)
	scatter!(Price, Quantity, color="orange", markersize=5)
	ylabel!("Quantity")
	xlabel!("Price")
end

# ╔═╡ a897e75c-1574-11eb-2114-8bcf7ae98708
md"In this way we can visualize all the possible models that our Bayesian inference gives us. Since values of *log a* and *c* with higher probability will be sampled more often, the density of lines give us a sense of plausibility, and therefore we can evaluate the certainty (or uncertainty) of our model for a given value of price. We also highlight in red the average quantity obtained taking into account all the different models.

As a last check (even if we have already taken preventive measures), we want to make sure that our model parameters do not share information. That is, we want to check that there is no collinearity between them.

To evaluate multicollinearity between the two parameters of our model, we plot the sampled values, one against the other. In figure 4, we don't see a pattern, they seem to be decorrelated, therefore multicollinearity is not present in our model, so we are good to go and we can continue with the problem."

# ╔═╡ b758edd6-1574-11eb-2fe3-218ddec7fd26
begin
scatter(post_loga, post_c, legend=false)
xlabel!("log a")
ylabel!("c")
end

# ╔═╡ cb02af4a-1574-11eb-1816-a5bcdf070365
md"*Parameters c vs log a for sampled values from the posterior distributions.*

As you can see, the point cloud is well dispersed so multicollinearity is not going to be a problem for us."

# ╔═╡ dddad9d8-1574-11eb-2453-c5f2176e95c9
md"## Maximizing profit

Now that we have estimated our posterior distributions, we will try to answer the following question: what is the price that will give us the maximum profit? 

This is why we calculated the relationship between the price and the quantity of our product. As we said before, depending on that relation, it was going to be possible to define an optimal price point. Now we only have to add one more part to the equation: the production costs. 

Having this, we will be able to set up our profit function that will tell us, for each price we choose, how much money we would expect to earn. So let's define it:

As many of you know, the profit on the sale of a product is calculated as income minus costs.

$Profit=Price * Quantity - Cost$

But also the cost can be divided between the one that doesn't depend on the production and I always have, and the one that does. 

For example, the costs of renting the warehouse, the salaries of the administrative workers or the insurance will not vary if 3000 or 5000 units are produced. This is why they are called **fixed costs**. On the other hand, the costs of raw materials, packaging or distribution; if they depend on the quantity produced, so they are included in **variable costs**.

$Profit=Price * Quantity - (VariableCost * Quantity + Fixed Cost)$
"

# ╔═╡ ef793db0-1574-11eb-00d0-5d58783e847e
begin
fixed_cost = 10000
k = 700
var_cost = k .* q
total_cost = var_cost .+ fixed_cost
profit = p .* q .- total_cost
end;

# ╔═╡ 3e4c3122-1575-11eb-2d55-8191bc945fa2
md"Now we can plot the profit for many sampled values from the posterior distributions of our model and find the maximum."

# ╔═╡ 4bffbd34-1575-11eb-0922-9f00ae5cde7f
mxval, mxindx = findmax(mean(profit, dims=2); dims=1);

# ╔═╡ b732ab66-1575-11eb-3bbc-8187854383b1
begin
using LaTeXStrings
s = latexstring("\\mu_{Profit}")
s2 = latexstring("\\mu_{Profit} \\pm \\sigma_{Profit}")
s3 = latexstring("ArgMax(\\mu_{Profit})")
	
plot(p,mean(profit, dims=2) + std(profit, dims=2),  color = "orange", lw=2, label =s2)
plot!(p,mean(profit, dims=2), color = "red", lw=4, label="")
for i in collect(1:length(post_c[1]))
			plot!(p,profit[:,i], color="blue", label=false, alpha = 0.1)
end
plot!(p,mean(profit, dims=2), color = "red", lw=4, label=s)
plot!(p,mean(profit, dims=2) - std(profit, dims=2),  color = "orange", lw=2, label="")
vline!(p[mxindx], p[mxindx], line = (:black, 3), label=s3)
xlabel!("Price")
ylabel!("Profit")
plot!(legend=true)
end

# ╔═╡ 4739d9b0-17b9-11eb-193c-d30c7ba1fc4a
mxval[1]

# ╔═╡ 3bf3d364-17d0-11eb-3c9c-0506adbc94a2
md"With the unfavorable (or favorable) case of:"

# ╔═╡ e5f27e7a-17cf-11eb-2149-01d629ee005e
unfav = mxval[1] - std(profit[mxindx[1][1], : ])

# ╔═╡ 5a8886d0-17d0-11eb-3353-7339d2fb1719
fav = mxval[1] + std(profit[mxindx[1][1], : ])

# ╔═╡ 422672b6-1576-11eb-10cc-79fffd40d7db
md"*Profit for sampled values, highlighting the mean, a deviation from the mean and the maximum mean profit.*"

# ╔═╡ 47cef5d0-1576-11eb-3f41-abd06e334cb0
md"In this way, not only do we have the information about the average profit (marked in red), but we also have a notion of the uncertainty that the model handles. As you can see in the graph and remembering that the highest price value we had in the pilot test was $5000, the uncertainty increases a lot for higher values, reflecting the lack of data.
	
Then, analyzing the graph:

The red line plotted is the mean expected profit and its maximum is near $4840. The region between the orange lines is approximately one standard deviation far from the expected value or where the 65% of the lines, plotted from the sampled values of our parameters, fall.

With this in mind and seeing that the profit curve is quite flat in the sector where the maximum is found, one could argue that it is preferable to choose a lower price since the money lost would be minimal, but the volatility would go down considerably.

In order to see this, it would be interesting to graph the standard deviation of the profit according to the price we choose:
"

# ╔═╡ 4cd0ab6c-17cb-11eb-30b6-5d4b47f5c1f7
std_p = [std(profit[i, : ]) for i in collect(1:length(p))]

# ╔═╡ 67a9ae02-17cb-11eb-1156-f97057e6df71
plot(p,std_p, legend=false, xlabel = "Price", ylabel= "Std deviation of profit", lw=2)

# ╔═╡ 9075c6c2-17cb-11eb-0201-dbc268664597
md"Looking at both graphs we can see that, while the average profit is flattened, the standard deviation of it always goes up, corroborating that lowering the price can be a good strategy"

# ╔═╡ 46820c60-17cb-11eb-21a6-f57a5a65d5ce
md"For example, let's look at the case where an alternative price of $4000 is chosen:"

# ╔═╡ 7ea38c20-17b9-11eb-2f98-6f280438e81c
quantity_at_4000 = q[findfirst(isequal(4000), p), : ]

# ╔═╡ 3f982a5a-17c2-11eb-01a1-4bed29aeb5a1
#Sales minus costs for every model at price of $4000
profit_4000 = 4000 .* quantity_at_4000 .- (10000 .+ quantity_at_4000 .* 700)

# ╔═╡ 4afb419e-17cd-11eb-315a-19f4f697dd6b
#A faster way:
prof_4000 = profit[findfirst(isequal(4000), p), :]

# ╔═╡ 8c7a2c9c-17c2-11eb-1098-8be698ce1cef
mean_prof_4000 = mean(profit_4000)

# ╔═╡ 248c6706-17ce-11eb-1fd9-efc10e54d244
md"With the unfavorable (or favorable) case of:"

# ╔═╡ 5eb7ca92-17ce-11eb-09a9-a93312c84689
unfav_4000 = mean(profit_4000) - std(profit_4000)

# ╔═╡ 9cb0de90-17d0-11eb-00c7-53d6eb70aee7
mean(profit_4000) + std(profit_4000)

# ╔═╡ abe781d8-17c2-11eb-2e60-5bb0297f82b9
begin	
plot(p,mean(profit, dims=2) + std(profit, dims=2),  color = "orange", lw=2, label =s2)
plot!(p,mean(profit, dims=2), color = "red", lw=4, label="")
for i in collect(1:length(post_c[1]))
			plot!(p,profit[:,i], color="blue", label=false, alpha = 0.1)
end
plot!(p,mean(profit, dims=2), color = "red", lw=4, label=s)
plot!(p,mean(profit, dims=2) - std(profit, dims=2),  color = "orange", lw=2, label="")
vline!([4000], [4000], line = (:purple, 3), label=false)
vline!(p[mxindx], p[mxindx], line = (:black, 3), label=s3)
xlabel!("Price")
ylabel!("Profit")
plot!(legend=true)
end

# ╔═╡ 8a1c7c10-17d2-11eb-348c-c12760027fd5
md"Then, by choosing a price of $4000 the average profit goes from $582800 to $58120. That is, a percentage variation of:"

# ╔═╡ ade07bbc-17d2-11eb-1875-510bbb3d4643
porcentual_profit_diff = ((mean(profit_4000) - mxval[1]) / mxval[1]) * 100

# ╔═╡ 044cd2dc-17d3-11eb-1089-c5d8a2a69bce
md"While the most unfavorable case goes from $549705 to $553298.5. That is, a percentage variation of:"

# ╔═╡ 4f7380a8-17d3-11eb-2a39-3d8c3c8c001f
porcentual_std_diff = ( unfav_4000 - unfav) / unfav *100

# ╔═╡ ee7544f8-17d4-11eb-251d-f3c04a5a32e7
 porcentual_std_diff / porcentual_profit_diff

# ╔═╡ 32997ca8-1869-11eb-2bc6-11da0327e0b8
md"""So, for every dollar we "lost" in average profitability, we gained more than double in the reduction of uncertainty.

Regardless of each person's decision, the important thing about the Bayesian framework is that it allows us to include uncertainty in our models and use it to our advantage to make more informed and intelligent decisions. 

Instead of wanting to forget and get rid of uncertainty, Bayesianism allows us to accept that this is an inherent feature of reality and to take advantage of it. Being able to narrow down how sure we are about the inferences we make gives us an invaluable advantage when making decisions.

### Summary

In this chapter we have learned some basic concepts of economics such as the price elasticity of demand for a product, or the Pareto distribution of income and wealth. Then, we estimated the demand curve of a possible new product, performing a pilot test to see the relationship between price and quantity demanded. Thanks to Bayesian inference we were able to use the uncertainty we had to our advantage, quantifying the trade-off between expected return and the variability of it, making possible to perform a well informed decision.
"""

# ╔═╡ 03117e4c-5b65-11eb-2973-6f2eaf3d9199
md"### References

[Chad Scherrer Bayesian Optimal Pricing Post](https://cscherrer.github.io/post/max-profit/)

"

# ╔═╡ 2ec2da4e-8b5e-11eb-3cee-9d75549739a2
md" ### Give us feedback
 
 
This book is currently in a beta version. We are looking forward to getting feedback and criticism:
  * Submit a GitHub issue **[here](https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers/issues)**.
  * Mail us to **martina.cantaro@lambdaclass.com**
 
Thank you!
"


# ╔═╡ 2dea0886-8b5e-11eb-1dfa-2d44174693c1
md"
[Next chapter](https://datasciencejuliahackers.com/10_bees_vs_wasps.jl.html)
"


# ╔═╡ Cell order:
# ╟─39b6c758-8be0-11eb-30cb-7d7442920974
# ╟─5f171c4c-1567-11eb-0d69-f116e79738b5
# ╟─b53fe140-1567-11eb-134b-39d6066eb06d
# ╠═ca9a04c0-1567-11eb-39f6-3fac127be101
# ╟─821ba35e-1568-11eb-3a08-f988ebc1b1e3
# ╠═c8cbd94e-1569-11eb-27b2-513b849460eb
# ╟─0d3fe04c-1570-11eb-2fd7-c5a366cbc13f
# ╟─1247d9d6-156a-11eb-35d2-d9264c933280
# ╠═888f8de8-156a-11eb-27f4-698b94d26234
# ╟─15c0f7be-156c-11eb-1c9d-8b473d8f7d7f
# ╟─ee449794-156c-11eb-04e9-89c9258ea95d
# ╠═6c11796c-156d-11eb-0d7d-fda4ca4f50eb
# ╟─efe7fb74-156f-11eb-1d4e-c32b49970387
# ╟─a1e9eb50-156d-11eb-0224-d93a772766c9
# ╟─d9f8435c-156d-11eb-1044-b7a799dc2401
# ╟─f4484e86-156e-11eb-1c2a-d9a9f13a25aa
# ╠═2f0d4ada-156f-11eb-094d-dff28b630402
# ╠═0ccc8cce-156f-11eb-370d-d31a19ae38db
# ╟─47780236-156f-11eb-1f12-4fb312e8c3c3
# ╠═82d4d8a4-156f-11eb-16af-41dd2d739186
# ╟─d6ca0448-156f-11eb-363f-7363cfd89f9c
# ╟─e2b3b394-156f-11eb-3a1e-2b5b13db8e03
# ╠═785a8984-1570-11eb-3b51-131d970de8d3
# ╟─80bd1d26-1572-11eb-0966-7d68095843e2
# ╠═d3b37d5c-1572-11eb-31b8-cde9ffaa91c0
# ╠═a10644ee-1573-11eb-2ac0-b511c0333c19
# ╟─d779e92c-1573-11eb-1089-2d728a5d1691
# ╟─02207a56-1574-11eb-0436-67fe6b08448d
# ╠═0fcff67e-1574-11eb-150b-27c1c36fd7c4
# ╠═16aa6662-1574-11eb-3c7b-072455b11d30
# ╟─1c6fd97e-1574-11eb-18e0-7fb1cc959de4
# ╟─4dd96e64-1574-11eb-3f78-1541470c0e77
# ╠═66d56e52-1574-11eb-09eb-c73670c14ce5
# ╟─7cf67c6e-1574-11eb-3953-cd88073b6879
# ╠═855ae83e-1574-11eb-2b2a-5b6371a7f110
# ╟─a897e75c-1574-11eb-2114-8bcf7ae98708
# ╠═b758edd6-1574-11eb-2fe3-218ddec7fd26
# ╟─cb02af4a-1574-11eb-1816-a5bcdf070365
# ╟─dddad9d8-1574-11eb-2453-c5f2176e95c9
# ╠═ef793db0-1574-11eb-00d0-5d58783e847e
# ╟─3e4c3122-1575-11eb-2d55-8191bc945fa2
# ╠═4bffbd34-1575-11eb-0922-9f00ae5cde7f
# ╠═4739d9b0-17b9-11eb-193c-d30c7ba1fc4a
# ╟─3bf3d364-17d0-11eb-3c9c-0506adbc94a2
# ╠═e5f27e7a-17cf-11eb-2149-01d629ee005e
# ╠═5a8886d0-17d0-11eb-3353-7339d2fb1719
# ╠═b732ab66-1575-11eb-3bbc-8187854383b1
# ╟─422672b6-1576-11eb-10cc-79fffd40d7db
# ╟─47cef5d0-1576-11eb-3f41-abd06e334cb0
# ╠═4cd0ab6c-17cb-11eb-30b6-5d4b47f5c1f7
# ╠═67a9ae02-17cb-11eb-1156-f97057e6df71
# ╟─9075c6c2-17cb-11eb-0201-dbc268664597
# ╟─46820c60-17cb-11eb-21a6-f57a5a65d5ce
# ╠═7ea38c20-17b9-11eb-2f98-6f280438e81c
# ╠═3f982a5a-17c2-11eb-01a1-4bed29aeb5a1
# ╠═4afb419e-17cd-11eb-315a-19f4f697dd6b
# ╠═8c7a2c9c-17c2-11eb-1098-8be698ce1cef
# ╟─248c6706-17ce-11eb-1fd9-efc10e54d244
# ╠═5eb7ca92-17ce-11eb-09a9-a93312c84689
# ╠═9cb0de90-17d0-11eb-00c7-53d6eb70aee7
# ╠═abe781d8-17c2-11eb-2e60-5bb0297f82b9
# ╟─8a1c7c10-17d2-11eb-348c-c12760027fd5
# ╠═ade07bbc-17d2-11eb-1875-510bbb3d4643
# ╟─044cd2dc-17d3-11eb-1089-c5d8a2a69bce
# ╠═4f7380a8-17d3-11eb-2a39-3d8c3c8c001f
# ╠═ee7544f8-17d4-11eb-251d-f3c04a5a32e7
# ╟─32997ca8-1869-11eb-2bc6-11da0327e0b8
# ╟─03117e4c-5b65-11eb-2973-6f2eaf3d9199
# ╟─2ec2da4e-8b5e-11eb-3cee-9d75549739a2
# ╟─2dea0886-8b5e-11eb-1dfa-2d44174693c1
