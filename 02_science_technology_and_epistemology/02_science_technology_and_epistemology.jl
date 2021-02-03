### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ ee92411c-5c28-11eb-2f22-2f275ae35b18
md"""
## Brief talk about science, technology and epistemology


That´s a difficult question, doesn´t it? Neither in this chapter, nor in the entire 
book we pretend in any way to give an absolute answer, but we find it a very 
interesting debate, especially in a data science book like this one, and we want to 
give our insights in the matter. But we are not academics and we have no PhDs. We are 
just amateur enthusiasts and very passionate about what we do and the particular 
historical moment we are living on.
With this in mind, we are not going to be repeating al over the place things like "According to what we think..." or "Our opinion is that..." so that the reading is not overloaded, but you can read it that way. Let's start then!

=======>

Instead of starting with formal definitions, let's take an historical approach about  mathematics and it's relation to science and technology. This is not going to be a thorought It is very difficult to imagine science without mathematics, specially the so-called *natural sciences*. When there is a need of quantitative results, we know mathematics is the way to go. But, at least for some time in the past, math and science didn't have the relationship they have today. 
The first steps the humanity made into the mathematical world, were done to communicate ideas more efficiently. If I ask you what the simplest form of mathematics that comes to your mind is, you probably are going to think about counting. And essentially there is were everything started. To our minds, that are now accustomed to very complex ideas of all kinds, such as the internet or the economy, maybe counting doesn't sound like a very phenomenal idea. But think about the conceptual leap our ancestors had to make in order to arrive to an abstract construct such as a number. After all, what is a number? How does it look like? What comes to your mind when I speak about the number two? What do two cats and two roses have in common?
Numbers appeared as a way to have a more efficient communication. Steven Strogatz refers, in his book *The Joy of x*, to a particular episode of the *Sesame Street* show, '123 Count with Me'. Altough it may sound silly and childish, it makes a great metaphor of the usefulness of numbers. 
In the show, one of the characters, Humphrey, is working as a waiter in a restaurant and he takes an order of some penguins. When he calls out the order to the kitchen, he says: "Fish, fish, fish, fish, fish, fish". At this point, another character, Ernie, teaches Humphrey about the concept of numbers. 
As we make this first abstraction leap, new rules start appearing. When using numbers to characterize a collection of objects of the same kind, operations such as addition and substraction emerge naturally once the concept is created, almost as if they had a life of their own. 
As human culture and curiosity developed, new challenges appeared, and the relation between things and how they vary became a field of interest in mathematics and the physical sciences. In particular, physics cares about the relationship about different magnitudes of the real life –or phisical world–, and the tool to formalize these relations are *variables* and *functions*. These are the next step in mathematical abstraction. With variables, the conceptualization of magnitudes that change their value during a process was made evident, and altough this value changed, the magnitude itself remained to be the same. Moreover, functions were the key abstraction tool to represent how variables depend to another variables, and the concept of independent and dependent variables appears. 
For many years, the desire to understand the world and postulate physical laws motivated mathematical discovery. This is really easy to understand with the creation of Calculus by Newton and Leibnitz, one of the most important mathematical tools we have in our arsenal, which has today extended use along science, engineering, economy and many more fields. 
Alongside Calculus, another important and fundamental mathematical field started being conceptualized and developed. With the stimulus of games of chance and gambling, the mathematical theory of probability was born by Pascal and Fermat.
Almost in paralell, Statistics started as an applied field dealing with data from states, such as population demographics and economy, but it slowly growed and extended to the collection of any kind of data, its analysis, interpretation and the extraction of conclusions from it. The evolution process of Statistics was intimately related with the development of probability, and, with the Theory of errors, ultimately all three of these mathematical disciplines, Calculus, Probability and Statistics, played a fundamental role in hypothesis testing and scientific research. 

<=======	

### What is Science?
As a first approach, science is a method that aims to discover the principles -invariant laws- that describe the world. And note that we said "method", because is what it really is: A methodology which ensures that we are as objective and data-driven as possible.

So, science is a method we have founded to conclude that hypothesis we propose are not false. This doesn't mean they are true, and this is one of the core concepts of the scientific method. There are no dogmas in science, every proposition, claim, hypothesis or theory can be tested to try to falsify it. And everything happens in the context of a community; it makes no sense to talk about an hypothesis being false by its own, there must be a community that can validate and replicate the evidence.

And thats is really the essence of science. Basically, you make a hypothesis and start bombarding it with experiments and tests. But this is important, it really has to be a bombardment. And only after that, you can start thinking that **maybe**, that hypothesis is not false. And you will never be able to say that is true. 

Or at least thats how the Scientific method started. Nowadays things are a little bit different. The experimentation is not being as much rigorous as it used to be and, in some cases, it´s totally left behind. The pressure to produce academic "knowledge" and our multiple biases and beliefs (almost religious now) are interfering with the progress of science. 

Take, for example, the physics field. A science that undoubtedly contributed enormously to the development of humanity. But now, it seems that started a new romance. Modern theoretical physicists seem to have ended their relationship with experimentation because of a crazy love for "mathematical beauty". Tons and tons of paper, and **cero** experiments. It is somewhat worrying. And anyway, why the laws of our complex reality should be "elegant"? 

An interesting concept is that of the *Low hanging fruits*. It says something like "Instead of thinking that because the first laws we encounter are mathematically "beauty" all the rest of the laws that describe our vast world **must** be beauty too, wouldn't it be smarter of us to think that **because** those laws are nice and easy for us to understand they were the first to be found? And assume that there is no reason to the rest be the same? Of course our appe brains escape from things that we don´t know, but for this kind of problems is important to get our feet in the ground and attach to the scientific method.

And there are fields of science apart from physics, like biology or chemistry, that are examples of fields that doesn´t have any of this "beautiful" and extremely precise equations. In the rest of science, we have what is call "emergent laws" that arises from very complicated systems were the individual details doesn´t matter, but the system as a whole behave in a very specific and recognizable way.

And the problem is that classical approach in science tends to be reductive, ie, they reduce the system being studied to its component parts and fundamental laws, but, as mentioned in P. W. Anderson's paper, *More is different*, the ability to reduce everything to this simple fundamental building blocks does not inherently imply the ability to construct the world from them. Scale and complexity are two important factors that in conjunction break the reductionist point of view.

At each level of complexity, new properties appear that can't be derived from its constituent parts. As the need of studying systems with a big number of agents that interact in strange ways increases, complexity theory becomes a more important and relevant field in modern science. 

So maybe, just maybe, we are entering to a stage in which will be important for us to start embracing complexity and mathematical "ugliness".

### The scientific method

Okey, the science is complicated and possibly there are certain types of mindsets to rethink. So, in the process of doing so, how can we discern science from things that we should leave apart?. 

Well, an useful way to think of the science is that it main goal is to explain obvservations, and science do this through **models**. A model is a simplification of the reality in which we live, and allow as to make statements about observations that agree with measuraments. They can make statements about data because, with a model, we intent to capture patterns that the data present. So them are our tool to search for those invariant laws that we have talked in the beginning of the chapter. 

An important consequence of this "pattern capturing" is that the model **must** be simpler than the whole bunch of data we have colected. In a quantitative (and -too much- technical) point of view we can say that a model must not have more free parameters than data points that want to describe. When this happen, the model is adapting perfectly to the data and, in reality, it does not explaining anything. Moreover, in that case you would be much better off just looking at the data alone. Another way of see this is that when be capture a pattern, we **are** doing a simplification, and are precisely these simplifications the ones that allow us to gain a deeper understanding of the underling process happening. If we can find a model with these characteristics, we would say that it *explains* the data.

We can confidently say then, that models that adapt perfectly to the data just by having enough parameters (overfitting) are **not** scientific. It just learning the specific of that data and not explaning **nothing**. There are no higher level understanding of the phenomenom we are studying. 

But maybe we are beeing too much quantitative, even more so when taking into account that many fields of science are not. And it´s important to clarify that everything we've been talking about is still valid. The non-quantitative way of looking at this problem of "unscientific overfitting" is the **number of assumptions** that a given hypothesis have to make in order to explain data. Scientific models are the ones that explain the most data, with the minimum possible assumptions, *that* is the real key to differentiate between real science and scum. Take for example the queen of all unscientific theories: Conspiracy theories. You have to make a lot more assumptions to argue that the earth is flat (that there is a "group" that are lying to the rest of humanity since Plotemy, that the NASA has been falsifying every existing picture of the curvature of the earth, that every airline pilot has been brainwashed, and so on) that just make one or two simple experiments whose results inevitably suggest that the earth is round.

Then, every time you want to know if something is worth developing further, it´s a good practice to ask the question "how much data this is explaining, and with how many assumptions?" 

### And what about technology?

We just talked about a lot of issues revolving around science. We think a good conclusion is that the overall goal of science is to **understand** the reality in which we live. Having said that, a very science-related topic pops into our heads almost instantly: What about *technology*?

Well, here we get back into another quagmire. We think it almost goes without saying that science and technology are intimately related and in some ways feed back into each other. So it would be great if we could define it in a similar way. Well, we can think that if the goal of science is to understand the reality, the goal of technology is to **transform** it. We transform the reality in which we live by *expanding* our capacities, from taking a long stick with a point to reach a fruit high up in a tree, passing through transforming an entire landscape by building a huge electric dam, to the creation of artificial intelligence that helps us solve our deepest puzzles. With technology we transform our reality.

And here is when everything gets confusing because science and technology start interacting in a complex way: the more science we do, the more technology we can create; but also, as more technology we have (ie: [Large Hadron Collider](https://home.cern/science/accelerators/large-hadron-collider)), we can start digging in more and more intricate enigmas. The relationship is complex and generates a kind of multiplying virtuous circle.


But for us is important to go deeper, how is that relationship? And how is the process of knowledge discovery? 


Nowadays, there is a kind of "linear model" thinking in which we take for granted that the the process of producing knowledge is very define: We **firts** make academic and theoretical discoveries and **only then**, with all of that formalization made, we can start thinking of putting it to practical use in the real world. And for us, this is completely wrong thinking and is holding us back enormously, causing important funds to be misused.


If you start looking to the technology/innovation history you may gradually begin to notice a repeating pattern: There is a constant differentiation between the people who *do* and the people who *watch* and then narrate. "The History Written by the Losers" would [Nassim Nicholas Taleb](https://en.wikipedia.org/wiki/Nassim_Nicholas_Taleb) said, the people that are **doing stuff** doesn´t have time for beauty writing. But the thing does not stop there. It is not only the do-nothings who write about the findings of others, but also attribute it to them! And this comes from a worrying bias that has been developing throughout recent history: the linear thinking we are talking about. That common sense in which knowledge is built from a purely intellectual work that can be done in the armchair at home, and that after acquiring this sacred theoretical knowledge it is possible to become with technology or innovation.


So let´s think for a moment, does a child need to know the gear mechanisms of a bicycle, in order to be able to use it? or does messi need to know about fluid dynamics to make the ball take a curved trajectory? Maybe you are thinking that this is a very specific case, but the reality is that those example share a general and universal property: The knowledge is adquire base on experimentation, implementation and heuristics, pure trial and error. And technological innovation follow the same mechanism, it was discover by people that were  **taking risks, taking action, with a pure trial-and-error experiential manner** and, above all, without anyone truly understanding the theory behind.


In his book "Antifragile: Things That Gain from Disorder", Taleb (yes, we really like his ideas) problematizes this apparent "order" when it comes to generating innovation and lists a series of events/fields that were misrepresented by the "losers that write the history", generating the false illusion that theoretical discovery came before practice and the trial and error process. 

He is very clear when commenting that the development of the jet engine had nothing to do with the discoveries of physicists researching, but was thanks to the cleverness and anti-fragile heuristics based on trial and error that engineers had developed, although in academic books it is said that the process was the opposite. Or in his main field, finances. It is unbelievable how he describes how senior trader, that have been deploying several heuristics to made their trades, are much more complex that the ones generated by the pricing formulas that academics invented based the trial-and-error experiences of people who are immersed in the market. And this happen because, in the process of trying to generalizate this heuristics into formal equations, the academics are constantly introducing fragilities. And the worst thing? After doing so, finance PhDs can´t understand how traders can correctly assing prices to financial derivatives without knowing several theorems... So the wheel is broken.

### The way we see the world

And if we take that line of thinking and push deeper, we can start thinking about a much more "pure intellectual" field, Mathematics. And we can ask the question "Is mathematics invented or discovered?".
"""

# ╔═╡ 1c60486a-5c2d-11eb-385e-417e8c4b7ddb
md"""### References

- Antifragile: Things That Gain from Disorder, ch 15 - Nassim Nicholas Taleb
- [The Joy of X](https://www.amazon.com/Joy-Guided-Tour-Math-Infinity/dp/0544105850)
- [Kolmogorov - Mathematics: It's contents, method and meaning](https://www.amazon.com/Mathematics-Content-Methods-Meaning-Volumes/dp/0486409163)
- [Calculus - Wikipedia](https://en.wikipedia.org/wiki/Calculus)
- [History of Probability - Wikipedia](https://en.wikipedia.org/wiki/History_of_probability)
- [Freeman Dyson - Where Do the Laws of Nature Come From?](https://youtu.be/wxRpa-PqUfw)
- [Roger Penrose - Is Mathematics Invented or Discovered?](https://youtu.be/ujvS2K06dg4)
- [How to tell science from pseudoscience](https://youtu.be/o9ylQC5bPpU)
- [Sabine Hossenfelder - Why the ‘Unreasonable Effectiveness’ of Mathematics?](https://youtu.be/QUWbe5KGaQY)


"""

# ╔═╡ Cell order:
# ╠═ee92411c-5c28-11eb-2f22-2f275ae35b18
# ╟─1c60486a-5c2d-11eb-385e-417e8c4b7ddb
