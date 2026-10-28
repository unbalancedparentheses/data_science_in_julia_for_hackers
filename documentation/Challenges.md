# Experiments to try after each chapter

You have followed the example. Can you make a prediction before running the
next one? These challenges revisit Chapters 1–5 and 7–13. Chapter 6 and Chapters
14–17 have their own exercises in the chapter. Each sequence starts with a
question, changes one part of the experiment, and ends with something to build.

Write down your prediction and its reason first. Keep the original experiment
so you can compare it with your change. What happened, and why? Try to imagine
one change to the setup that would make your explanation stop working.

The hints and worked reasoning below are deliberately separate from the tasks.
For open projects, we work through one way to investigate the question;
you may find another plot or model that teaches you more. Use each chapter's environment for
code experiments. You can work through the intuition questions without Julia.

## Chapter 1 Models and explanations

**Predict.** Two models predict tomorrow's temperature equally well. Must they
give the same explanation of how the weather works?

**Change the experiment.** Imagine that one model copies yesterday's
temperature and the other uses a physical simulation. Describe a week in
which copying yesterday would be difficult to beat, and a situation that
could expose its weakness.

**Build.** Choose one everyday decision and write a small investigation:
the question, observations you could collect, two competing explanations,
and an observation that would make you reconsider each explanation.

### Hint and worked reasoning

Separate what a model predicts from why it predicts it. During a stable week,
copying yesterday may work well. A sudden change in weather can reveal its
limitation. The physical model is not guaranteed to win: its measurements or
approximations may be poor. Equal predictive performance over one dataset
does not establish equal mechanisms. A good investigation identifies evidence
that could distinguish the explanations, rather than merely collecting more
examples consistent with a favorite story.

## Chapter 2 Changing Julia data

**Predict.** What are `a` and `b` after running this code?

```julia
a = [1, 2, 3]
b = a
b[1] = 99
```

**Change the experiment.** Repeat with `b = copy(a)`. Then compare `sort(a)`
with `sort!(a)` on a fresh unsorted vector. Print the original vector after
each call, not just the returned value.

**Build.** Write a function that returns a sorted copy and its mean without
changing its input. Check it with a singleton vector and repeated values.
Choose and explain what your function should do with an empty vector.

### Hint and worked reasoning

Assignment gives `a` and `b` names for the same mutable vector; both display
`[99, 2, 3]`. `copy` creates a separate vector for this example. `sort` returns
a sorted copy, while `sort!` modifies its argument. A possible implementation
is `summarize(x) = (sorted=sort(x), average=sum(x)/length(x))` for nonempty
numeric vectors. Reject an empty vector explicitly, or return `missing` for
its mean. Test the input as well as the returned answer. The exclamation mark
is a naming convention, not a language-enforced guarantee about mutation.

## Chapter 3 When a rare event looks likely

**Predict.** A detector catches 90 percent of faulty parts and incorrectly
flags 10 percent of good parts. If only one percent of parts are faulty, are
most flagged parts faulty?

**Change the experiment.** Make a table for 10,000 parts, then change the fault
rate to 20 percent while keeping both detector rates fixed.

**Build.** Simulate the detector in Julia. Compare your simulated fraction of
faulty flagged parts with the table, and repeat with different sample sizes.

### Hint and worked reasoning

Count people or objects before dividing probabilities. At one percent there
are 100 faulty parts: 90 are flagged. Of 9,900 good parts, 990 are flagged.
Only `90 / (90 + 990)`, about 8.33 percent of flagged parts, are faulty. At
20 percent, the corresponding fraction is `1800 / (1800 + 800)`, about
69.23 percent. The detector did not change; the population did. In a simulation,
generate each part's status first and then its flag conditional on that
status. Reusing a single unconditional flag probability would erase the
relationship we want to investigate. Small simulations fluctuate more; an
empty flagged group has an undefined fraction.

## Chapter 4 What does a spam filter know

**Predict.** A message contains only words absent from the training vocabulary.
What should the chapter's classifier return?

**Change the experiment.** Construct a tiny training corpus with unequal
numbers of ham and spam messages. Compare an empty message, an unknown word,
and a known word repeated several times. Keep the class counts fixed.

**Build.** Make a table of the model's mistakes on held-out messages. Describe
which mistake matters more for a personal inbox and for a shop receiving
orders. Continue to Chapter 14 to turn those costs into a decision rule.

### Hint and worked reasoning

The corrected classifier ignores out-of-vocabulary words. With no known
tokens, the posterior equals its class prior, based on message counts. Equal
probabilities are appropriate only when the priors are equal. Repeated known
tokens contribute repeatedly to the log likelihood in this multinomial model;
they need not leave the posterior unchanged. Laplace smoothing gives a known
vocabulary word nonzero probability in a class where it was not observed. It
does not add every imaginable unseen word to the vocabulary. For the final
project, preserve the train/test separation and inspect false positives and
false negatives separately; accuracy alone hides the decision's consequences.

## Chapter 5 A coin and a prior

**Predict.** Starting with a uniform Beta(1, 1) prior, you see eight heads and
two tails. Is the posterior mean exactly the observed proportion, 0.8?

**Change the experiment.** Replace the prior with Beta(20, 20). Then imagine
80 heads and 20 tails. Compare how much the prior changes each answer.

**Build.** Use the analytic Beta posterior as a reference for the probabilistic
program's samples. Compare the posterior mean and an interval, then increase
the number of draws. Explain why matching a mean alone is insufficient.

### Hint and worked reasoning

The posterior is Beta(a + heads, b + tails). The first mean is `9/12 = 0.75`;
with Beta(20, 20), it is `28/50 = 0.56`. With 80 heads and 20 tails the two
means are `81/102` and `100/140`. The same prior has less influence as data
accumulate, though it has not disappeared. A sampler can have a plausible
mean and still miss a tail or mix poorly. Compare several summaries and
inspect the chain. This experiment assumes a fixed success probability and
conditionally independent flips; a coin whose behavior changes halfway
through asks for another model.

## Chapter 7 Football beyond a single prediction

**Predict.** If we use only the posterior means of attack and defense to
simulate matches, have we included uncertainty about the teams' strengths?

**Change the experiment.** Compare simulated seasons using fixed posterior
mean parameters with seasons using joint posterior draws. Keep each draw's
team parameters together so their posterior relationships are preserved.

**Build.** Choose an observable feature such as the fraction of scoreless
matches or the number of unusually high scores. Compare the observed feature
with replicated seasons. Then read Chapter 17 and explain what a simpler
model makes easier to diagnose.

### Hint and worked reasoning

Even fixed parameters generate random scores, so the first experiment is not
deterministic. What it omits is uncertainty about the parameters. Draw a joint
parameter sample, simulate a season conditional on it, and repeat to include
both sources of uncertainty. Compare the distributions you actually obtain:
which features change, and which barely move? Pick a feature relevant to our
question and look for systematic disagreement. A single season can land
away from the center of its predictive distribution without contradicting
the model.

## Chapter 8 Where should we shoot

**Predict.** One region has 30 made baskets and another has 20. Does that mean
the first region gives a higher probability of scoring?

**Change the experiment.** Give the first region 100 attempts and the second
25. Compare made-shot counts with success rates. Next imagine the second
region has only one attempt and one success.

**Build.** Check a distance-based probability model by grouping held-out shots
into distance ranges. Report attempts, successes, and average predicted
probability for each group. Identify where the comparison is uncertain.

### Hint and worked reasoning

The first two rates are 0.30 and 0.80: attempts change the answer. One success
from one attempt gives an empirical rate of 1, but little evidence that future
shots are certain to succeed. A map of made shots mixes shot selection with
scoring ability. Grouped model checks need denominators and cannot settle
individual player effects when players or defensive conditions differ between
groups. Define the holdout before choosing model changes; reserve a further
assessment if you use these results to improve the model.

## Chapter 9 A price with consequences

**Predict.** If a price maximizes expected revenue, must it maximize expected
profit? What if producing each unit costs money?

**Change the experiment.** For one demand curve `Q(p)`, compare `p*Q(p)` with
`(p-c)*Q(p)` at several prices and unit costs `c`. Use a finite positive price
grid and inspect its endpoints rather than assuming an interior optimum.

**Build.** For every posterior draw of the demand curve, calculate profit at
each candidate price. Compare the price with highest mean profit and a policy
that also considers the probability of a loss.

### Hint and worked reasoning

Revenue ignores production costs. Subtracting the same cost per unit does
not subtract the same total cost at every price, because quantity changes.
Average profits across posterior draws *at each fixed price* before choosing
the expected-profit optimum. Averaging each draw's preferred price generally
does not give the same answer. For a loss-sensitive policy, state the loss
threshold and tradeoff; there is no universal risk preference. Finally,
Chapter 16 asks whether the estimated demand relationship describes what
happens when we actually change the price.

## Chapter 10 What is the image classifier looking at

**Predict.** Could a bee-versus-wasp classifier appear accurate by recognizing
photograph backgrounds rather than insects?

**Change the experiment.** Inspect a small labeled sample. Compare full images
with consistently prepared insect crops and background-only views. Write down
what each comparison can and cannot tell you before training another model.

**Build.** Design an evaluation that keeps related photographs together:
duplicates, photos of the same specimen, or images from the same source must
not cross the relevant train/test boundary. Compare against a majority-class
baseline and report mistakes by class.

### Hint and worked reasoning

Backgrounds can correlate with labels. A random file split may preserve those
correlations or even separate near-duplicates, inflating apparent performance.
A background-only model that predicts labels is evidence of a shortcut in the
dataset. Poor performance after cropping alone is not proof of a shortcut:
cropping also changes resolution and image composition. Start by looking at
the images and tracing how they entered each split. Are we testing on genuinely
new photographs, or another copy of a familiar scene? Keep the final test
aside while investigating that question; inspecting a few images may teach
us more than launching another expensive training run.

## Chapter 11 An ecosystem with new players

**Predict.** In the chapter's basic predator–prey equations, what happens to
the prey derivative if the prey population is exactly zero? What about
predators when no prey remain?

**Change the experiment.** Start with small positive populations and increase
the player-induced mortality. Compare trajectories, then shorten the solver's
step or tighten its tolerances to distinguish numerical behavior from the
equations' behavior.

**Build.** Propose one missing mechanism—migration, a protected reserve, or
limited resources—and write the term you would add. Explain its units, sign,
and behavior at zero population before fitting anything.

### Hint and worked reasoning

In the basic model, population changes are proportional to the population:
zero prey stays zero, and predators without prey decay under positive
mortality. Numerical approximations can produce undesirable values, which is
why solver checks matter. An immigration term can permit recovery from zero;
a birth term proportional to the absent population cannot. A carrying-capacity
term changes growth at large populations. The best extension is the one whose
mechanism and observable consequences you can explain, not the one with the
largest number of parameters.

## Chapter 12 Can we recover the missing rule

**Predict.** If two learned differential equations reproduce one observed
trajectory, must they agree for a different initial population?

**Change the experiment.** Compare their predictions from several initial
conditions outside the fitting trajectory. Then add observation noise and
check whether your conclusion changes.

**Build.** For a candidate recovered equation, make a short scientific report:
training conditions, held-out initial conditions, units of each term,
prediction errors, and behavior near the edge of the observed region.

### Hint and worked reasoning

One trajectory explores only part of the state space. Different vector fields
can agree there and disagree elsewhere. A low fitting error alone therefore
does not identify the governing law. Sparse expressions can improve
interpretability, but the chosen basis and threshold influence what can be
recovered. Use the chapter's known synthetic mechanism to check equation
recovery, then separate that advantage from what would be knowable with real
data. Do not tune repeatedly on the same held-out initial conditions and
continue to call them an independent final test.

## Chapter 13 A forecast that reacts too slowly

**Predict.** A series stays at 10 and then jumps to 20. Which simple
exponential smoother reacts faster: alpha 0.2 or alpha 0.8?

**Change the experiment.** With the previous level initialized to 10, compute
the first two level updates after observing 20 twice. Then add random noise
around an unchanged level and compare how jumpy the two smoothers become.

**Build.** Evaluate one-step forecasts with a rolling origin: predict the
next observation using only the past, record its error, and then update.
Compare with predicting the most recent observation. Keep a final time window
separate from the one used to choose alpha.

### Hint and worked reasoning

Using `level = alpha*observation + (1-alpha)*previous_level`, alpha 0.2 gives
12 then 13.6; alpha 0.8 gives 18 then 19.6. Faster adaptation also responds
more strongly to noise. The level after seeing an observation is available
for the *next* forecast; using it to predict the observation just consumed
leaks information. Randomly shuffling time points destroys the forecasting
question. A complete answer also asks whether the simple level-only model
can represent the trend or seasonality present in the series.
