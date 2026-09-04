---
name: open-pr
description: Open a draft PR for a ticket right after its first push, and link ticket and PR to each other. Use when a ticket's red-test commit has just been pushed, when an implementer's report comes back with a PR the ticket does not point at yet, when the user asks to open a PR for a ticket, or when a phase needs its in-flight tickets visible for review.
---

# Open PR

## When to open

Open once the ticket's first push has landed — the red-test commit from the `implement` skill's commit discipline. A PR needs at least one commit to exist meaningfully; opening before that push produces an empty shell or forces a junk empty commit. Opening right after it gives reviewers a PR whose diff, from the first minute, already says what the ticket must make true.

The implementer opens it, not the orchestrator: it is the only thing that knows the push has happened, and it does not report back until its run ends. Opening a draft PR is not the merge — the merge stays the orchestrator's, gated on the user's approval in `wrap-up`.

The ticket's own link to the PR is the orchestrator's half of this skill, run when the implementer's report arrives. The two halves are split by capability, not by preference: see **Link the ticket back**.

## Branch

The branch carries the ticket's identifier in its name (for example, `<TICKET-ID>-<kebab-slug>`), so the branch is legible on its own without a trip to the tracker. Open the PR from that branch — it already exists from the ticket's first push — and target the phase branch it was cut from, `phase/<effort>-<NN>`, never `main`. The phase reaches `main` as one merge of its own, when it closes (ADR-0020).

## Body

<pr-body-template>

What to build — copied from the ticket's own statement of it.

Acceptance criteria — the ticket's checklist, reproduced as-is so reviewers can check items off against the same list the ticket tracks.

A link back to the ticket.

</pr-body-template>

Leave file paths and code out of the body, the same reason `to-tickets` keeps them out of tickets: either goes stale before review catches up to the PR, and the diff itself is the accurate, current version of both.

## Link the ticket back — the orchestrator's half

A PR that links to its ticket but not the reverse leaves half the trail cold. The orchestrator closes that trail, from the PR URL the implementer's report carries, before dispatching `review`. Tracker mechanics live in `to-tickets` — follow that to reach the ticket, then attach the PR link to it. For a local-markdown ticket, append a line to the ticket file pointing at the PR.

This half sits with the orchestrator because reaching a tracker takes tools the `implementer` does not hold. Linear and Jira are MCP connectors, and the implementer carries file tools, `Bash` and `WebFetch` — enough for `gh` and for a markdown ticket, and nothing at all for the other two. Left in the implementer, the step is silently unexecutable on two of the four trackers, and the failure surfaces only at runtime. The cost of the split is that the ticket points at its PR one run later than the PR points at its ticket, which is the less-travelled direction of the two.

## Draft until reviewed

Open as a draft. The draft state is the signal that the diff isn't asking for a merge decision yet, only visibility into work in progress.

Taking it out of draft is `review`'s, at the end of its round loop — the same split as **Link the ticket back**, and for the same reason. This run ends before any review exists, so an implementer told to mark the PR ready when its reviews pass is holding an instruction whose condition it can never observe. `review` is what knows the loop ended.

## Mechanics

Use the `gh` CLI for every GitHub operation here — creating the PR as a draft, and any comment or label change along the way. `gh pr ready` belongs to `review`, which runs it when the round loop ends.

Where `gh` is not installed or not authenticated, say so plainly and report the branch name and the push, so the developer can open the PR themselves. The branch is on the remote either way; what is missing is the pull request, and a run that says which is far cheaper to recover from than one that reports done. This is the floor `to-tickets` takes for a tracker it cannot reach.
