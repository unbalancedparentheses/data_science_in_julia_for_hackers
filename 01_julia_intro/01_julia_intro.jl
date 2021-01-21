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
"

# ╔═╡ 292d20ea-5a8e-11eb-2a96-a37689e468ca
md"
## First steps into the Julia world
As with every programming language, it is useful to know some of the basic operations and functionalities. We encourage you to open a Julia session REPL and start experimenting with all the code written in this chapter to start developing an intuition about the things that make Julia code special.

The common arithmetical and logical operations are all available in Julia:

* $ + $: Add operator
* $ - $: Substract operator
* $ * $: Product operator
* $ / $: Division operator

Julia code is intended to be very similar to math. So insted of doing something like
```julia
julia> 2*x
```
you can simply do
```julia
julia> 2x
```

For this same purpose, Julia has a great variety of unicode characters, which enables us to write things like greek letters and subscripts/superscripts, making our code much more beautiful and easy to read in a mathematical form. In general, unicode characters are activated by using '\', followed by the name of the character and then pressing the 'tab' key. For example,
```julia
julia> \pi # and next we press tab
julia> π
```

For subscripts and superscripts, the methodology is similar. You start with the character you want to add the subscript or superscript to, and then you do '\_' or '\^', followed by the character you want to be at the bottom or top, and finally the 'tab' key. For example, 
```julia
julia> L\_0 # and next we press tab
julia> L₀
```
The basic number types are also supported in Julia. We can explore this with the function *typeof()*, which spits out the type of its argument, as it is represented in Julia. Let's see some examples,

```julia
julia>typeof(2)
Int64

julia>typeof(2.0)
Float64

julia>typeof(3 + 5im)
Complex{Int64}
```
"

# ╔═╡ 01ca39ee-5a9c-11eb-118e-afae416cfca4
md"
These were examples of integers, floats and complex numbers. All data types in Julia start with a capital letter.
Notice that if you want to do something like,
```julia
julia> 10/2
5.0
```
the output is a floating point number, although the two numbers in the operation are integers. This is because in Julia, division of integers always results in floats. When valid, you can always do
```julia
julia> Int64(5.0)
5
```
to convert from one data type to another.

Following with the basics, let's take a look at how logical or boolean operations are done in Julia. Booleans are written as 'true' and 'false'. The most important boolean operations for our purposes are the following:
```julia
 !: \"not\" logical operator
 &: \"and\" logical operator
 |: \"or\" logical operator
 ==: \"equal to\" logical operator
 !=: \"different to\" logical operator
 >: \"greater than\" operator
 <: \"less than\" operator
 >=: \"greater or equal to\" operator
 <=: \"less or equal to\" operator
```
Some examples of these,

```julia
julia> true & true
true

julia> true & false
false

julia> true & !false
true

julia> 3 == 3
true

julia> 4 == 5
false

julia> 7 <= 7
true
```

Comparisons can be chained to have a simpler mathematical readability, like so:
```julia
julia> 10 <= 11 < 24
true

julia> 5 > 2 < 1
false
```

The next important topic in this Julia programming basics, is the strings data type and basic manipulations. As in many other programming languages, strings are created between '\"',

```julia
julia> \"This is a Julia string!\"
\"This is a Julia string!\"
```

You can access some particular character of a string by writing the index of that character in the string between brackets right next to the string. Likewise, you can access some substring by writing the first and the last index of the substring you want, separated by a colo, all this between brackets. This is called *slicing*, and will be very useful later when working with arrays. As an example of this,

```julia
julia> \"This is a Julia string!\"[1] # this will output the first character of the string and other related information.
'T': ASCII/Unicode U+0054 (category Lu: Letter, uppercase)

julia> \"This is a Julia string!\"[1:4] # this will output the substring obtained of going from the first index to the fourth
\"This\"
```

A really useful tool when using strings is *string interpolation*. This is a way to evaluate an expression inside a string and print it. This is done usually by writing a dollar symbol $ \$  $ followed by the expression between parnethesis. For example,

```julia
julia> \"The product between 4 and 5 is $(4 * 5)\"
\"The product between 4 and 5 is 20\"
```
This couldn't be a programming introduction if we didn't include a 'Hello World!' printing, right? Printing in Julia is very easy. You have, essentially, two functions for the printing process: print() and println(). The former will print the string you pass in the argument, without creating a new line. What this means is that, for example, if you are in a Julia REPL and you call the print() function two or more times, the printed strings will be concatenated in the same line, while successive calls to the println() function will print every new string in a new, separated line from the previous one. To ilustrate these concepts, consider the next examples. We haven't talked about for loops yet, so don't worry about that for now. Just notice how the output changes when we make a print() or println() call.

```julia
julia> for i in 1:3
           print(i)
       end
123

julia> for i in 1:3
           println(i)
       end
1
2
3
```

It's time now to start introducing collections of data in Julia. We will start by talking about arrays.  As in many other programming languages, arrays in Julia can be created by listing objects between square brackets separated by commas. For example, 

```julia
julia> [1, 2, 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> str_array = [\"Hello\", \"World\"]
2-element Array{String,1}:
 \"Hello\"
 \"World\"
```

As you can see, arrays can store any type of data. If all the data in the array is of the same type, it will be compiled as an array of that data type. You can see that in the patter that the Julia REPL prints out:

1) Firstly, it tells how many elements there are in the collection. In our case, 3 elements in int_array and 2 elements in str_array. When dealing with higher dimensionality arrays, the shape will be informed.
2) It gives information about the type and dimensionality of the array. The first element inside the curly brackets, informs us about the type of every member of the array, if they are all the same. If this is not the case, type 'Any' will appear, meaning that the collection of objects inside the array is not homogeneous in its type. Compilation of Julia code tends to be faster when arrays have a defined type, so it is recommended to use these unless needed. The second element between the curly braces tells us how many dimentions are there in the array. In these examples we have one-dimentional arrays, hence a 1 is printed. Later we will be introducing matrices and, naturally, a 2 will appear in this place insted a 1.
3) Finally, the content of the array is printed in a columnar way.

When building Julia, the convention has been set so that it has column-major ordering. So you can think of standard one-dimentional arrays as –and in fact it will be mandatory when doing calculations between vectors, matrices and the like– column vectors.
A row vector (or a $1 x n$ array), in the other hand, can be defined using whitespaces instead of commas,

```julia
julia> [3 2 1 4]
1×4 Array{Int64,2}:
 3  2  1  4
```

Matrices are built –in contrast to other languages, were they are thought as an 'array of arrays'– separating the numbers in a row by whitespaces, just like the example of a row vector, and using a semicolon to simbolize the end of the row. Then you complete the rest of the rows with the same procedure. As an example,

```julia
julia> [1 1 2; 4 1 0; 3 3 1]
3×3 Array{Int64,2}:
 1  1  2
 4  1  0
 3  3  1
```

An interesting feature in Julia is *broadcasting*. Suppose you wanted to add the number 2 to every element of an array. You might be tempted to do

```julia
julia> 2 + [1, 1, 1]
ERROR: MethodError: no method matching +(::Array{Int64,1}, ::Int64)
For element-wise addition, use broadcasting with dot syntax: array .+ scalar
Closest candidates are:
  +(::Any, ::Any, ::Any, ::Any...) at operators.jl:538
  +(::Complex{Bool}, ::Real) at complex.jl:301
  +(::Missing, ::Number) at missing.jl:115
  ...
Stacktrace:
 [1] top-level scope at REPL[18]:1
```

As you can see, the expression throws an error. If you watch this error closely, it gives you a good suggestion about what to do. If we now try writing a period '.' right before the plus sign, we get

```julia
julia> 2 .+ [1, 1, 1]
3-element Array{Int64,1}:
 3
 3
 3
```

What we have done is to *broadcast* the sum operator '+' over the entire array. This is done by adding a period before the operator we want to broadcast. In this way we can write complicated expressions in a much cleaner, simpler and compact way. This can be done with any of the operators we have already seen,

```julia
julia> 3 .> [2, 4, 5] # this will output a bit array with 0s as false and 1s as true
3-element BitArray{1}:
 1
 0
 0
```

If we do a broadcasting operation between two arrays with the same shapes, whatever operation you are broadcasting will be done element-wise. For example,

```julia
julia> [7, 2, 1] .* [10, 4, 8]
3-element Array{Int64,1}:
 70
  8
  8

julia> [10 2 35] ./ [5 2 7]
1×3 Array{Float64,2}:
 2.0  1.0  5.0

julia> [5 2; 1 4] .- [2 1; 2 3]
2×2 Array{Int64,2}:
  3  1
 -1  1
```

If we use the broadcast operator between a column vector and a row vector instead, the broadcast is done for every row of the first vector and every column of the second vector, returning a matrix,

```julia
julia> [1, 0, 1] .+ [3 1 4]
3×3 Array{Int64,2}:
 4  2  5
 3  1  4
 4  2  5
```

Another useful tool when dealing with arrays are concatenations. Given two arrays, you can concatenate them horizontally or vertically. This is best seen in an example

```julia
julia> vcat([1, 2, 3], [4, 5, 6]) # this concatenates the two arrays vertically, giving us a new long array
6-element Array{Int64,1}:
 1
 2
 3
 4
 5
 6

julia> hcat([1, 2, 3], [4, 5, 6]) # this stacks the two arrays one next to the other, returning a matrix
3×2 Array{Int64,2}:
 1  4
 2  5
 3  6

```

With some of these basic tools to start getting your hands dirty in Julia, we can get going into some other functionalities like loops and function definitions. Consider the code block below, where we define a function to calculate a certain number of steps of the Fibonacci sequence,

```julia
julia> 	n1 = 0
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
fibonacci (generic function with 1 method)
```

Here, we firstly made some variable assignments, variables $n1$, $n2$ and $m$ were asigned values 0, 1 and 10. Then, we defined a function for the fibonacci calculation. Function blocks start with the *function* keyword, followed by the name of the function and the arguments between brackets, all separated by commas. In this function, the arguments will be the first two numbers of the sequence and the total length of the sequence. 
Inside the body of the function, everything is indented. Although this is not strictly necessary for the code to run, it is a good practice to have from the beginning.
first we initialize an array of integers of one dimension and length $m$. This way of initializing an array is not strictly necessary, but is definitely a good practice for optimizing code performance in Julia. But don't worry too much about that right now.
We then proceed to assign the two first elements of the sequence and calculate the rest with a *for loop*. The syntax ```3:m ``` just means all the numbers from 3 to ```m```, with a step of 1. We could have set ```3:2:m``` if we wanted to jump between numbers two by two. Finally, an *end* keyword is necessary at the end of the for loop and another one to end the definition of the function.
Evaluating our function in the variables $n1$, $n2$ and $m$ already defined, gives us:
"

# ╔═╡ 0ea23640-5a96-11eb-0843-11d44fa27ea7
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
* [Learn X in Y minutes](https://learnxinyminutes.com/docs/julia/)
"

# ╔═╡ Cell order:
# ╟─0a4fc5fc-544d-11eb-0189-6b1c959b1eb1
# ╟─292d20ea-5a8e-11eb-2a96-a37689e468ca
# ╟─01ca39ee-5a9c-11eb-118e-afae416cfca4
# ╠═0ea23640-5a96-11eb-0843-11d44fa27ea7
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
# ╠═81772818-544e-11eb-1feb-eb7a87460399
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
