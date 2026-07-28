---
name: implement
description: Carry one ticket from a fresh context window to a pushed, verified branch, running the red-green TDD loop and reporting the outcome. Use when picking up a ticket to implement, when the user says "implement ticket <id>" or "work this ticket", or when the delegate skill dispatches a ticket to an implementer.
---

# Implement

## Scope

Exactly one **ticket**. A ticket is sized to one context window by construction — that sizing is what makes it the delegation unit, and this skill's scope stops at its boundary. **Phase** is the orchestrator's sequencing unit: don't reach past the ticket to pull in what else the phase contains.

## Gather context

Read the ticket in full, then the spec and roadmap under `docs/planning/<effort>/` for the decisions that shaped it, `CONTEXT.md` for the domain vocabulary tests and code should use, and the ADRs covering the area you're touching. A ticket that references something not on disk where it says it should be is a fact to report, not a gap to fill by guessing.

## Build: red, then green

Follow the `tdd` skill for the loop itself — seams, what a good test is, the rules of red before green. It's the single source of truth for that loop; this skill doesn't restate it.

Backend and any other non-UI logic is TDD-mandatory: the red test always comes first. UI is the exception — build it, then write its tests guided by the `ui-testing` skill, because a screen's shape is still moving during implementation and a test written against it first goes brittle the moment it settles.

Refactoring is not part of this loop. Land the loop at green and stop; cleanup is review's job, done against a diff a reviewer is already looking at.

## Commit discipline

The red test is the first commit, and pushing it is the first push. That first push is what the orchestrator needs to open a draft PR that already states, via the failing test, what this ticket has to make true — so it can't wait until the ticket is green.

## Verify before reporting

Before calling the ticket done, run the project's lint, build, test, and coverage commands. Their full output stays inside this run and is gone once it ends — carry forward only the verdict and the failing lines, never the raw output.

## Report

Return, in this order:

1. **Outcome** — done, blocked, or done with caveats.
2. **What changed and where** — files and behavior, not a diff narration.
3. **How it was verified** — which commands, and the result.
4. **What the ticket didn't anticipate** — anything you had to resolve that wasn't written down.
5. **What you noticed but left alone** — deliberately, because it was outside this ticket.

Ticket state and opening the PR belong to the orchestrator, not this skill — implementing a ticket doesn't include moving it on the tracker or running `open-pr`.
