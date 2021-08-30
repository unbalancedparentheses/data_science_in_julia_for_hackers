### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ eb62587c-544e-11eb-2cdf-833c27b9793c
begin
	using Plots
	
	sequence = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

	scatter(sequence, xlabel="n", ylabel="Fibonacci(n)", color="purple", label=false, size=(450, 300))
end

# ╔═╡ 123c9e1a-5f25-11eb-2aa8-756adae10d51
begin
	using DataFrames, Random
	
	Random.seed!(123)
	
	fake_data = rand(5, 5) # this creates a 5x5 matrix with random values between 0 
						   # and 1 in each matrix element.
	
	df = DataFrame(fake_data, :auto)
end

# ╔═╡ 9917300e-5fe2-11eb-2bed-e1891671fdd6
begin
	using CSV
	
	iris_df = CSV.File("./data/Iris.csv") |> DataFrame
end

# ╔═╡ e7c41f16-8b46-11eb-0cfc-776986dd6049
md"### To do list

We are currently working on:


";

# ╔═╡ 41e20700-9881-11eb-3067-d54b34ae1f92
md"
# Why Julia
People have asked us why we wrote this book using Julia instead of Python or R, which are the current standards in the data science world. 
While Python and R are also great choices, Julia is an up and coming language that will surely have an impact in the coming years.

It performs faster than pure R and Python (as fast as C) while maintaining the same degree of readability, allowing us to write highly performant code in a simple way.
Julia is already being used in many top-tier tech companies and scientific research —there are plenty of scientists and engineers of different disciplines collaborating with Julia, which gives us a wide range of possibilities to approach different problems.
Often, libraries in languages like Python or R are optimized to be performant, but this usually involves writing code in other languages better suited for this task such as C or Fortran, as well as writing code to manage the communication between the high level language and the low level one. 
Julia, on the other hand, expands the possibilities of people who have concrete problems that involve a lot of computation. 
Libraries can be developed to be performant in plain Julia code, following some basic coding guidelines to get the most out of it. 
This enables useful libraries to be created by people without programming or Computer Science expertise.

"

# ╔═╡ 0a4fc5fc-544d-11eb-0189-6b1c959b1eb1
md"
# Meeting Julia

Julia is a free and open-source general-purpose language, designed and developed by Jeff Bezanson, Alan Edelman, Viral B. Shah and Stefan Karpinski at MIT. 
Julia is created from scratch to be both fast and easy to understand, even for people who are not programmers or computer scientists. It has abstraction capabilities of high-level languages, while also being really fast, as its slogan calls “Julia looks like Python, feels like Lisp, runs like Fortran”.

Before Julia, programming languages were limited to either having a simple syntax and good abstraction capabilities and therefore user-friendly or being high-performance, which was necessary to solve resource-intensive computations.
This led applied scientists to face the task of not only learning two different languages, but also learning how to have them communicating with one another. 
This difficulty is called the two-language problem, which Julia creators aim to solve with this new language. 

Julia is dynamically typed and great for interactive use. It also uses multiple dispatch as a core design concept, which adds to the composability of the language. In conventional, single-dispatched programming languages, when invoking a method, one of the arguments has a special treatment since it determines which of the methods contained in a function is going to be applied. Multiple dispatch is a generalization of this for all the arguments of the function, so the method applied is going to be the one that matches exactly the number of types of the function call.

"

# ╔═╡ c2272800-6007-11eb-1736-b7f334dbba2f
md"
## Installation
For the installation process, we recommend you follow the instructions provided by the Julia team:
> [Platform Specific Instructions for Official Binaries](https://julialang.org/downloads/platform/): These instructions will get you through a fresh installation of Julia depending on the specifications of your computer. It is a bare bones installation, so it will only include the basic Julia packages.

All along the book, we are going to use specific Julia packages that you have to install before calling them in your code. Julia has a built-in packet manager that makes the task of installing new packages and checking compatibilities very easy.
First, you will need to start a Julia session. For this, type in your terminal
```julia
~ julia
julia>
```

At this point, your Julia session will have started. What you see right now is a 
**Julia REPL** (read-eval-print loop), an interactive command line prompt. Here you 
can quickly evaluate Julia expressions, get help about different Julia functionalities
and much more. The REPL has a set of different modes you can activate with different keybindings. The *Julian mode* is the default one, where you can directly type any Julia expression and press the Enter key to evaluate and print it. The *help mode* is activated with an interrogation sign '?'. You will notice that the prompt will now change,

```julia
julia> ?
help?>
```
By typing the name of a function or a Julia package, you will get information about it as well as usage examples.
Another available mode is the *shell mode*. This is just a way to input terminal commands in your Julia REPL. You can access this mode by typing a semicolon,

```julia
julia> ;
shell>
```

Maybe one of the most used, along with the default Julian mode, is the *package manager mode*. When in this mode, you can perform tasks such as adding and updating packages. It is also useful to manage project environments and controlling package versions. To switch to the package manager, type a closing square bracket ']',

```julia
julia> ]
(@v1.5) pkg>
```
If you see the word 'pkg' in the prompt, it means you accessed the package manager successfully. To add a new package, you just need to write

```julia
(@v1.5) pkg> add NewPackage
```

It is as simple as that! All Julia commands are case-sensitive, so be sure to write the package name –and in the future, all functions and variables too– correctly.

"

# ╔═╡ 292d20ea-5a8e-11eb-2a96-a37689e468ca
md"
## First steps into the Julia world
As with every programming language, it is useful to know some of the basic operations and functionalities. We encourage you to open a Julia session REPL and start experimenting with all the code written in this chapter to start developing an intuition about the things that make Julia code special.

The common arithmetical and logical operations are all available in Julia:

* $ + $: Add operator
* $ - $: Subtract operator
* $ * $: Product operator
* $ / $: Division operator

Julia code is intended to be very similar to math. So instead of doing something like
```julia
julia> 2*x
```
you can simply do
```julia
julia> 2x
```

For this same purpose, Julia has a great variety of unicode characters, which enable us to write things like Greek letters and subscripts/superscripts, making our code much more beautiful and easy to read in a mathematical form. In general, unicode characters are activated by using '\', followed by the name of the character and then pressing the 'tab' key. For example,
```julia
julia> \beta # and next we press tab
julia> β
```


You can add subscripts by using '_' and superscripts by using '^', followed by the character(s) you want to modify and then pressing Tab. For example, 
```julia
julia> L\_0 # and next we press tab
julia> L₀
```

Unicodes behave just like any other letter of your keyboard. You can use them inside strings or as variable names and assign them a value.
```julia
julia> β = 5
5

julia> \"The ⌀ of the circle is $β \"
\"The ⌀ of the circle is 5 \"
```

Some popular Greek letters already have their values assigned.
```julia
julia> \pi # and next we press tab
julia> π
π = 3.1415926535897...

julia> \euler # and next we press tab
julia> ℯ
ℯ = 2.7182818284590...
```
You can see all the unicodes supported by Julia [here](https://docs.julialang.org/en/v1/manual/unicode-input/) 

The basic number types are also supported in Julia. We can explore this with the function `typeof()`, which outputs the type of its argument, as it is represented in Julia. Let's see some examples,

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
md"""
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

You can access a particular character of a string by writing the index of that character in the string between brackets right next to it. Likewise, you can access a substring by writing the first and the last index of the substring you want, separated by a colon, all this between brackets. This is called *slicing*, and it will be very useful later when working with arrays. Here's an example:

```julia
julia> \"This is a Julia string!\"[1] # this will output the first character of the string and other related information.
'T': ASCII/Unicode U+0054 (category Lu: Letter, uppercase)

julia> \"This is a Julia string!\"[1:4] # this will output the substring obtained of going from the first index to the fourth
\"This\"
```

A really useful tool when using strings is *string interpolation*. This is a way to evaluate an expression inside a string and print it. This is usually done by writing a dollar symbol $ \$  $ followed by the expression between parentheses. For example,

```julia
julia> \"The product between 4 and 5 is $(4 * 5)\"
\"The product between 4 and 5 is 20\"
```
This wouldn't be a programming introduction if we didn't include printing 'Hello World!', right? Printing in Julia is very easy. There are two functions for printing: `print()` and `println()`. The former will print the string you pass in the argument, without creating a new line. What this means is that, for example, if you are in a Julia REPL and you call the `print()` function two or more times, the printed strings will be concatenated in the same line, while successive calls to the `println()` function will print every new string in a new, separated line from the previous one.
So, to show this we will need to execute two print actions in one console line. 
To execute multiple actions in one line you just need to separate them with a ;.


```julia
julia> print("Hello"); print(" world!")
Hello world!


julia> println("Hello"); println("world!")
Hello
world!
```

It's time now to start introducing collections of data in Julia. We will start by talking about arrays.  As in many other programming languages, arrays in Julia can be created by listing objects between square brackets separated by commas. For example, 

```julia
julia> int_array = [1, 2, 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> str_array = [\"Hello\", \"World\"]
2-element Array{String,1}:
 \"Hello\"
 \"World\"
```

As you can see, arrays can store any type of data. If all the data in the array is of the same type, it will be compiled as an array of that data type. You can see that in the pattern that the Julia REPL prints out:

1. Firstly, it displays how many elements there are in the collection. In our case, 3 elements in int\_array and 2 elements in str\_array. When dealing with higher dimensionality arrays, the shape will be informed.


2. Secondly, the output shows the type and dimensionality of the array. 
   The first element inside the curly brackets specifies the type of every member of the array, if they are all the same. If this is not the case, type 'Any' will appear, meaning that the collection of objects inside the array is not homogeneous in its type.

   Compilation of Julia code tends to be faster when arrays have a defined type, so it is recommended to use homogeneous types when possible.

   The second element inside the curly braces tells us how many dimensions there arein the array. Our example shows two one-dimensional arrays, hence a 1 is printed. Later, we will introduce matrices and, naturally, a 2 will appear in this place instead a 1.


3) Finally, the content of the array is printed in a columnar way.

When building Julia, the convention has been set so that it has column-major ordering.
So you can think of standard one-dimensional arrays as column vectors, and in fact this will be mandatory when doing calculations between vectors or matrices.


A row vector (or a $1$x$n$ array), in the other hand, can be defined using whitespaces instead of commas,

```julia
julia> [3 2 1 4]
1×4 Array{Int64,2}:
 3  2  1  4
```

In contrast to other languages, where matrices are expressed as 'arrays of arrays', in Julia we write the numbers in succession separated by whitespaces, and we use a semicolon to indicate the end of the row, just like we saw in the example of a row vector.
For example,

```julia
julia> [1 1 2; 4 1 0; 3 3 1]
3×3 Array{Int64,2}:
 1  1  2
 4  1  0
 3  3  1
```
The length and shape of arrays can be obtained using the `length()` and `size()` functions respectively.

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

As you can see, the expression returns an error. If you watch this error message closely, it gives you a good suggestion about what to do. If we now try writing a period '.' right before the plus sign, we get

```julia
julia> 2 .+ [1, 1, 1]
3-element Array{Int64,1}:
 3
 3
 3
```

What we did was broadcast the sum operator '+' over the entire array. This is done by adding a period before the operator we want to broadcast. In this way we can write complicated expressions in a much cleaner, simpler and compact way. This can be done with any of the operators we have already seen,

```julia
julia> 3 .> [2, 4, 5] # this will output a bit array with 0s as false and 1s as true
3-element BitArray{1}:
 1
 0
 0
```

If we do a broadcasting operation between two arrays with the same shape, whatever operation you are broadcasting will be done element-wise. For example,

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
We have already seen a for loop. For loops are started with a `for` keyword, followed by the name of the iterator and the range of iterations we want our loop to cover. Below this ```for``` statement we write what we want to be performed in each loop and we finish with an `end` keyword statement.
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

Conditional statements in Julia are very similar to most languages.
Essentially, a conditional statement starts with the `if` keyword, followed by the condition that must be evaluated to true or false, and then the body of the action to apply if the condition evaluates to true. Then, optional `elseif` keywords may be used to check for additional conditions, and an optional `else` keyword at the end to execute a piece of code if all of the conditions above evaluate to false. Finally, as usual in Julia, the conditional statement block finishes with an `end` keyword.

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

Here, we first made some variable assignments, variables $n1$, $n2$ and $m$ were assigned values 0, 1 and 10. Variables are assigned simply by writing the name of the 
variable followed by an 'equal' sign, and followed finally by the value you want to
store in that variable. There is no need to declare the data type of the value you are going to store.
Then, we defined the function body for the fibonacci series computation. Function blocks start with the `function` keyword, followed by the name of the function and the 
arguments between brackets, all separated by commas. In this function, the arguments 
will be the first two numbers of the sequence and the total length of the fibonacci 
sequence. 
Inside the body of the function, everything is indented. Although this is not strictly 
necessary for the code to run, it is a good practice to have from the beginning, since we want our code to be readable.
At first, we initialize an array of integers of one dimension and length $m$, by 
allocating memory. This way of initializing an array is not strictly necessary, you 
could have initialized an empty array and start filling it later in the code. But it is definitely a good practice to learn for a situation like this, where we know how long our array is going to be and optimizing code performance in Julia. 
The memory allocation for this array is done by initializing the array as we have already seen earlier. ```julia {Int64,1}```just means we want a one-dimensional array
of integers. The new part is the one between parenthesis, ```julia (undef, m)```. This 
just means we are initializing the array with undefined values –which will be later modified by us–, and that there will be a number $m$ of them. Don't worry too much if 
you don't understand all this right now, though.
We then proceed to assign the two first elements of the sequence and calculate the 
rest with a for loop. Finally, an `end` keyword is necessary at the end of the for loop and another one to end the definition of the function.
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

Remember the broadcasting operation, that dot we added to the beginning of another operator to apply it on an entire collection of objects? It turns out that this can be done with functions as well! Consider the following function,

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

As you can see, we broadcasted the `isPositive()` function over every element of an array by adding a dot next to the end of the function name.
It is as easy as that! Once you start using this feature, you will notice how useful it is.
One thing concerning functions in Julia is the 'bang'(!) convention. Functions that have a name ending with an exclamation mark (or bang), are functions that change their inputs in-place. Consider the example of the pop! function from the Julia Base package. Watch closely what happens to the array over which we apply the function.

```julia
julia> arr = [1, 2, 3]
julia> n = pop!(arr)
3
julia> arr
2-element Array{Int64,1}:
 1
 2
julia> n
3
```
Did you understand what happened? First, we defined an array. Then, we applied the `pop!()` function, which returns the last element of the array and assigns it to n. 
But notice that when we call our arr variable to see what it is storing, now the number 3 is gone. 
This is what functions with a bang do and what we mean with modifying *in-place*. 
Try to follow this convention whenever you define a function that will modify other objects in-place!

Sometimes, you will be in a situation where you may need to use some function, but you don't really need to give it name and store it, because it's not very relevant to your code.
For these kinds of situations, an *anonymous* or *lambda* function may be what you need.
Typically, anonymous functions will be used as arguments to higher-order functions. This is just a fancy name to functions that accept other functions as arguments, that is what makes them of higher-order.
We can create an anonymous function and apply it to each element of a collection by using the ```map()``` keyword. 
You can think of the `map()` function as a way to broadcast any function over a collection.
Anonymous functions are created using the arrow ```->``` syntax. At the left-hand side of the arrow, you must specify what the arguments of the function will be and their name.
At the right side of the arrow, you write the recipe of the things to do with these arguments.
Let's use an anonymous function to define a not-anonymous function, just to illustrate the point.

```julia
julia> f = (x,y) -> x + y 
#1 (generic function with 1 method)
julia> f(2,3)
5
```
You can think about what we did as if $f$ were a variable that is storing some function. Then, when calling $f(2,3)$ Julia understands we want to evaluate the function it is storing with the values 2 and 3.
Let's see now how the higher-order function ```map()``` uses anonymous functions.
We will broadcast our anonymous function x^2 + 5 over all the elements of an array.

```julia
julia> map(x -> x^2 + 5, [2, 4, 6, 3, 3])
5-element Array{Int64,1}:
  9
 21
 41
 14
 14
```

The first argument of the map function is another function. You can define new functions and then use them inside map, but with the help of anonymous functions you can simply create a throw-away function inside map's arguments. This function we pass as an argument, is then applied to every member of the array we input as the second argument.

"""

# ╔═╡ fda97ed8-875f-11eb-372e-4f982ff9b958
md"""
Now let's introduce another data collection: Dictionaries.

A dictionary is a collection of key-value pairs.
You can think of them as arrays, but instead of being indexed by a sequence of numbers they are indexed by keys, each one linked to a value.

To create a dictionary we use the function `Dict()` with the key-value pairs as arguments.

`Dict(key1 => value1, key2 => value2)`.

```julia
julia> Dict("A" => 1, "B" => 2)
Dict{String,Int64} with 2 entries:
  "B" => 2
  "A" => 1
```
So we created our first dictionary.
Let's review what the Julia REPL prints out:

`Dict{String,Int64}` tells us the dictionary data type that Julia automatically assigns to the pair (key,value).
In this example, the keys will be strings and the values, integers.
Finally, it prints all the (key => value) elements of the dictionary.

In Julia, the keys and values of a dictionary can be of any type.

```julia
julia> Dict("x" => 1.4, "y" => 5.3)
Dict{String,Float64} with 2 entries:
  "x" => 1.4
  "y" => 5.3

julia> Dict(1 => 10.0, 2 => 100.0)
Dict{Int64,Float64} with 2 entries:
  2 => 100.0
  1 => 10.0
```
Letting Julia automatically assign the data type can cause bugs or errors when adding new elements.
Thus, it is a good practice to assign the data type of the dictionary ourselves. 
To do it, we just need to indicate it in between brackets { } after the `Dict` keyword:

`Dict{key type, value type}(key1 => value1, key2 => value2)`

```julia
julia> Dict{Int64,String}(1 => "Hello", 2 => "Word")
Dict{Int64,String} with 2 entries:
  2 => "Word"
  1 => "Hello"
```
Now let's see the dictionary's basic functions.

First, we will create a dictionary called "languages" that contains the names of programming languages as keys and their release year as values.

```julia
julia> languages = Dict{String,Int64}("Julia" => 2012, "Java" => 1995, "Python" => 1990)

Dict{String,Int64} with 3 entries:
  "Julia"  => 2012
  "Python" => 1990
  "Java"   => 1995

```

To grab a key's value we need to indicate it in between brackets [].

```julia
julia> languages["Julia"]
2012
```

We can easily add an element to the dictionary.

```julia
julia> languages["C++"] = 1980
1980

julia> languages
Dict{String,Int64} with 4 entries:
  "Julia"  => 2012
  "Python" => 1990
  "Java"   => 1995
  "C++"    => 1980
```

We do something similar to modify a key's value:

```julia
julia> languages["Python"] = 1991
1991

julia> languages
Dict{String,Int64} with 3 entries:
  "Julia"  => 2012
  "Python" => 1991
  "C++"    => 1980

```
Notice that the ways of adding and modifying a value are identical.
That is because keys of a dictionary can never be repeated or modified. Since each key is unique, assigning a new value for a key overrides the previous one.


To delete an element we use the `delete!` method.
```julia
julia> delete!(languages,"Java")
Dict{String,Int64} with 3 entries:
  "Julia"  => 2012
  "Python" => 1990
  "C++"    => 1980
```

To finish, let's see how to iterate over a dictionary.

```julia
julia> for(key,value) in languages
               println("$key was released in $value")
       end
Julia was released in 2012
Python was released in 1991
C++ was released in 1980
```

"""


# ╔═╡ fe6c55de-875f-11eb-205c-53d913ae225f
md"
Now that we have discussed the most important details of Julia's syntax, let's focus our attention on some of the packages in Julia's ecosystem."

# ╔═╡ d1ae60a8-544e-11eb-15b5-97188dc41aa8
md"
# Julia's Ecosystem: Basic plotting and manipulation of DataFrames
Julia's ecosystem is composed by a variety of libraries which focus on technical domains such as Data Science (DataFrames.jl, CSV.jl, JSON.jl), Machine Learning (MLJ.jl, Flux.jl, Turing.jl) and Scientific Computing (DifferentialEquations.jl), as well as more general purpose programming (HTTP.jl, Dash.jl). 
We will now consider one of the libraries that will be accompanying us throughout the book to make visualizations, Plots.jl. 

To install the Plots.jl library we need to go to the Julia package manager mode as we saw earlier.

```julia
julia> ]
(@v1.5) pkg>
(@v1.5) pkg> add Plots.jl
```

There are some other great packages like Gadfly.jl and VegaLite.jl, but Plots will be the best to get you started. Let's import the library with the 'using' keyword and start making some plots. 
We will plot the first ten numbers of the fibonacci sequence using the ```scatter()``` function.


"

# ╔═╡ e36a4352-544e-11eb-2331-43f864bb01d5
md"
### Plotting with Plots.jl
Let's make a plot of the 10 first numbers in the fibonacci sequence. For this, we can make use of the ```scatter()``` function:
"

# ╔═╡ f453c7b0-544e-11eb-137c-1d027edb83e6
md"
The only really important argument of the scatter function in the example above is *sequence*, the first one, which tells the function what is the data we want to plot. The other arguments are just details to make the visualization prettier. Here we have used the scatter function because we want a discrete plot for our sequence. In case we wanted a continuous one, we could have used `plot()`. Let's see this applied to our fibonacci sequence:
"

# ╔═╡ 03641078-544f-11eb-1dab-37614a0bdbc7
plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))

# ╔═╡ 093aac02-544f-11eb-1221-4dfc049d4652
begin
	plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))
	scatter!(sequence, label=false, color="purple", size=(450, 300))
end

# ╔═╡ 53a0950c-6d79-11eb-0914-4de1f259e95e
md"
In the example above, a plot is created when we call the ```plot()``` function. What the ```scatter!()``` call then does, is to modify the global state of the plot in-place. If not done this way, both plots wouldn't be sketched together.

A nice feature that the Plots.jl package offers, is the fact of changing plotting backends. There exist various plotting packages in Julia, and each one has its own special features and aesthetic flavour. The Plots.jl package integrates these plotting libraries and acts as an interface to communicate with them in an easy way.
By default, the ```GR``` backend is the one used. In fact, this was the plotting engine that generated the plots we have already done. The most used and maintained plotting backends up to date, are the already mentioned ```GR```, ```Plotly/PlotlyJS```, ```PyPlot```, ```UnicodePlots``` and ```InspectDR```.
The backend you choose will depend on the particular situation you are facing. For a detailed explanation on backends, we recommend you visit the Julia Plots [documentation](https://docs.juliaplots.org/latest/backends/). Through the book we will be focusing on the ```GR```backend, but as a demonstration of the ease of changing from one backend to another, consider the code below.
The only thing added to the code for plotting that we have already used, is the ```pyplot()``` call to change the backend. If you have already coded in Python, you will feel familiar with this plotting backend. 
"

# ╔═╡ 7572d6ac-7127-11eb-1dec-9d5919434ca0
begin
	pyplot()
	plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))
	scatter!(sequence, label=false, color="purple", size=(450, 300))
end

# ╔═╡ aeb24808-7136-11eb-3f55-b55c445423fa
md"
Analogously, we can use the ```plotlyjs``` backend, which is specially suited for interactivity.
"

# ╔═╡ 1c5c95e4-7138-11eb-0116-314aab362756
begin
	plotlyjs()
	plot(sequence, xlabel="x", ylabel="Fibonacci", linewidth=3, label=false, color="green", size=(450, 300))
	scatter!(sequence, label=false, color="purple", size=(450, 300))
end

# ╔═╡ 0ae33f2c-7139-11eb-1239-5bb34937a949
md"
Each of these backends has its own scope, so there may be plots that one backend can do that other can't. For example, 3D plots are not supported for all backends. The details are well explained in the Julia documentation.
"

# ╔═╡ 11f33ecc-544f-11eb-35d5-27a280cdce1b
md"
### Introducing DataFrames.jl
When dealing with any type of data in large quantities, it is essential to have a 
framework to organize and manipulate it in an efficient way. If you have previously 
used Python, you probably came across the Pandas package and dataframes. In Julia, the DataFrames.jl package follows the same idea.
Dataframes are objects with the purpose of structuring tabular data in a smart way. You can think of them as a table, a matrix or a spreadsheet. 
In the dataframe convention, each row is an observation of a vector-type variable, and each column is the complete set of values of a given variable, across all observations. In other words, for a single row, each column represents a realization of a variable. 
Let's see how to construct and load data into a dataframe. There are many ways you can accomplish this. Consider we had some data in a matrix and we want to organize it in a dataframe. First, we are going to create some 'fake data' and loading that in a Julia DataFrame,
"

# ╔═╡ 7fbacda8-5f3f-11eb-2d85-c702f205cc6b
md"
As you can see, the column names were initialized with values $x1, x2, ...$. 
We probably would want to rename them with more meaningful names. To do this, we have the ```rename!()``` function. Remember that this function has a bang, so it changes the dataframe in-place, be careful!
Below we rename the columns of our dataframe,
"

# ╔═╡ 340ee342-5f46-11eb-224e-c33007e70b4a
rename!(df, ["one", "two", "three", "four", "five"])

# ╔═╡ d38bbbfc-5f46-11eb-2453-efa50f8bfae0
md"
The first argument of the function is the dataframe we want to modify, and the second an array of strings, each one corresponding to the name of each column. Another way to create a dataframe is by passing a list of variables that store arrays or any collection of data. For example,
"

# ╔═╡ c820403e-5f47-11eb-1f3c-35a128d1f990
DataFrame(column1=1:10, column2=2:2:20, column3=3:3:30)

# ╔═╡ 7ea669ca-5f48-11eb-2341-eb3ee9f959e8
md"
As you can see, the name of each array is automatically assigned to the columns of the dataframe. 
Furthermore, you can initialize an empty dataframe and start adding data later if you want,
"

# ╔═╡ 8b6d3ac8-5f49-11eb-1a34-9524509f41ac
begin
	df_ = DataFrame(Names = String[],
				Countries = String[],
				Ages = Int64[])
	df_ = vcat(df_, DataFrame(Names="Juan", Countries="Argentina", Ages=28))
end

# ╔═╡ 758cc9f2-5f4a-11eb-059d-6f7a46877bf2
md"
We have used the ```vcat()```function seen earlier to append new data to the Dataframe.

You can also add a new column very easily,
"

# ╔═╡ eb9c5a88-60b0-11eb-2553-9bdd07a9625d
begin
	df_.height = [1.72]
	df_
end

# ╔═╡ b8b22f14-60b0-11eb-1985-bb0104229c96
md"
You can access data in a DataFrame in various ways. One way is by the column name. For example, considering our `df` DataFrame, we can do
"

# ╔═╡ 60431b28-5f4f-11eb-2ada-c71526f5a8b5
df.three

# ╔═╡ 5f8669a0-5f50-11eb-2ad2-79ba19b0103c
df."three"

# ╔═╡ 6901d1b8-5f50-11eb-28c2-1f384653d8fa
md"
But you can also access dataframe data as if it were a matrix. You can treat columns either as their column number or by their name,
"

# ╔═╡ 816f1406-5f51-11eb-0fc2-9311f9488ce1
df[1,:]

# ╔═╡ a6e3925e-5f51-11eb-1611-3366446106e7
df[1:2, "one"]

# ╔═╡ b4987490-5f52-11eb-1605-6b5db8fce285
df[3:5, ["two", "four", "five"]]

# ╔═╡ e7f3b386-5f52-11eb-07f1-532a67807549
md"
The column names can be accessed by the ```names()``` function,
"

# ╔═╡ 71ddef62-5f53-11eb-0d3e-41823fb10639
names(df)

# ╔═╡ c7370ae6-5f55-11eb-2c5f-a3302af5354f
md"
Another useful tool for having a quick overview of the dataframe, typically when in an exploratory process, is the ```describe()``` function. It outputs some information about each column, as you can see below,
"

# ╔═╡ c83bca04-5f54-11eb-3190-3fbf4dde731a
describe(df)

# ╔═╡ 32211860-5f56-11eb-076a-d504b31ef94d
md"
To select data following certain conditions, you can use the ```filter()``` function. Given some condition, this function will throw away all the rows that don't evaluate the condition to true. This condition is expressed as an anonymous function and it is written in the first argument. In the second argument of the function, the dataframe where to apply the filtering is indicated. In the example below, all the rows that have their 'one' column value greater than $0.5$ are filtered.
"

# ╔═╡ 695a4a3e-5f58-11eb-278d-ddd3f24e5f85
filter(col -> col[1] < 0.5, df)

# ╔═╡ 94730e2a-5fdc-11eb-2939-0b1ec1283463
md"
A very usual application of dataframes is when dealing with CSV data. In case you are new to the term, CSV stands for Comma Separated Values. As the name indicates, 
these are files where each line is a data record, composed by values separated by 
commas. In essence, a way to store tabular data. A lot of the datasets around the 
internet are available in this format, and naturally, the DataFrame.jl package is well 
integrated with it. As an example, consider the popular Iris flower dataset. This 
dataset consists of samples of three different species of plants. The samples 
correspond to four measured features of the flowers: length and width of the sepals 
and petals. 
To work with CSV files, the package CSV.jl is your best choice in Julia. Loading a CSV file is very easy once you have it downloaded. Consider the following code,
"

# ╔═╡ c056d31a-5fe5-11eb-1cdd-43abf761bc90
md"
Here we used the pipeline operator ```|>```, which is mainly some Julia syntactic sugar. 
It resembles the flow of information. First, the ```CSV.File()```function, loads the CSV file and creates a CSV File object, that is passed to the ```DataFrame()```function, to give us finally a dataframe. 
Once you have worked on the dataframe cleaning data or modifying it, you can write a CSV text file from it and in this way, you can share your work with other people.
For example, consider I want to filter one of the species of plants, 'Iris-setosa', and then I want to write a file with this modified data to share it with someone,
"

# ╔═╡ da6fa616-6001-11eb-017f-5d75ec317675
begin
	filter!(row -> row.Species != "Iris-setosa", iris_df)
	CSV.write("./data/modified_iris.csv", iris_df)
end;

# ╔═╡ 3625d788-6d71-11eb-3878-97c4ad01ffb4
md"
Plotting Dataframes data is very easy. Suppose we want to plot the flower features from the iris dataset, all in one single plot. These features correspond to the columns two to five of the dataframe. Thinking about it as a matrix, you can access these data by selecting all the rows for each of the corresponding columns. In the code below, a loop is performed over the columns of interest. The ```plot()``` statement, with no arguments, is a way to create an empty instance of a plot, like a blank canvas. This empty plot will be successively overwritten by each call to ```plot!()```. Finally, we make a call to ```current()```, to display the plot. You may be wondering why this is necessary. Notice that all the plotting happens inside a loop, hence the plotting iterations are not displayed. It is more efficient to display the finished plot when the loop is over than to update each plot as it overwrites the previous one.
"

# ╔═╡ 08b5d43e-6d66-11eb-0645-91568ff3b368
begin
	gr()
	plot()
	for i in 2:5
		plot!(iris_df[:,i], legend=false)
	end
	xlabel!("Flower")
	ylabel!("Centimeters (cm)")
	title!("Flower features")
	current()
end
		

# ╔═╡ 03a43280-6003-11eb-1df8-a5833659f0a8
md"
### Summary
In this chapter we have introduced the Julia language, the motivations behind its creation, features, installation and basic building blocks for writing some code. 
First we discussed some basic Julia operators and datatypes. Some special features of the language such as how to write different kinds of arrays and broadcasting were detailed. We then followed with an overview of how functions work in Julia, and how to make your own.
Finally, we introduced some packages of the Julia ecosystem, mainly the Plots.jl package for plotting and changing backends, and DataFrames.jl for data organization and manipulation.
"

# ╔═╡ 1f2086cc-544f-11eb-339e-1d31f4b4eb4b
md"
### References
* [Julia's website](https://julialang.org/)
* [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/)
* [Learn X in Y minutes](https://learnxinyminutes.com/docs/julia/)
* [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia)
* [Julia Plots - Backends](https://docs.juliaplots.org/latest/backends/)
* [Data Science with Julia](https://www.amazon.com/Data-Science-Julia-Paul-McNicholas/dp/1138499986)
* [Comma Separated Values](https://en.wikipedia.org/wiki/Comma-separated_values)
* [Iris Dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set)
"

# ╔═╡ eb4b0fd0-8b48-11eb-0777-c9d72dfe20c7
md" ### Give us feedback


This book is currently in a beta version. We are looking forward to getting feedback and criticism:
  * Submit a GitHub issue **[here](https://github.com/unbalancedparentheses/data_science_in_julia_for_hackers/issues)**.
  * Mail us to **martina.cantaro@lambdaclass.com**

Thank you!

"

# ╔═╡ ecb0b100-8b4f-11eb-2f31-538ad792d76d
md"
[Next chapter](https://datasciencejuliahackers.com/03_probability_intro.jl.html)
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
CSV = "~0.8.5"
DataFrames = "~1.2.2"
Plots = "~1.21.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d59e8320c2747553788e4fc42231489cc602fa50"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.58.1+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "44e3b40da000eab4ccb1aecdc4801c040026aeb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.13"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
deps = ["Test"]
git-tree-sha1 = "15732c475062348b0165684ffe28e85ea8396afc"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.0.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "bfd7d8c7fd87f04543810d9cbd3995972236ba1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9ff1c70190c1c30aebca35dc489f7411b256cd23"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.13"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "0036d433cacff4767ff622be3cb2c281b773a2b4"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.21.1"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "cde4ce9d6f33219465b55162811d8de8139c0414"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "1f27772b89958deed68d2709e5f08a5e5f59a5af"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.7"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "54f37736d8934a12a200edea2f9206b03bdf3159"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.7"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "1700b86ad59348c0f9f68ddc95117071f947072d"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.1"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─e7c41f16-8b46-11eb-0cfc-776986dd6049
# ╟─41e20700-9881-11eb-3067-d54b34ae1f92
# ╟─0a4fc5fc-544d-11eb-0189-6b1c959b1eb1
# ╟─c2272800-6007-11eb-1736-b7f334dbba2f
# ╟─292d20ea-5a8e-11eb-2a96-a37689e468ca
# ╟─01ca39ee-5a9c-11eb-118e-afae416cfca4
# ╟─fda97ed8-875f-11eb-372e-4f982ff9b958
# ╟─fe6c55de-875f-11eb-205c-53d913ae225f
# ╟─d1ae60a8-544e-11eb-15b5-97188dc41aa8
# ╟─e36a4352-544e-11eb-2331-43f864bb01d5
# ╠═eb62587c-544e-11eb-2cdf-833c27b9793c
# ╟─f453c7b0-544e-11eb-137c-1d027edb83e6
# ╠═03641078-544f-11eb-1dab-37614a0bdbc7
# ╠═093aac02-544f-11eb-1221-4dfc049d4652
# ╟─53a0950c-6d79-11eb-0914-4de1f259e95e
# ╠═7572d6ac-7127-11eb-1dec-9d5919434ca0
# ╟─aeb24808-7136-11eb-3f55-b55c445423fa
# ╠═1c5c95e4-7138-11eb-0116-314aab362756
# ╟─0ae33f2c-7139-11eb-1239-5bb34937a949
# ╟─11f33ecc-544f-11eb-35d5-27a280cdce1b
# ╠═123c9e1a-5f25-11eb-2aa8-756adae10d51
# ╟─7fbacda8-5f3f-11eb-2d85-c702f205cc6b
# ╠═340ee342-5f46-11eb-224e-c33007e70b4a
# ╟─d38bbbfc-5f46-11eb-2453-efa50f8bfae0
# ╠═c820403e-5f47-11eb-1f3c-35a128d1f990
# ╟─7ea669ca-5f48-11eb-2341-eb3ee9f959e8
# ╠═8b6d3ac8-5f49-11eb-1a34-9524509f41ac
# ╟─758cc9f2-5f4a-11eb-059d-6f7a46877bf2
# ╠═eb9c5a88-60b0-11eb-2553-9bdd07a9625d
# ╟─b8b22f14-60b0-11eb-1985-bb0104229c96
# ╠═60431b28-5f4f-11eb-2ada-c71526f5a8b5
# ╠═5f8669a0-5f50-11eb-2ad2-79ba19b0103c
# ╟─6901d1b8-5f50-11eb-28c2-1f384653d8fa
# ╠═816f1406-5f51-11eb-0fc2-9311f9488ce1
# ╠═a6e3925e-5f51-11eb-1611-3366446106e7
# ╠═b4987490-5f52-11eb-1605-6b5db8fce285
# ╟─e7f3b386-5f52-11eb-07f1-532a67807549
# ╠═71ddef62-5f53-11eb-0d3e-41823fb10639
# ╟─c7370ae6-5f55-11eb-2c5f-a3302af5354f
# ╠═c83bca04-5f54-11eb-3190-3fbf4dde731a
# ╟─32211860-5f56-11eb-076a-d504b31ef94d
# ╠═695a4a3e-5f58-11eb-278d-ddd3f24e5f85
# ╟─94730e2a-5fdc-11eb-2939-0b1ec1283463
# ╠═9917300e-5fe2-11eb-2bed-e1891671fdd6
# ╟─c056d31a-5fe5-11eb-1cdd-43abf761bc90
# ╠═da6fa616-6001-11eb-017f-5d75ec317675
# ╟─3625d788-6d71-11eb-3878-97c4ad01ffb4
# ╠═08b5d43e-6d66-11eb-0645-91568ff3b368
# ╟─03a43280-6003-11eb-1df8-a5833659f0a8
# ╟─1f2086cc-544f-11eb-339e-1d31f4b4eb4b
# ╟─eb4b0fd0-8b48-11eb-0777-c9d72dfe20c7
# ╟─ecb0b100-8b4f-11eb-2f31-538ad792d76d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
