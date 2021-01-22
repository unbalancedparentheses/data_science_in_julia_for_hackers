### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ ee92411c-5c28-11eb-2f22-2f275ae35b18
md"""
## Brief talk about science, technology and epistemology

### What is Science?

That´s a difficult question, doesn´t it? We don´t pretend in any way to give an absolute answer, but we find it a very interesting debate, especially in a data science book, and we wanted to leave our opinion. But that's it, nothing more than our humble opinion. So having said that, we are not going to be repeating throughout the chapter things like "According to what we think..." or "Our opinion is that..." so that the reading is not overloaded, but you can read it that way. Let's start then!

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

"""

# ╔═╡ 1c60486a-5c2d-11eb-385e-417e8c4b7ddb
md"""### References

- Antifragile: Things That Gain from Disorder, ch 15 - Nassim Nicholas Taleb

- [Freeman Dyson - Where Do the Laws of Nature Come From?](https://youtu.be/wxRpa-PqUfw)
- [Roger Penrose - Is Mathematics Invented or Discovered?](https://youtu.be/ujvS2K06dg4)
- [How to tell science from pseudoscience](https://youtu.be/o9ylQC5bPpU)
- [Sabine Hossenfelder - Why the ‘Unreasonable Effectiveness’ of Mathematics?](https://youtu.be/QUWbe5KGaQY)


"""

# ╔═╡ Cell order:
# ╟─ee92411c-5c28-11eb-2f22-2f275ae35b18
# ╟─1c60486a-5c2d-11eb-385e-417e8c4b7ddb
