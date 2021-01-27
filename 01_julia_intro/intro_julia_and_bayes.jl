### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 4416629a-1542-11eb-148e-ef590ccf5983
using Plots

# ╔═╡ 69063c5c-1541-11eb-33fd-633f9f926a44
md"
# Meeting Julia
Julia is a young, free, open-source and promising general-purpose language, designed and developed by Jeff Bezason, Alan Edelman, Viral B. Shah and Stefan Karpinski in MIT. 
For years, programming languages were limited to either having a simple syntax, being readable, and having good abstraction capabilities, or being designed for technical, high-performance and resource-intensive computations. This led applied scientists to face the task of not only learning two different languages –one high-level, the other low-level-, but also learning how to have them communicate with one another, which is far from trivial in many cases. This is what Julia creators called the *two-language problem*, and it costs programmers and scientists valuable time and effort which may be better invested in solving the actual problems that they needed to compute. Julia is designed to bridge the gap, as it is created from scratch to be both fast and easy to understand, even for people who are not programmers or computer scientists.
	Julia is dynamically typed and is great for interactive use. It also uses multiple dispatch as a core design concept, which adds to the composability of the language. In conventional, single-dispatched, object-oriented programming languages, when invoking a method, one of the arguments has a special treatment since it determines which of the methods contained in a function is going to be applied. Multiple dispatch is a generalization of this for all the arguments of the function, so the method applied is going to be the one that matches exactly the number of type of the function call.

Let's get our hands dirty with some Julia code in an example that the Fibonacci sequence to see what it looks like:
"

# ╔═╡ a002b6ae-1541-11eb-0fa3-df0a4ff21370
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

# ╔═╡ aa9d3116-1541-11eb-23bf-459b64dfd0b8
md"
As you can see, writing Julia code is pretty straight-forward. First of all, we made some variable assignments, variables $n1$, $n2$ and $m$ were asigned values 0, 1 and 10. Then, we defined a function for the fibonacci calculation. Function blocks start with the *function* statement, followed by the name of the function and the arguments within brackets. These arguments will be the first two numbers of the sequence and the total length of the sequence. 
Inside the function definition, first we initialize an array of integers of one dimension and length $m$. This way of initializing an array is not strictly necessary, but is definitely a good practice for optimizing code performance in Julia. But don't worry too much about that right now.
We then proceed to assign the two first elements of the sequence and calculate the rest with a *for loop*. The syntax ```3:m ``` just means all the numbers from 3 to ```m```, with a step of 1. We could have set ```3:2:m``` if we wanted to jump between numbers two by two. Finally, an *end* statement is necessary at the end of the for loop, another one to end the definition of the function, and a third one to end the whole code block.
Evaluating our function in the variables $n1$, $n2$ and $m$ already defined, gives us:
"

# ╔═╡ ba0a3d60-1541-11eb-0673-774627db5f9c
fibonacci(n1, n2, m)

# ╔═╡ bb6c34d8-1541-11eb-39c7-fbde2d9f3cc0
md" 
Let's see some other nice Julia functionalities. Suppose you wanted to add the number 2 to every element of an array. You may be tempted to try this code, but you are going to get an error message
"

# ╔═╡ c2ef5a64-1541-11eb-39a5-65601cb8d1ee
begin
	arr = [1, 2, 2, 3, 6]
	arr + 2
end

# ╔═╡ c8696958-1541-11eb-01bb-e79a8722acd9
md" 
If you watch closely, the message makes a good suggestion: the *broadcast operator*. When you have an operator applied to some iterable object, adding a dot in front of that operator broadcasts the operation for every element of the object. This is what the dot syntax mentioned in the error message refers to. 
 Let's see it in action:
"

# ╔═╡ cd963142-1541-11eb-3d9a-e3bd8eba8ebb
arr .+ 2

# ╔═╡ d5e4be6e-1541-11eb-2de3-f380501b2d65
md" 
This is also useful when doing some vector operations. In Julia, one-dimensional arrays initialized by separating its elements with commas can be thought as column vectors. For example, we can define two column vectors
"

# ╔═╡ df4440b2-1541-11eb-026d-6fd94966c77b
vec1 = [1, 0, 1]

# ╔═╡ e0ad1744-1541-11eb-068b-7d5c42f745b4
vec2 = [2, 1, 1]

# ╔═╡ e7d4bb3c-1541-11eb-2600-531a9d92bdfb
md"
If we would try to do something like ```vec1 * vec2```, this is an ambiguous operation, because Julia doesn't know if we mean a dot product,cross product or maybe something else. But if we add the dot syntax operator, ```vec1 .* vec2```, Julia makes a element-wise multiplication between the elements of the two vectors:
"

# ╔═╡ ee190548-1541-11eb-08e5-077334828aad
vec1 .* vec2

# ╔═╡ f3222722-1541-11eb-32df-c15607c6d33d
md"
If we would have used the broadcast operator between a column vector and a *row* vector instead, the broadcast is done for every row of the first vector and every column of the second vector, returning a matrix. A row vector can be initialized using whitespaces to separate each element, like so
"

# ╔═╡ fe3d77f4-1541-11eb-2561-d160472b2ca8
vec3 = [3 1 4]

# ╔═╡ 03624dfe-1542-11eb-0994-ef4b41eb8472
md"
So if we do, por example  ```vec1 .* vec3```, we get
"

# ╔═╡ 08033378-1542-11eb-13c1-95c1f1d28a0b
 vec1 .* vec3

# ╔═╡ 09dedf76-1542-11eb-1880-ef7fba7c615e
md"
We will be using the broadcast dot syntax throughout the book, and it is used extensively in the Julia community due to its usefulness. 
Broadcasting can be used on functions too. Say you have a function that tells you if a number is positive
"

# ╔═╡ 0f6cd57e-1542-11eb-1d15-3f0800e88038
begin
	function isPositive(x)
		if x >= 0
			return true
		elseif x < 0
			return false
		end
	end
end

# ╔═╡ 149b2d7a-1542-11eb-2beb-21dabfa28fa6
isPositive(3)

# ╔═╡ 21a88ab2-1542-11eb-25bc-a99fd795dd5c
md"
Using the dot syntax, this function can be applied over an entire array
"

# ╔═╡ 2669a9be-1542-11eb-13b3-196bbda9d433
isPositive.([2, 3, 5, -2, 1, -4])

# ╔═╡ 6c12e294-1887-11eb-2f79-0dd16388d116
md"
Julia's ecosystem is composed by a variety of libraries which focus on techical domains such as DataScience (DataFrames.jl, CSV.jl), Machine Learning (MLJ.jl, Flux.jl, Turing.jl) and Scientific Computing (DifferentialEquations.jl), as well as more general purpose programming (HTTP.jl, Dash.jl). 
We will now consider one of the libraries that will be accompanying us throughout the book to make visualizations, and it is the standard package for plotting in Julia. It is called Plots.jl. Let's import the library first,
"

# ╔═╡ 4a23191c-1542-11eb-35c2-2d053e159e36
md"
Let's make a plot of the 10 first numbers in the fibonacci sequence. For this, we can make use of the ```scatter()``` function:
"

# ╔═╡ 4d7b0908-1542-11eb-3911-8dfc7e56d475
begin
	sequence = fibonacci(n1, n2, m)
	scatter(sequence, xlabel="n", ylabel="Fibonacci(n)", color="purple", label=false, size=(450, 300))
end

# ╔═╡ 597ff420-1542-11eb-1014-a5b1a136710e
md"
The only really important argument of the scatter function in the example above is *sequence*, the first one, which tells the function what is the data we want to plot. The other arguments are just details to make the visualization prettier. Here we have used the *scatter* function because we want a discrete plot for our sequence. In case we wanted a continuous one, we could have used *plot()*. Let's see this applied to our fibonacci sequence:
"

# ╔═╡ 5c2a5cf6-1542-11eb-23a5-0577567b68ee
plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))

# ╔═╡ 6244829c-1542-11eb-29a3-2567e3f37b0e
begin
	plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))
	scatter!(sequence, label=false, color="purple", size=(450, 300))
end

# ╔═╡ 6dbf0db8-1542-11eb-1d31-95d4ff417e4d
md"
You may have noticed que exclamation mark (or 'bang', as it is called in the Julia community) next to the scatter function. In Julia, functions with a bang are functions that modify variables *in-place*. In the example above, a plot is created when we call the plot() function. What the scatter!() call then does, is to modify the global state of the plot in-place. If not done this way, both plots wouldn't be sketched together.
"

# ╔═╡ 745e66fa-1542-11eb-2590-e74ec90742bb
md" 
As mentioned, Julia is specially suited for areas related with scientific and high-performance computations. Between these, we have *Probabilistic Programming*, and more generally *Bayesian Statistics*. These two fields are strongly related to each other and are the main focus of the book. First, we will need to get some intuitive idea about what Bayesian Statistics is, so let's go for it
"

# ╔═╡ 32df0e98-35a2-11eb-1121-5f731785abbb
md"
### Bibliography
* [Julia's website](https://julialang.org/)
"

# ╔═╡ Cell order:
# ╟─69063c5c-1541-11eb-33fd-633f9f926a44
# ╠═a002b6ae-1541-11eb-0fa3-df0a4ff21370
# ╠═aa9d3116-1541-11eb-23bf-459b64dfd0b8
# ╠═ba0a3d60-1541-11eb-0673-774627db5f9c
# ╟─bb6c34d8-1541-11eb-39c7-fbde2d9f3cc0
# ╠═c2ef5a64-1541-11eb-39a5-65601cb8d1ee
# ╟─c8696958-1541-11eb-01bb-e79a8722acd9
# ╠═cd963142-1541-11eb-3d9a-e3bd8eba8ebb
# ╟─d5e4be6e-1541-11eb-2de3-f380501b2d65
# ╟─df4440b2-1541-11eb-026d-6fd94966c77b
# ╟─e0ad1744-1541-11eb-068b-7d5c42f745b4
# ╟─e7d4bb3c-1541-11eb-2600-531a9d92bdfb
# ╠═ee190548-1541-11eb-08e5-077334828aad
# ╟─f3222722-1541-11eb-32df-c15607c6d33d
# ╠═fe3d77f4-1541-11eb-2561-d160472b2ca8
# ╟─03624dfe-1542-11eb-0994-ef4b41eb8472
# ╠═08033378-1542-11eb-13c1-95c1f1d28a0b
# ╟─09dedf76-1542-11eb-1880-ef7fba7c615e
# ╠═0f6cd57e-1542-11eb-1d15-3f0800e88038
# ╠═149b2d7a-1542-11eb-2beb-21dabfa28fa6
# ╟─21a88ab2-1542-11eb-25bc-a99fd795dd5c
# ╠═2669a9be-1542-11eb-13b3-196bbda9d433
# ╟─6c12e294-1887-11eb-2f79-0dd16388d116
# ╠═4416629a-1542-11eb-148e-ef590ccf5983
# ╟─4a23191c-1542-11eb-35c2-2d053e159e36
# ╠═4d7b0908-1542-11eb-3911-8dfc7e56d475
# ╟─597ff420-1542-11eb-1014-a5b1a136710e
# ╠═5c2a5cf6-1542-11eb-23a5-0577567b68ee
# ╠═6244829c-1542-11eb-29a3-2567e3f37b0e
# ╟─6dbf0db8-1542-11eb-1d31-95d4ff417e4d
# ╟─745e66fa-1542-11eb-2590-e74ec90742bb
# ╟─32df0e98-35a2-11eb-1121-5f731785abbb
