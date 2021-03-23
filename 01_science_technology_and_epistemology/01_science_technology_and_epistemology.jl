### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ ee92411c-5c28-11eb-2f22-2f275ae35b18
md"""
## The difference between Science and Technology

Anyone would agree that science and technology have a lot in common, but what are the essential differences between them? And how do they interact with each other? 
These are fundamental questions for us, and ones that most people don't have a clear answer for. 
This leads to misconceptions about key aspects on, for example, how knowledge is created and, more generally, how the world operates. 

One fundamental difference between the two is that while science tries to understand the physical world in which we live, technology aims to transform it. 
So, technology has a strong practical goal and science a more intellectual one. 
A very frequent misunderstanding that is nowadays very much encouraged by academia is to think that first, one needs to acquire all of the theoretical and formal knowledge about a subject matter before being able to apply it and transform reality. 
But in reality this is not the case. The process occurs, in most cases, in the opposite way: one lives in reality, interacts with it, takes action, makes mistakes, tries again, and in that way slowly discovers how the world works. 
And then, of course, it is useful to formalize our knowledge in order to be able to transmit that learning, lay solid foundations and to continue advancing in our understanding.

## What is technology?

Technology is the practice that allows us humans to transform reality. 
We have been doing it since the very beginning of the human era, and it is really what makes us different from other animals. 

Technology enables us to expand our capabilities.
From taking a long, pointy stick to reach fruit high up in a tree, to transforming an entire landscape by building a huge electric dam, to the creation of artificial intelligence that helps us solve our deepest puzzles. 
With technology we transform our experience in the world.

It is evident that the more we know about the reality in which we live, the more we will be able to modify it. 
But from this idea comes a very important question: what is the order in which innovation takes place? 
Is it necessary first to have an absolute understanding of the process we are trying to modify? 
Or is technology created in a more chaotic process, through trial and error?

Does a child need to know the gear mechanisms of a bicycle to learn to ride it? Does Lionel Messi need to know about fluid dynamics to make the ball take a curved trajectory? Did the Romans need to know the Navier-Stokes equation in order to build their huge aqueducts? 
Knowledge is often acquired through experimentation, implementation and heuristics, in a process that involves more trial and error and less theoretical knowledge than many believe.
And technological innovation tends to follows the same mechanism. Many breakthroughs were made by people who were taking risks, exploring, and stumbling in the dark with a destination in mind but no clear directions to get there, with theories only taking their definitive form once they arrived to a solution and were able to look back on what they had discovered.

The current understanding of how knowledge is produced does not reflect how it actually happens in many cases. Having a better understanding of this process can help us do it better.
Many people think of the innovation process as a more or less linear path that begins with theoretical discoveries, and only after formalization is achieved, practical uses are invented.
This type of thinking is counterproductive because, being so widespread, it causes many people to be more concerned with constantly acquiring theoretical knowledge, rather than taking action and immersing themselves in practice.
Fear of failure, of not getting it exactly right on the first try, also plays a role, perhaps encouraged by the way we tell stories about innovation.

By looking at the history of technology and innovation, and who writes it, we see that the people who made the discoveries are rarely the ones who write the books about them. 
As [Nassim Nicholas Taleb](https://en.wikipedia.org/wiki/Nassim_Nicholas_Taleb) said in "The History Written by the Losers", the people that are doing stuff don't have time for writing. 
And perhaps because the non-practitioners are the ones who write about the findings of others, as time goes by, society ends up being convinced that there was indeed an arduous intellectual and academic work first, and then came its implementation.
That –apparently– common sense in which knowledge is built from a purely intellectual work that can be done in the armchair at home, and that only after acquiring this sacred theoretical knowledge it is possible to come up with technology or innovation, is the one we need to question.

This confusion in the order in which technological advances occur is seen constantly and in the most varied areas of the history of innovation. 
Take, for example, the development of the jet engine. It really had nothing to do with the discoveries of physicists researching, but with the cleverness and practical heuristics based on trial and error that engineers had developed, although in academic books it is stated the other way around. Or in a really practical field, finances. For years, senior traders that have been deploying several heuristics to make their trades, build portfolios that are much more complex and better performing than the ones generated by the pricing formulas that academics came up with and often didn't stand the test of time.
And this happened because, in the process of trying to generalize these heuristics into formal equations, the academics are constantly introducing fragility. 
That is, in the process of finding the laws that rule those dynamic systems, lot of cases are ignored, something that doesn't happen to experienced traders. 
What cements the gap between theory and practice, is that finance PhDs then fail to understand how traders can correctly assign prices to financial derivatives without being familiar with a corpus of theorems that, to them, are indispensable to understand market dynamics.

In this book we will try to take you, the reader, through a journey that is more similar to the real way in which knowledge is built: an iterative, hands-on process of problem-solving that gradually builds intuitions about how things work and why, that we can later formalize.

"""

# ╔═╡ 1c60486a-5c2d-11eb-385e-417e8c4b7ddb
md"""### References

- Antifragile: Things That Gain from Disorder, ch 15 - Nassim Nicholas Taleb
- Infinite Powers: How Calculus Reveals the Secrets of the Universe - Steven Strogatz
- Lost in Math: How Beauty Leads Physics Astray - Sabine Hossenfelder
- [The Joy of X](https://www.amazon.com/Joy-Guided-Tour-Math-Infinity/dp/0544105850)
- [Kolmogorov - Mathematics: It's contents, method and meaning](https://www.amazon.com/Mathematics-Content-Methods-Meaning-Volumes/dp/0486409163)
- [Freeman Dyson - Where Do the Laws of Nature Come From?](https://youtu.be/wxRpa-PqUfw)
- [Roger Penrose - Is Mathematics Invented or Discovered?](https://youtu.be/ujvS2K06dg4)
- [How to tell science from pseudoscience](https://youtu.be/o9ylQC5bPpU)
- [Sabine Hossenfelder - Why the ‘Unreasonable Effectiveness’ of Mathematics?](https://youtu.be/QUWbe5KGaQY)
-  http://www.paulgraham.com/hp.html
- https://en.wikipedia.org/wiki/Apophatic_theology
- https://en.wikipedia.org/wiki/Falsifiability
- https://norvig.com/fact-check.html
- https://www.wired.com/2008/06/pb-theory/
- https://fs.blog/2016/01/karl-popper-on-science-pseudoscience/


"""

# ╔═╡ Cell order:
# ╟─ee92411c-5c28-11eb-2f22-2f275ae35b18
# ╟─1c60486a-5c2d-11eb-385e-417e8c4b7ddb
