## Data Science in Julia for Hackers
A book written by Federico Carrone, Herman Obst Demaestri and Mariano Nicolini.

Thanks to Martina Cantaro, Camilo Plata, Manuel Puebla, Lucas Raúl Fernandez Piana, Osvaldo Martin, Iñaki Garay and Mariana Vinyolas.

## Prologue
>*We have a habit in writing articles published in scientific journals to make the work as finished as possible, to cover up all the tracks, to not worry about the blind alleys or describe how you had the wrong idea first, and so on* - **Richard Feynman**

>*Only that what’s open can be true. Full transparency is best for me and you* - **OpenBSD**

One of the first things to note about this book is that it is not an academic textbook. We are not academics, and we are not experts in the topics we are going to discuss, but we are passionate, proudly amateur enthusiasts, with multidisciplinary backgrounds, which range from Engineering, Informatics, Physics and Economy, that converged their approaches in this book, and that day by day keep reading, learning and training about new approaches, technologies, techniques and ways of thinking. 
This book lies somewhere in between a methodological recipe and a theoretical intensive textbook. What we want to deliver in this book is a mathematical and computational methodology to face concrete Data Science problems, that is, applying theory and science to real-world problems involving data. The relationship between theory and practice is complex. Considering them as a whole can take us much farther. These pages may offer the theorist a way to think about problematic situations in a more down to earth manner, and to the practitioner, stimulation to go beyond the mere application of programming libraries and tools.

As the name of the book states, this is a book for Hackers. This word has been used for a long time in very different contexts. Ironically, the term can have opposite connotations, depending who is pronouncing it and to whom it is refers to. 
In media and pop culture, the term is mostly used to referentiate cyber-criminals, people who use computer techniques with malicious intensions like stealing you money or information. In the informatics field, various conceptions of the term exist too. But they generally coincide in that it has not necessarily a bad connotation. In the cyber-security niche, hackers are, as stated in the final chapter of *Hacking: The Art of Exploitation* by Jon Erickson, "...just people with innovative spirits and an in-depht knowledge of technology". But the definition we found most suitable in relation to the message we want to communicate, is borrowed from [The Jargon File's](http://www.catb.org/jargon/html/index.html) glossary, written by Eric S. Raymond,
> "A person who delights in having an intimate understanding of the internal workings of a system, computers and computer networks in particular."

In this sense is that this book is for Hackers: it will lead you in a route with a results-driven perspective, slowly growing intuition about the inner workings of many problematic situations involving data and what they all have in common, with a priority on application and streching capabilities.
The name of the book is also an inspiration from the great [Bayesian Methods for Hackers](http://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/), which had a great influence in the topics and the approach of this book.

The situations presented in the book are diverse, reflecting the interdisciplinary nature of Data Science. The solutions, however don't try to be beautiful or perfect. We know that the path to resolving real-life problems is muddy, that sometimes you might feel lost and that your ideas may change as you try to find the solution, but we encourage to embrace this non-elegant features and accept the sharp corners in this learning-through-solving journey. Suggestions, criticism and feedback are very appreciated, this book is alive and will evolve as a consequence of it's environment response. 

Although this book isn't intended to have obscure, overly-technical or academic definitions that may scare the reader, people with a little of programming knowledge, basic understanding of Calculus and some modelling intuition will get the most out of these pages. Namely, familiarity with a high-level language like Python, taking derivatives and some function analysis. 
All chapters include the code for the reader to play, explore and implement the solutions on their own. Moreover, links to notebooks with the worked solutions are available. 

Why Data Science in Julia? There are several reasons why Julia makes for a great language for this field. One of the first features anyone who takes a look at Julia code will probably notice, is the readability it offers, even more when talking about math-related computations. Julia is designed for math from the ground up, and considering the great amounts of math involved in Data Science, this turns the language into a very convenient framework where to express concepts related to this field.
Another interesting aspect of Julia appears if we consider the historical background of the language. Developed by a team of scientists, it comes to adress problems they typically encounter when doing research. Very often, scientists are faced with complicated situations that need to aglomerate various tools and find an equilibrium point among many requirements. This leads researchers to invest a lot of time and work in learning to use tools that are typically just a necessary evil to build knowledge. Julia makes the perfect tool for these needs, being suited to implement code easily and fast in an explorative process, and allowing to have highly performant code with some minor tweaks, all in the same language. Moreover, features like multiple-dispatch and simple syntax, generates great composability between packages, as well as scalability, making the task of writing software much more human and maintainable.


## Table of contents

### Part I: Data Science and Julia
* [First chapter](https://datasciencejuliahackers.com/01_science_technology_and_epistemology.jl.html): Science, technology, models and epistemology. 

* [Second chapter](https://datasciencejuliahackers.com/02_julia_intro.jl.html): 
 Introduction to the Julia programming language, showing examples of code and some first steps. 

### Part II: Bayesian Statistics
* [Third chapter](https://datasciencejuliahackers.com/03_probability_intro.jl.html): An introduction to probability, probability distributions and Bayes' interpretation. 

* [Fourth chapter](https://datasciencejuliahackers.com/04_naive_bayes.jl.html): Using a Naive-Bayes approach we construct a simple spam email filter.

* [Fifth chapter](https://datasciencejuliahackers.com/05_prob_prog_intro.jl.html): An introduction to Probabilistic Programming and some simple examples using the Turing.jl package.

* [Sixth chapter](https://datasciencejuliahackers.com/06_gravity.jl.html): We estimate the gravity of Mars to compute the escape velocity, throwing stones and taking very simple measurements from it.

* [Seventh chapter](https://datasciencejuliahackers.com/07_football_simulation.jl.html): We use a hierarchical bayesian model to estimate latent variables that describe Premier League´s football teams.

* [Eighth chapter](https://datasciencejuliahackers.com/08_basketball_shots.jl.html): We analyze how the scoring probability is affected by some variables, such as the distance from the hoop and the angle of shooting.

* [Ninth chapter](https://datasciencejuliahackers.com/09_optimal_pricing.jl.html): We solve a problem of optimal pricing optimization using a bayesian point of view.

### Part III: Machine Learning
* Work in progress

### Part IV: Deep Learning
* [Tenth chapter](https://datasciencejuliahackers.com/10_bees_vs_wasps.jl.html): Overview of Machine Learning and implementation of a simple convolutional neural network that is able to discriminate between pictures of bees and wasps.

### Part V: Scientific Machine Learning
* [Eleventh chapter](https://datasciencejuliahackers.com/11_ultima_online.jl.html): We explain the Ultima Online Catastrophe using differential equations to build a population dynamics model.

* [Twelfth chapter](https://datasciencejuliahackers.com/12_ultima_continued.jl.html): A continuation of the Ultima Online Catastrophe, introducing the Universal Differential Equations to recover missing parts of scientific models.

### Part VI: Time Series and Forecasting
* [Thirteenth chapter](https://datasciencejuliahackers.com/13_time_series.jl.html): We lay the foundations for time series analysis, focusing on the exponential smoothing method.

