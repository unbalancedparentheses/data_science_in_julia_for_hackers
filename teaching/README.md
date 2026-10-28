# Learning through a prediction, an experiment, and an explanation

The new chapters revisit problems the reader already cares about. A spam filter can win an accuracy contest while making the wrong decisions. A delivery table can leak the answer before fitting begins. A price–sales association can point in the opposite direction from an intervention. A football sampler can compute the intended posterior accurately while its model misses scoreless matches.

The teaching pattern is to make a prediction before running code, inspect the mechanism, change one assumption, and explain the result. The [whole-book challenge guide](../documentation/Challenges.md) extends this approach to the other earlier chapters. The Mars mission has its own [exercises in the Chapter 6 source](../06_gravity.Rmd). Each chapter includes short excerpts from the source that actually runs, followed by three exercise levels with hints and worked solutions. The explanations discuss a tempting wrong approach as well as the answer. The exercises are invitations to investigate, not a graded certification of competence.

## Where each chapter fits

| Existing problem | New investigation | Evidence that a reader can transfer the idea |
|---|---|---|
| Chapter 4's spam filter | Chapter 14: metrics, costs, calibration, and changing prevalence | Explain why a more accurate filter can be more costly, then derive a decision with a review option |
| Chapter 2's tables and Chapter 14's held-out evaluation | Chapter 15: fitting preparation and comparing models | Trace which rows learn an imputer; diagnose errors for missing and observed inputs separately |
| Chapter 9's price–quantity relationship | Chapter 16: assignment, confounding, and interventions | Explain a sign reversal, identify missing comparisons, and reweight effects for a new neighborhood |
| Chapter 7's football model | Chapter 17: computation, predictive checks, and revision | Separate a wrong sampler target from a wrong model assumption, using an exact reference and simulated seasons |

For a reader new to coding, begin with the intuition exercise and trace one row through the visible source excerpt. A reader comfortable with Julia can start by predicting the effect of a control, then implement the build-it-yourself exercise without reading the solution. Neither route requires pretending that a function name explains its internals.

The ordinary `julia` fences marked `source-excerpt` show pieces of functions, not additional cells to paste into a session indiscriminately. Their surrounding prose names the function and explains the required state. The complete executable chapter chunks and notebooks use the shared implementation. Worked solution functions are complete examples, and the checks below execute those functions directly from the prose.

## A session built around one question

A useful first session can follow one chapter for about an hour. Spend a few minutes establishing its practical decision and asking for a written prediction. Let the learner run the initial example, then ask them to point to the line that connects their assumption to the observed result. For the next experiment, change one setting only. Compare the prediction with the new table or trace before moving on.

Use the three exercises as a progression rather than racing through them. The intuition question reveals whether the learner understands the comparison. The changed experiment asks which assumptions stay fixed. Building a small function requires them to express the idea in code. If they get stuck, offer the printed hint first; revealing a full solution too early hides where the explanation failed.

After working through a solution, change a number or the setting and ask for the reasoning again. For example, replace spam with a rare equipment fault, replace price with a promotional offer, or replace goals with calls to a help desk. The goal is to find out whether the idea transfers without changing the statistical problem unnoticed.

## Proposed learner pilot — not yet conducted

No human learner pilot has been performed for these additions. Automated execution and external model reviews can find technical or editorial problems, but they do not show what a new reader understands. The following is a protocol for collecting that evidence when volunteer readers are available.

Invite three to five readers who know basic programming but have not worked through these chapters. Begin from a clean checkout and the published setup instructions, recording time to first successful run, installation errors, and assistance needed. This is an initial usability round, not a representative sample or an experiment establishing learning effectiveness. Ask participants to choose a chapter whose prerequisite ideas they can explain; record unfamiliar prerequisites instead of treating them as failures of effort.

Before the session, ask a short transfer question using a different setting. For Chapter 14, a rare equipment alarm works well: what information is missing from an accuracy claim? For Chapter 15, ask whether a transform learned from next month's records belongs in a forecast made today. For Chapter 16, ask whether a successful salesperson's discount policy reveals the effect of assigning discounts. For Chapter 17, ask whether four agreeing chains establish that the model predicts extreme observations well.

During the session, ask the reader to think aloud while predicting one change, running it, and explaining the result. Include the error-cost comparison in the spam chapter or the uncertainty in the Mars launch decision: can the reader explain why a best estimate alone does not settle the decision? Record elapsed time and errors as well as whether they can explain the result. Record the exact sentence or code line where they hesitate, the assistance needed, and the explanation they give. Keep environment-installation delays separate from conceptual difficulties. Do not count a correct answer obtained after seeing the worked solution as independent evidence of understanding.

End with a parallel transfer question and a short request: explain one plausible wrong approach and why it fails. A few days later, if the participant agrees, repeat one small transfer problem without the chapter open. Record consent before recording a session, avoid collecting unnecessary personal information, and preserve anonymous notes rather than real inboxes or business records.

A compact observation record is enough:

| Task | Prediction before running | Explanation after running | Help used | Point of confusion | Revision to try |
|---|---|---|---|---|---|
| Example: changing spam prevalence | Reader's own words | Reader's own words | None, hint, or worked solution | Exact paragraph or line | One concrete edit |

Use this round to prioritize revisions. If multiple readers mistake a predictive comparison for an intervention, revise the causal transition before adding another algorithm. If they call a helper without understanding its selection of rows, improve the visible excerpt and its explanation. Report observations and changes candidly; a small usability pilot does not justify a claim that the book has been proven effective.

## Checks for maintainers

From the repository root:

```sh
python3 teaching/check_source_excerpts.py
julia --project=17_bayesian_workflow -e 'using Pkg; Pkg.instantiate()'
julia --project=17_bayesian_workflow teaching/check_exercises.jl
```

The first check compares every marked teaching excerpt with consecutive lines of its current source file, ignoring common indentation only. The second executes the printed solution functions and verifies hand calculations, data-boundary examples, and predictive discrepancies. These checks complement the chapter and Pluto runtime tests; they are not substitutes for reading, rendering, or the proposed learner pilot.
