---
name: wrap-up
description: Merge an approved PR, close out its ticket, and reconcile planning documents against what actually shipped. Use when the user approves a PR for merge ("approved", "merge it", "pode mergear", "ship it"), or asks to close out a ticket.
---

# Wrap Up

Runs in the orchestrator session, never a subagent. ADR-0007 gives the orchestrator every ticket-state transition, for the same reason it applies here: the orchestrator is the one thing still alive to reconcile the tracker if anything downstream goes wrong, where a subagent would simply vanish.

## Authorize the merge

A merge is authorized by the user's explicit approval of *this* pull request — "approved", "merge it", "pode mergear", "ship it" said about the PR in front of you. Reviews passing, CI going green, or the work simply looking finished are signals the user weighs when they approve; they are not the approval itself, and none of them substitutes for it. Approving one PR authorizes that PR — the next one, however similar, asks again.

## Check the preconditions

Before merging, confirm and report: the PR is not a draft, its reviews have passed, CI is green, the branch has no conflicts with its base — the phase branch it was cut from, not `main` — and the review record at `docs/reviews/<YYYY-MM-DD> — <ticket or branch>.md` carries no unresolved finding at **critical** or **high** severity and none marked **owed**. The user approved a merge of work they believed was ready — where any precondition fails, their approval was given on a false premise. A critical or high finding is never one the user's approval can wave through; it gets fixed, full stop, regardless of how firmly the PR was approved. An owed finding is the same: it is the refactor `tdd` postponed to `code-review`, and merging past it is what turns a relocated step into a dropped one. Report the failing one and stop; do not merge around it.

## Merge, then verify it landed

Merge with `gh`. Then confirm the merge actually landed before touching the tracker or anything else downstream. The ordering matters: a ticket moved to Done ahead of a merge that then fails is a tracker that lies, and nothing later in this skill is positioned to catch that.

## Update the tracker

Move the ticket to Done. The tracker is resolved from the project's `sovai.config.json`, and the mechanics of every tracker live in `to-tickets` — follow that, not a restatement of it here. A project publishing to local markdown has no Done to move to; say that plainly rather than reporting a state change that did not happen.

## Retire the ticket's worktree

The ticket's work is in the phase branch now, so its worktree under `<project root>/worktrees/` and its branch both go. Remove the worktree, then delete the branch.

Never force either. A worktree holding uncommitted changes, or a branch holding commits the merge did not carry, is work the merge left behind — report it and leave it on disk. Nothing is lost by a worktree that outlives its ticket; a forced removal loses the only copy of whatever was in it.

## Write the troubleshooting note

Check whether the ticket just moved to Done is a bug fix — it carries `diagnose`'s fields: a confirmed root cause, a reproduction command, a minimised repro. `diagnose` deliberately stops at the ticket, before anyone knows how the bug was actually fixed; the resolution only exists now that the fix has landed, which is why this note is written here and not there.

Write `docs/troubleshooting/<YYYY-MM-DD> — <short bug title>.md`, wikilinked to the ticket and to whichever effort documents the fix touches. Carry:

- **The symptom**, in the words it was actually observed — the error message, the wrong output, what the user or the report saw. A future reader arrives searching on what they're seeing, not on what caused it, so lead with their words, not the diagnosis's.
- **The root cause**, from the ticket.
- **The fix** — what changed and why it addresses the root cause rather than the symptom.
- **The reproduction command that went red**, and what it does now.
- **What would have prevented it** — carried over from the ticket's own answer to that question, sharpened if the fix revealed more than the diagnosis knew.

The note's entire value is being found again by someone hitting the same symptom later. Write it for that reader, not for the record.

## Reconcile the documents

An implementation routinely learns something the plan didn't know, and the documents under `docs/planning/<effort>/` go stale silently unless something closes the loop. This is that something.

The governing rule: **a document follows a decision, not a diff.** Where the code diverges from the spec because someone deliberately decided differently while building, the document is out of date and gets updated to match. Where the code diverges because the code is wrong, that's a defect, not a stale document — it belongs to `spec-review`, and rewriting the spec to match would launder the bug into a requirement. Telling the two apart is the judgement call this step exists for; never reconcile by reflex.

Check each of the following and state what you found, updating only where a decision moved:

- `<effort> — Phase <N> Spec.md`, for the phase the ticket belonged to — implementation decisions that turned out differently than planned.
- `<effort> — PRD.md` — scope that genuinely changed. This should be rare; question it when it happens.
- `<effort> — Wireframes.md` — screens or states that changed shape.
- `<effort> — Roadmap.md` — phase exit criteria now met.
- `CONTEXT.md` and ADRs — a new domain term, or a decision made during implementation that meets the bar for an ADR. Run `domain-modeling` for these; it owns both files and the test for when an ADR is warranted.

## Close the phase when it closes

When the ticket just moved to Done was the last open one in its phase, the phase is complete — but only if its exit criteria in `<effort> — Roadmap.md` actually hold. Verify each one and report which you checked; a phase whose tickets all closed but whose exit criteria don't hold is not done, and catching that now is far cheaper than catching it a phase later.

Once the exit criteria hold, the phase branch `phase/<effort>-<NN>` is what `main` receives: open its PR, and merge it under the same rule as any other — the user's explicit approval of *that* pull request. Approving the tickets said nothing about shipping the phase, and this is the merge where a user first meets the capability whole (ADR-0020).

While the phase is still open, keep its branch current with `main` whenever `main` moves. A phase branch that integrates once, at the end, turns every conflict its tickets avoided into a single merge nobody planned for.

With the phase merged, the next phase needs its own `to-tickets` run, against the codebase as it now stands — that run is the next step, not part of this one.
