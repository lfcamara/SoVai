---
name: open-pr
description: Open a draft PR for a ticket right after its first push, and link ticket and PR back to each other. Use when a ticket's red-test commit has just been pushed, when the user asks to open a PR for a ticket, or when a phase needs its in-flight tickets visible for review.
---

# Open PR

## When to open

Open once the ticket's first push has landed — the red-test commit from the `implement` skill's commit discipline. A PR needs at least one commit to exist meaningfully; opening before that push produces an empty shell or forces a junk empty commit. Opening right after it gives reviewers a PR whose diff, from the first minute, already says what the ticket must make true.

The implementer runs this, not the orchestrator: it is the only thing that knows the push has happened, and it does not report back until its run ends. Opening a draft PR is not the merge — the merge stays the orchestrator's, gated on the user's approval in `wrap-up`.

## Branch

The branch carries the ticket's identifier in its name (for example, `<TICKET-ID>-<kebab-slug>`), so the branch is legible on its own without a trip to the tracker. Open the PR against that branch — it already exists from the ticket's first push.

## Body

<pr-body-template>

What to build — copied from the ticket's own statement of it.

Acceptance criteria — the ticket's checklist, reproduced as-is so reviewers can check items off against the same list the ticket tracks.

A link back to the ticket.

</pr-body-template>

Leave file paths and code out of the body, the same reason `to-tickets` keeps them out of tickets: either goes stale before review catches up to the PR, and the diff itself is the accurate, current version of both.

## Link the ticket back

A PR that links to its ticket but not the reverse leaves half the trail cold. Tracker mechanics live in `to-tickets` — follow that to reach the ticket, then attach the PR link to it. For a local-markdown ticket, append a line to the ticket file pointing at the PR.

## Draft until reviewed

Open as a draft. Mark it ready only once its reviews pass — the draft state is the signal that the diff isn't asking for a merge decision yet, only visibility into work in progress.

## Mechanics

Use the `gh` CLI for every GitHub operation here — creating the PR as a draft, marking it ready, and any comment or label change along the way.
