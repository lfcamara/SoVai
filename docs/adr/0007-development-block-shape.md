# Development block: ticket-scoped execution, red-green TDD, five-axis review

**Superseded in part by [ADR-0015](0015-review-has-a-goal-axis.md), 2026-07-30: review now dispatches six axes.** The title and the "Review has five axes and one dispatcher" section record the decision as it was taken; `goal-review` was added later, on the same reasoning this ADR used for `spec-review`. Everything else stands — and the mandatory-TDD rule below became enforced rather than advisory in [ADR-0012](0012-the-plugin-ships-an-enforcement-layer.md).

The development block delegates execution per ticket, runs a two-step TDD loop, and splits review into five independent axes.

## The ticket is the unit of delegation

`to-tickets` already sizes a ticket to a single fresh context window, which is exactly a subagent's budget. So one ticket goes to one `implementer`. A phase is the orchestrator's sequencing unit and is never handed to an agent whole — doing so would exhaust the context it was sized against.

Parallelism runs across the frontier: only tickets whose blockers have closed can run at once. Where concurrent work could touch the same files, agents run in isolated git worktrees, which makes parallelism safe by construction rather than by luck.

## TDD is red → green only

Refactoring is relocated to the review stage, not deleted. The loop produces a passing test and the code that satisfies it; structural cleanup happens in `code-review`, where the tests are already green and the code is free to move. This matches the upstream `tdd` skill from mattpocock/skills, which was imported unchanged.

**Amended 2026-09-03: the relocated refactor is owed, not optional.** Relocation left it in a bucket that could be waived. `code-review` caps a baseline smell at medium, and medium findings are fixed only when the user asks — so the cleanup this section postponed arrived at the merge as discretionary polish, and "relocated, not deleted" was true of the skills and false of the process. Findings that are the postponed cleanup now carry an **owed** marker beside their severity, are fixed before the work merges whatever that severity says, and `wrap-up` will not merge past one. Severity still ranks urgency; it stopped deciding whether the debt gets paid. The cost is that a ticket cannot be merged with a smell nobody wants to fix today — which is the cost of having moved the step rather than dropped it.

TDD is mandatory for backend and other non-UI logic. UI is the deliberate exception, tested after implementation: a UI's shape moves while it is being built, and tests written against a moving shape break on every layout change without catching real defects. `ui-testing` covers that case, deriving its test list from the wireframes rather than chasing maximum coverage — a brittle UI suite gets disabled, and a disabled suite protects nothing.

## Verification stays inside the subagent

Lint, build, test and coverage produce enormous output. That output is already contained: it lands in the subagent's context and dies with it, so the subagent boundary is the isolation, and no separate agent is needed. The `implementer` verifies its own slice and reports the verdict with failing lines only. Integration checks spanning several agents' work go to `reviewer`, which holds Bash and is read-only.

## Review has five axes and one dispatcher

`code-review`, `spec-review`, `test-review`, `security-review`, `migration-review`, dispatched in parallel by `review`. Each axis is a skill of its own because each carries distinct patterns as reference and each is worth running alone — a security pass before a release, say. Running them as separate `reviewer` subagents keeps their contexts from polluting each other, and findings are reported per axis without reranking, so a clean axis cannot mask a failing one.

`spec-review` exists because the other four all judge how the work was done. Code that satisfies every standard while implementing the wrong thing passes all of them.

## The orchestrator owns ticket state and the merge

States are To Do, Doing, Testing, Done. Every transition is the orchestrator's, for two reasons. A subagent that dies mid-task would otherwise leave its ticket stranded in Doing with nothing alive to reconcile it, whereas the orchestrator outlives every agent it dispatches. And an implementer that marks its own work Done is grading its own homework — the Testing state exists precisely so that something else validates first, the same reasoning that makes `reviewer` read-only.

The draft PR opens after the implementer's first push rather than at ticket start. A pull request needs a commit, so opening it earlier means either an empty shell or a junk empty commit; opening it on the red-test push gives a PR that already states what the ticket must make true.

The implementer opens it, not the orchestrator. The orchestrator's only channel out of a subagent is its final report, which arrives once the run is over — by then the work is green and a draft PR says nothing the finished diff does not. The reasoning that gives the orchestrator ticket state does not extend here: a stranded ticket needs something alive to reconcile it, whereas a stray draft PR is visible and harmless. The merge itself stays the orchestrator's, gated on the user's approval.

**Amended 2026-09-03: the ticket's link back to the PR moves to the orchestrator.** Opening stays where this section put it, for the timing reason above. Linking cannot: reaching a tracker takes tools the `implementer` does not hold. Linear and Jira are MCP connectors, and the implementer carries file tools, `Bash` and `WebFetch` — enough for `gh` and a markdown ticket, nothing for the other two. The step was therefore unexecutable on half the supported trackers, and silently so, since nothing surfaces a missing capability until a run hits it. The orchestrator does it when the report arrives, from the PR URL that report now carries; the cost is that the ticket points at its PR one run after the PR points at its ticket.

One consequence of opening on the red-test push is worth naming, because it was not weighed when this was decided: CI runs on that push, against a commit that is red by construction. In a repo where CI is expensive or notifies a team, that is recurring noise, and it is the argument that would move opening to the orchestrator as well — at the price of the visibility this section exists to buy.
