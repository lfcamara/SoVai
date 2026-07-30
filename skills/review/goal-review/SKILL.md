---
name: goal-review
description: Review whether a ticket's real-world goal now holds — merged, switched on, and delivered in full rather than merely built well. Use to check shipped work against the outcome its ticket existed for, or when the review skill dispatches its goal axis.
---

# Goal Review

Reviews WHETHER THE OUTCOME HOLDS, not whether the work was built well. Every other axis judges the diff, and a diff cannot show that it was never merged, that the flag gating it is still switched off, or that a third of the **ticket** was quietly deferred. Well written, on spec, well tested, and inert is the false-done that nothing else on this run can see; this axis reads the state of the world the ticket wanted changed.

## Locate the goal and the change

Two inputs, both required, and neither of them in the diff:

1. The **ticket** stating the outcome — a reference in the commit messages or the branch name. Reach it through `to-tickets`, which owns tracker mechanics.
2. The pull request whose state can be read — `gh pr view <ref> --json state,isDraft,mergedAt,baseRefName,body`.

Where either is missing, say so and stop. Merge and enforcement state cannot be read off a working tree, and a verdict reached without both is a guess in a finding's clothes. These are the same two references the dispatcher checks when it decides whether to select this axis.

## Report four states, then judge them

The states below are **facts**, reported whatever they say. A fact becomes a finding only where it contradicts a claim that the work is done — the ticket reads Done, the PR body or the implementer's report says shipped, or the user is being asked to approve this merge. A draft PR on a ticket still in Doing is consistent, and consistent is not a finding.

- **Merged** — is the change in the branch the goal needs it to reach, or open, draft, or merged somewhere else? Read the PR's base ref against where the ticket's outcome has to hold.
- **Enforced** — where a flag, toggle, config value, environment variable, or staged rollout gates the change, what is that gate set to in the environment where the goal must hold? Code that correctly implements a flag and a flag set to the value that fixes the problem are indistinguishable inside the diff and opposite outside it.
- **Scope covered** — does the shipped work cover the ticket's full stated scope, checked against the ticket's own acceptance criteria? Work the PR or the ticket explicitly names as deferred — a follow-up ticket, a stated later phase — is a fact and often a sound call; the finding is deferred work presented as delivered.
- **Tracker consistent** — does the ticket's own state agree with the three states above? This axis observes merge and tracker state and moves neither; both belong to `wrap-up`.

## Severity

Assign each finding a severity per `review`'s ladder. On this axis, high is a change presented as done whose goal is not in effect for users — merged behind an unset flag or a warn-only mode, or covering part of the ticket while the ticket reads Done; critical is that same gap where what stays live is the data loss or open security hole the ticket existed to close.

A `Cause:` on this axis names what let a change be called done while its goal was not — "nothing checks a flag's value after merge", never "the implementer forgot".
