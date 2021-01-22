### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ eb62587c-544e-11eb-2cdf-833c27b9793c
begin
	using Plots
	
	sequence = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

	scatter(sequence, xlabel="n", ylabel="Fibonacci(n)", color="purple", label=false, size=(450, 300))
end

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

* `` + ``: Add operator
* ``` - ```: Substract operator
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
The length and shape of arrays can be obtained using the *length()* and *size()* functions respectiverly, like so

```julia
julia> length([1, -1, 2, 0])
4

julia> size([1 0; 0 1])
(2, 2)

julia> size([1 0; 0 1], 2) # you can also specify the dimension where you want the shape to be computed
2
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

With some of these basic tools to start getting your hands dirty in Julia, we can get 
going into some other functionalities like loops and function definitions.
We have already seen a for loop. For loops are started with a *for* keyword, followed by the name of the iterator and the range of iterations we want our loop to cover. Below this for statement we write what we want to be performed in each loop and we finish with an *end* keyword statement.
Let's return to the example we made earlier,
```julia
julia> for i in 1:100
	       println(i)
	   end
```
The syntax ```1:100 ``` is the Julian way to define a range of all the numbers from 1 
to 100, with a step of 1. We could have set ```1:2:100``` if we wanted to jump between 
numbers with a step size of 2. We can also iterate over collections of data, like 
arrays. Consider the next block of code where we define an array and then iterate over it,

```julia
julia> arr = [1, 3, 2, 2]
julia> for element in arr
	       println(element)
	   end
1
3
2
2
```
As you can see, the loop was done for each element of the array. It might be convenient sometimes to iterate over a collection. 
Following with the basics, conditional statements in Julia are very similar to most languages. Essentially, a conditional statement starts with the *if* keyword, followed by the condition that must be evaluated to true or false, and then the body of the action to apply if the condition evaluates to true. Then, an *elseif* keyword can be used to ask for another condition, and an *else*  keyword to apply some statement when the other conditions evaluate to false. Finally, like it is usual in Julia, the conditional statement block finishes whith an *end* keyword. As an example, 

```julia
julia> x = 3
julia> if x > 2
	       println(\"x is greater than 2\")
       elseif 1 < x < 2
		   println(\"x is in between 1 and 2\")
	   else
		   println(\"x is less than 1\")
	   end
x is greater than 2
```

Now consider the code block below, where we define a function to calculate a certain number of steps of the Fibonacci sequence,

```julia
julia> n1 = 0
julia> n2 = 1
julia> m = 10
julia> function fibonacci(n1, n2, m)
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

Here, we first made some variable assignments, variables $n1$, $n2$ and $m$ were asigned values 0, 1 and 10. Variables are assigned simply by writing the name of the 
variable followed by an 'equal' sign, and followed finally by the value you want to
store in that variable. There is no need to declare the data type of the value you are going to store.
Then, we defined the function body for the fibonacci series computation. Function blocks start with the *function* keyword, followed by the name of the function and the 
arguments between brackets, all separated by commas. In this function, the arguments 
will be the first two numbers of the sequence and the total length of the fibonacci 
sequence. 
Inside the body of the function, everything is indented. Although this is not strictly 
necessary for the code to run, it is a good practice to have from the beginning, since we want our code to be readable.
At first, we initialize an array of integers of one dimension and length $m$, by 
allocating memory. This way of initializing an array is not strictly necessary, you 
could have initialized an empty array and start filling it later in the code. But is 
definitely a good practice to learn for a situation like this, where we know how long our array is going to be and optimizing code performance in Julia. 
The memory allocation for this array is done by initializing the array as we have already seen earlier. ```julia {Int64,1}```just means we want a one-dimentional array
of integers. The new part is the one between parenthesis, ```julia (undef, m)```. This 
just means we are initializing the array with undefined values –which will be later modifyed by us–, and that there will be a number $m$ of them. Don't worry too much if 
you don't understand all this right now, though.
We then proceed to assign the two first elements of the sequence and calculate the 
rest with a for loop. Finally, an *end* keyword is necessary at the end of the for loop and another one to end the definition of the function.
Evaluating our function in the variables $n1$, $n2$ and $m$ already defined, gives us:

```julia
julia> fibonacci(n1, n2, m)
10-element Array{Int64,1}:
  0
  1
  1
  2
  3
  5
  8
 13
 21
 34
```

Remember the broadcasting operation, that dot we added to the beginning of another operator to make it appy over an entire collection of objects? It turns out that this can be done with functions as well! Consider the following function,

```julia
julia> function isPositive(x)
	      if x >= 0
			   return true
		  elseif x < 0
			   return false
		  end
	   end
isPositive (generic function with 1 method)

julia> isPositive(3)
true

julia> isPositive.([-1, 1, 3, -5])
4-element BitArray{1}:
 0
 1
 1
 0
```

As you can see, we had broadcasted the function isPositive() we defined, over every 
element of an array, by adding a dot next to the end of the function name, previous to 
the parenthesis. Is is as easy as that! Once you start using this feature, you will notice how useful it is.
One last thing concearning functions in Julia is the 'bang'(!) convention. Functions that have a name ending with an exclamation mark (or bang), are functions that change their imputs in-place. Consider the example of the pop! function from the Julia Base package. Watch closely what happens to the array over we apply the function

```julia
julia> arr = [1, 2, 3];
julia> pop!(arr)
3
julia> arr
2-element Array{Int64,1}:
 1
 2
```
Did you understand what happened? At first, we defined and array. Then, we applied the pop!() function, which, as the name suggests, pops the last element of the array. But notice that when we call our *arr* variable to see what it is storing, now the number 3 is gone. This is what functions with a bang do and what we mean with modifying *in-place*. Try to follow this convention whenever you define a function that will modify other objects in-place!
"

# ╔═╡ d1ae60a8-544e-11eb-15b5-97188dc41aa8
md"
## **Julia's Ecosystem**: Basic plotting and DataFrames manipulation
Julia's ecosystem is composed by a variety of libraries which focus on techical domains such as Data Science (DataFrames.jl, CSV.jl, JSON.jl), Machine Learning (MLJ.jl, Flux.jl, Turing.jl) and Scientific Computing (DifferentialEquations.jl), as well as more general purpose programming (HTTP.jl, Dash.jl). 
We will now consider one of the libraries that will be accompanying us throughout the book to make visualizations, Plots.jl. There are some another great packages like Gadfly.jl and VegaLite.jl, but Plots will be the best to get you started. Let's import the library with the 'using' keyword and start making some plots. We will plot the first ten numbers of the fibonacci sequence using the ```scatter()``` function.
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
In the example above, a plot is created when we call the plot() function. What the scatter!() call then does, is to modify the global state of the plot in-place. If not done this way, both plots wouldn't be sketched together.
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
# ╠═292d20ea-5a8e-11eb-2a96-a37689e468ca
# ╟─01ca39ee-5a9c-11eb-118e-afae416cfca4
# ╟─d1ae60a8-544e-11eb-15b5-97188dc41aa8
# ╟─e36a4352-544e-11eb-2331-43f864bb01d5
# ╠═eb62587c-544e-11eb-2cdf-833c27b9793c
# ╟─f453c7b0-544e-11eb-137c-1d027edb83e6
# ╠═03641078-544f-11eb-1dab-37614a0bdbc7
# ╠═093aac02-544f-11eb-1221-4dfc049d4652
# ╟─11f33ecc-544f-11eb-35d5-27a280cdce1b
# ╟─190ab9c4-544f-11eb-1460-9fbf13dc8516
# ╟─1f2086cc-544f-11eb-339e-1d31f4b4eb4b
