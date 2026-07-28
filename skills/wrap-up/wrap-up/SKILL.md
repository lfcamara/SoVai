---
name: wrap-up
description: Merge an approved PR, close out its ticket, and reconcile planning documents against what actually shipped. Use when the user approves a PR for merge ("approved", "merge it", "pode mergear", "ship it"), or asks to close out a ticket.
---

# Wrap Up

Runs in the orchestrator session, never a subagent. ADR-0007 gives the orchestrator every ticket-state transition, for the same reason it applies here: the orchestrator is the one thing still alive to reconcile the tracker if anything downstream goes wrong, where a subagent would simply vanish.

## Authorize the merge

A merge is authorized by the user's explicit approval of *this* pull request — "approved", "merge it", "pode mergear", "ship it" said about the PR in front of you. Reviews passing, CI going green, or the work simply looking finished are signals the user weighs when they approve; they are not the approval itself, and none of them substitutes for it. Approving one PR authorizes that PR — the next one, however similar, asks again.

## Check the preconditions

Before merging, confirm and report: the PR is not a draft, its reviews have passed, CI is green, and the branch has no conflicts with its base. The user approved a merge of work they believed was ready — where any precondition fails, their approval was given on a false premise. Report the failing one and stop; do not merge around it.

## Merge, then verify it landed

Merge with `gh`. Then confirm the merge actually landed before touching the tracker or anything else downstream. The ordering matters: a ticket moved to Done ahead of a merge that then fails is a tracker that lies, and nothing later in this skill is positioned to catch that.

## Update the tracker

Move the ticket to Done. Tracker mechanics and the Linear team/project convention live in `to-tickets` — follow that, not a restatement of it here.

## Reconcile the documents

An implementation routinely learns something the plan didn't know, and the documents under `docs/planning/<effort>/` go stale silently unless something closes the loop. This is that something.

The governing rule: **a document follows a decision, not a diff.** Where the code diverges from the spec because someone deliberately decided differently while building, the document is out of date and gets updated to match. Where the code diverges because the code is wrong, that's a defect, not a stale document — it belongs to `spec-review`, and rewriting the spec to match would launder the bug into a requirement. Telling the two apart is the judgement call this step exists for; never reconcile by reflex.

Check each of the following and state what you found, updating only where a decision moved:

- `spec.md` — implementation decisions that turned out differently than planned.
- `prd.md` — scope that genuinely changed. This should be rare; question it when it happens.
- `wireframes.md` — screens or states that changed shape.
- `roadmap.md` — phase exit criteria now met.
- `CONTEXT.md` and ADRs — a new domain term, or a decision made during implementation that meets the bar for an ADR. Run `domain-modeling` for these; it owns both files and the test for when an ADR is warranted.

## Close the phase when it closes

When the ticket just moved to Done was the last open one in its phase, the phase is complete — but only if its exit criteria in `roadmap.md` actually hold. Verify each one and report which you checked; a phase whose tickets all closed but whose exit criteria don't hold is not done, and catching that now is far cheaper than catching it a phase later.

Once the phase genuinely closes, the next phase needs its own `to-tickets` run, against the codebase as it now stands — that run is the next step, not part of this one.
