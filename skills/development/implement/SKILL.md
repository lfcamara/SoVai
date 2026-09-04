---
name: implement
description: Carry one ticket from a fresh context window to a pushed, verified branch, running the red-green TDD loop and reporting the outcome. Use when picking up a ticket to implement, when the user says "implement ticket <id>" or "work this ticket", or when the delegate skill dispatches a ticket to an implementer.
---

# Implement

## Scope

Exactly one **ticket**. A ticket is sized to one context window by construction — that sizing is what makes it the delegation unit, and this skill's scope stops at its boundary. **Phase** is the orchestrator's sequencing unit: don't reach past the ticket to pull in what else the phase contains.

## Gather context

Read the ticket in full, then what that ticket points at. A ticket from the planning pipeline names an effort and a phase, so read `<effort> — Phase <N> Spec.md` for the decisions that shaped it. A bug ticket from `diagnose` belongs to no effort and carries its own context instead — the evidence, the reproduction command, the minimised repro, the confirmed root cause and the seam analysis — so read those and do not go looking for a phase spec that was never written. Either way read `CONTEXT.md` for the domain vocabulary tests and code should use, and the ADRs covering the area you're touching. The brief's inputs are the authoritative paths; resolve whatever it left out from `docs/planning/<effort>/`. A ticket that references something not on disk where it says it should be is a fact to report, not a gap to fill by guessing.

## Test list, only when asked

Start the loop by default. Where the brief says the user asked to see what will be tested first, this is the first thing you do: produce the **test list** — one line per behaviour you intend to verify, at the seams the spec agreed, in the language of what the user can do rather than what the code calls. Then stop and report it; you have no way to ask, so the list going back is the whole step.

List the behaviours, not the tests. Writing every test before any implementation is the horizontal slicing `tdd` warns against, and a list of behaviours is far quicker to judge than a wall of test bodies. Say plainly that the list is what you can see from here — cases the loop surfaces later get reported when they appear, rather than being capped by the list.

## Build: red, then green

Follow the `tdd` skill for the loop itself — seams, what a good test is, the rules of red before green. It's the single source of truth for that loop; this skill doesn't restate it.

The seams `tdd` requires you to have agreed are the ones `to-spec` settled with the user; treat those as pre-agreed and work at them. A red test that needs a seam the spec never named is an unsettled decision, not a fact to look up — stop and report it rather than agreeing a seam with yourself.

Backend and any other non-UI logic is TDD-mandatory: the red test always comes first. UI is the exception — build it, then write its tests guided by the `ui-testing` skill, because a screen's shape is still moving during implementation and a test written against it first goes brittle the moment it settles.

Land the loop at green and stop. Cleanup happens in review, against a diff a reviewer is already looking at.

## Commit discipline

Work inside the worktree the brief names, and cut the ticket's branch there from the phase branch the brief names, before anything is committed — `open-pr` holds the name the branch carries. The red test is the first commit on it, and pushing it is the first push. Immediately after that push, run the `open-pr` skill yourself to open the draft PR — you are the only thing that knows the push has happened, and the orchestrator does not hear from you again until this run ends. A draft PR opened here states, through its failing test, what the ticket has to make true; opened at the end it would say nothing that the finished diff doesn't already say. Opening it is yours; pointing the ticket back at it is the orchestrator's, from the URL your report carries.

## Verify before reporting

Before calling the ticket done, rebase on the phase branch so what you verify is what the phase will hold, then run the project's lint, build, test, and coverage commands, as the project declares them — `CONTEXT.md`, the root `CLAUDE.md`, and the package or task manifest are where they are named. Their full output stays inside this run and is gone once it ends — carry forward only the verdict and the failing lines, never the raw output.

## Report

Return, in this order:

1. **Outcome** — done, blocked, or done with caveats.
2. **Where the work is** — the branch name and the draft PR's URL, which are how the orchestrator reaches the diff at all.
3. **What changed and where** — files and behavior, not a diff narration.
4. **How it was verified** — which commands, and the result.
5. **What the ticket didn't anticipate** — anything you had to resolve that wasn't written down.
6. **What you noticed but left alone** — deliberately, because it was outside this ticket.

Ticket state belongs to the orchestrator — implementing a ticket doesn't include moving it on the tracker.

What the orchestrator does with this report is run the `review` skill against the pushed branch. Knowing that is useful here for one reason: the report is the only thing that survives this run, so anything review would need and only you can know belongs in it.
