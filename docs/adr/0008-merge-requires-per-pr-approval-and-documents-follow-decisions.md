# Merge requires per-PR approval, and documents follow decisions

The wrap-up block lands approved work and reconciles what the implementation taught the plan.

## Merge is gated on explicit, non-transferable approval

Merging is the one irreversible, outward-facing act in the pipeline, so it happens only when the user approves that specific pull request. Reviews passing, CI going green, and the work looking finished are preconditions, never authorization — an agent that merges because the signals look good has substituted its own judgement for a decision that was never delegated to it.

Approval does not generalize. Approving one PR says nothing about the next, so each merge asks again. The cost is one question per merge; the alternative is an agent that eventually merges something the user would not have.

## Ordering is load-bearing

Merge, confirm the merge landed, then update the tracker, then reconcile documents. A ticket moved to Done before a merge that subsequently fails leaves a tracker asserting something false, with nothing downstream able to detect it. Every step after the merge is conditional on the merge being confirmed.

## Documents follow decisions, not diffs

An implementation routinely learns something the plan did not know, and `docs/planning/<effort>/` goes stale silently. Reconciling it is part of landing the work rather than a separate hygiene task nobody schedules.

The judgement this step exists for is the distinction between two divergences that look identical in a diff. Where the code differs from the spec because someone deliberately decided otherwise while building, the document is out of date and gets updated. Where the code differs because the code is wrong, that is a defect belonging to `spec-review` — and rewriting the spec to match would launder a bug into a requirement, which is worse than leaving the spec stale, because it destroys the record that would have caught it.

So reconciliation is never reflexive. Each document is checked, and the finding is reported whether or not anything changed.

## Phase completion is verified, not inferred

When the last open ticket in a phase merges, the phase's exit criteria from `roadmap.md` are checked rather than assumed. A phase whose tickets all closed but whose exit criteria do not hold is not complete, and discovering that at the boundary costs far less than discovering it a phase later.

Completion hands back to planning: the next phase gets its own `to-tickets` run against the codebase as it then stands, which is the per-phase loop from ADR-0003 and ADR-0005 closing.

## Session handoff is deliberately out of scope

The upstream `handoff` skill compacts a conversation so a fresh agent can continue. That is finishing a *session*, not finishing *work*, and folding it into this block would blur what the block is for. It can be imported on its own if the need arises.
