### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 0a4fc5fc-544d-11eb-0189-6b1c959b1eb1
md"
# Meeting Julia
Julia is a young, free, open-source and promising general-purpose language, designed and developed by Jeff Bezason, Alan Edelman, Viral B. Shah and Stefan Karpinski in MIT. 
For years, programming languages were limited to either having a simple syntax, being readable, and having good abstraction capabilities, or being designed for technical, high-performance and resource-intensive computations. This led applied scientists to face the task of not only learning two different languages –one high-level, the other low-level-, but also learning how to have them communicate with one another, which is far from trivial in many cases. This is what Julia creators called the *two-language problem*, and it costs programmers and scientists valuable time and effort which may be better invested in solving the actual problems that they needed to compute. Julia is designed to bridge the gap, as it is created from scratch to be both fast and easy to understand, even for people who are not programmers or computer scientists.
	Julia is dynamically typed and is great for interactive use. It also uses multiple dispatch as a core design concept, which adds to the composability of the language. In conventional, single-dispatched, object-oriented programming languages, when invoking a method, one of the arguments has a special treatment since it determines which of the methods contained in a function is going to be applied. Multiple dispatch is a generalization of this for all the arguments of the function, so the method applied is going to be the one that matches exactly the number of type of the function call.

Let's get our hands dirty with some Julia code in an example that the Fibonacci sequence to see what it looks like:
"

# ╔═╡ 3b9c5292-544d-11eb-058d-ed710c185263
begin
	n1 = 0
	n2 = 1
	m = 10

	function fibonacci(n1, n2, m)
		fib = Array{Int64,1}(undef, m)
		fib[1] = n1
		fib[2] = n2
		for i in 3:m
			fib[i] = fib[i-1] + fib[i-2]
		end
		return fib
	end
end

# ╔═╡ eb62587c-544e-11eb-2cdf-833c27b9793c
begin
	using Plots
	sequence = fibonacci(n1, n2, m)
	scatter(sequence, xlabel="n", ylabel="Fibonacci(n)", color="purple", label=false, size=(450, 300))
end

# ╔═╡ 5e789866-544d-11eb-3aaa-f544a717a591
md"
As you can see, writing Julia code is pretty straight-forward. First of all, we made some variable assignments, variables $n1$, $n2$ and $m$ were asigned values 0, 1 and 10. Then, we defined a function for the fibonacci calculation. Function blocks start with the *function* statement, followed by the name of the function and the arguments within brackets. These arguments will be the first two numbers of the sequence and the total length of the sequence. 
Inside the function definition, first we initialize an array of integers of one dimension and length $m$. This way of initializing an array is not strictly necessary, but is definitely a good practice for optimizing code performance in Julia. But don't worry too much about that right now.
We then proceed to assign the two first elements of the sequence and calculate the rest with a *for loop*. The syntax ```3:m ``` just means all the numbers from 3 to ```m```, with a step of 1. We could have set ```3:2:m``` if we wanted to jump between numbers two by two. Finally, an *end* statement is necessary at the end of the for loop, another one to end the definition of the function, and a third one to end the whole code block.
Evaluating our function in the variables $n1$, $n2$ and $m$ already defined, gives us:
"

# ╔═╡ 6b354b4c-544d-11eb-393a-cbb768b7643e
fibonacci(n1, n2, m)

# ╔═╡ 6e8b26f6-544d-11eb-2075-c169535e3137
md" 
Let's see some other nice Julia functionalities. Suppose you wanted to add the number 2 to every element of an array. You may be tempted to try this code, but you are going to get an error message
"

# ╔═╡ 8502f292-544d-11eb-264f-b1ed1b07a710
arr = [1, 2, 2, 3, 6]

# ╔═╡ f8757038-544d-11eb-2280-4b2749b445b4
arr + 2

# ╔═╡ a601ee3a-544d-11eb-1bd9-cb41d605f598
md" 
If you watch closely, the message makes a good suggestion: the *broadcast operator*. When you have an operator applied to some iterable object, adding a dot in front of that operator broadcasts the operation for every element of the object. This is what the dot syntax mentioned in the error message refers to. 
 Let's see it in action:
"

# ╔═╡ ae1fb444-544d-11eb-0d07-e99e031c5264
arr .+ 2

# ╔═╡ 179cbdfe-544e-11eb-117d-17d468df04da
md" 
This is also useful when doing some vector operations. In Julia, one-dimensional arrays initialized by separating its elements with commas can be thought as column vectors. For example, we can define two column vectors
"

# ╔═╡ 6840faea-544e-11eb-1d3e-41ff39e2213f
vec1 = [1, 0, 1]

# ╔═╡ 6e53adc6-544e-11eb-0f25-776f005b1dd8
vec2 = [2, 1, 1]

# ╔═╡ 74b1beb8-544e-11eb-27f8-35afab1636f7
md"
If we would try to do something like ```vec1 * vec2```, this is an ambiguous operation, because Julia doesn't know if we mean a dot product,cross product or maybe something else. But if we add the dot syntax operator, ```vec1 .* vec2```, Julia makes a element-wise multiplication between the elements of the two vectors:
"

# ╔═╡ 7b2239ec-544e-11eb-2e44-4703d2331147
vec1 .* vec2

# ╔═╡ 81772818-544e-11eb-1feb-eb7a87460399
md"
If we would have used the broadcast operator between a column vector and a *row* vector instead, the broadcast is done for every row of the first vector and every column of the second vector, returning a matrix. A row vector can be initialized using whitespaces to separate each element, like so
"

# ╔═╡ 8e2ccc5c-544e-11eb-0460-41f13910bcf5
vec3 = [3 1 4]

# ╔═╡ 92f5a45c-544e-11eb-39b2-f1687cd4c364
md"
So if we do, por example  ```vec1 .* vec3```, we get
"

# ╔═╡ ae011592-544e-11eb-18c4-95e0361479d2
vec1 .* vec3

# ╔═╡ b7c0de46-544e-11eb-3e18-ad4259c4460e
md"
We will be using the broadcast dot syntax throughout the book, and it is used extensively in the Julia community due to its usefulness. 
Broadcasting can be used on functions too. Say you have a function that tells you if a number is positive
"

# ╔═╡ c6b0b188-544e-11eb-1d17-35487e3fe72e
begin
	function isPositive(x)
		if x >= 0
			return true
		elseif x < 0
			return false
		end
	end
end

# ╔═╡ c8ca2a08-544e-11eb-0066-1d62576da475
isPositive(3)

# ╔═╡ d1ae60a8-544e-11eb-15b5-97188dc41aa8
md"
Julia's ecosystem is composed by a variety of libraries which focus on techical domains such as DataScience (DataFrames.jl, CSV.jl), Machine Learning (MLJ.jl, Flux.jl, Turing.jl) and Scientific Computing (DifferentialEquations.jl), as well as more general purpose programming (HTTP.jl, Dash.jl). 
We will now consider one of the libraries that will be accompanying us throughout the book to make visualizations, and it is the standard package for plotting in Julia. It is called Plots.jl. Let's import the library first,
"

# ╔═╡ e36a4352-544e-11eb-2331-43f864bb01d5
md"
Let's make a plot of the 10 first numbers in the fibonacci sequence. For this, we can make use of the ```scatter()``` function:
"

# ╔═╡ f453c7b0-544e-11eb-137c-1d027edb83e6
md"
The only really important argument of the scatter function in the example above is *sequence*, the first one, which tells the function what is the data we want to plot. The other arguments are just details to make the visualization prettier. Here we have used the *scatter* function because we want a discrete plot for our sequence. In case we wanted a continuous one, we could have used *plot()*. Let's see this applied to our fibonacci sequence:
"

# ╔═╡ 03641078-544f-11eb-1dab-37614a0bdbc7
plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))

# ╔═╡ 093aac02-544f-11eb-1221-4dfc049d4652
begin
	plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))
	scatter!(sequence, label=false, color="purple", size=(450, 300))
end

# ╔═╡ 11f33ecc-544f-11eb-35d5-27a280cdce1b
md"
You may have noticed que exclamation mark (or 'bang', as it is called in the Julia community) next to the scatter function. In Julia, functions with a bang are functions that modify variables *in-place*. In the example above, a plot is created when we call the plot() function. What the scatter!() call then does, is to modify the global state of the plot in-place. If not done this way, both plots wouldn't be sketched together.
"

# ╔═╡ 190ab9c4-544f-11eb-1460-9fbf13dc8516
md" 
As mentioned, Julia is specially suited for areas related with scientific and high-performance computations. Between these, we have *Probabilistic Programming*, and more generally *Bayesian Statistics*. These two fields are strongly related to each other and are the main focus of the book. First, we will need to get some intuitive idea about what Bayesian Statistics is, so let's go for it
"

# ╔═╡ 1f2086cc-544f-11eb-339e-1d31f4b4eb4b
md"
### Bibliography
* [Julia's website](https://julialang.org/)
"

# ╔═╡ Cell order:
# ╟─0a4fc5fc-544d-11eb-0189-6b1c959b1eb1
# ╠═3b9c5292-544d-11eb-058d-ed710c185263
# ╟─5e789866-544d-11eb-3aaa-f544a717a591
# ╠═6b354b4c-544d-11eb-393a-cbb768b7643e
# ╟─6e8b26f6-544d-11eb-2075-c169535e3137
# ╠═8502f292-544d-11eb-264f-b1ed1b07a710
# ╠═f8757038-544d-11eb-2280-4b2749b445b4
# ╟─a601ee3a-544d-11eb-1bd9-cb41d605f598
# ╠═ae1fb444-544d-11eb-0d07-e99e031c5264
# ╟─179cbdfe-544e-11eb-117d-17d468df04da
# ╠═6840faea-544e-11eb-1d3e-41ff39e2213f
# ╠═6e53adc6-544e-11eb-0f25-776f005b1dd8
# ╟─74b1beb8-544e-11eb-27f8-35afab1636f7
# ╠═7b2239ec-544e-11eb-2e44-4703d2331147
# ╟─81772818-544e-11eb-1feb-eb7a87460399
# ╠═8e2ccc5c-544e-11eb-0460-41f13910bcf5
# ╟─92f5a45c-544e-11eb-39b2-f1687cd4c364
# ╠═ae011592-544e-11eb-18c4-95e0361479d2
# ╟─b7c0de46-544e-11eb-3e18-ad4259c4460e
# ╠═c6b0b188-544e-11eb-1d17-35487e3fe72e
# ╠═c8ca2a08-544e-11eb-0066-1d62576da475
# ╟─d1ae60a8-544e-11eb-15b5-97188dc41aa8
# ╟─e36a4352-544e-11eb-2331-43f864bb01d5
# ╠═eb62587c-544e-11eb-2cdf-833c27b9793c
# ╟─f453c7b0-544e-11eb-137c-1d027edb83e6
# ╠═03641078-544f-11eb-1dab-37614a0bdbc7
# ╠═093aac02-544f-11eb-1221-4dfc049d4652
# ╟─11f33ecc-544f-11eb-35d5-27a280cdce1b
# ╟─190ab9c4-544f-11eb-1460-9fbf13dc8516
# ╟─1f2086cc-544f-11eb-339e-1d31f4b4eb4b
