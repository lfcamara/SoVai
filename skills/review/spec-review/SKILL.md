---
name: spec-review
description: The spec axis of `review` — whether a diff builds the right thing: a requirement missing, partial, implemented wrong, or scope the ticket promised that the diff does not carry. Use when `review` dispatches this axis.
---

# Spec Review

Reviews WHETHER THE RIGHT THING was built, not how it's written — that split is what `code-review` is for. Impeccable code that implements the wrong thing passes every other axis; this is the one that catches it.

## Locate the spec

Check in this order and stop at the first hit:

1. The **ticket** the work came from — a reference in the commit messages or the diff's branch name.
2. `docs/planning/<effort>/<effort> — Phase <N> Spec.md` for the phase the ticket belongs to, and `<effort> — PRD.md` for the effort. The ticket names its phase; where it does not, the roadmap does.
3. A path the user supplies directly.

If none of the three turn up anything, say so plainly and stop — report "no spec available" rather than inventing a standard to judge the diff against. A finding without a spec behind it is a preference wearing this axis's clothes.

## What to report

Every finding quotes the spec line it comes from. A finding with no citation is a preference, not a finding — leave it out.

- **Missing or partial** — something the spec asked for that the diff doesn't do, or only half does.
- **Unasked (scope creep)** — behaviour present in the diff that no line in the spec called for.
- **Implemented wrong** — a requirement that looks handled but whose behaviour diverges from what the spec actually says.
- **Deferred but presented as delivered** — scope the ticket promised that the diff does not carry, where nothing says it was put off. Check the ticket's own acceptance criteria as a checklist, not just the spec's prose. Work the PR or the ticket explicitly names as deferred — a follow-up ticket, a stated later phase — is a fact and often a sound call; the finding is silence about it, because that is what reaches the merge looking complete.

Where the spec is a PRD (business-facing: problem, solution, user stories) rather than a technical spec, hold the diff to the behaviour those stories imply, not to implementation details the PRD never had — that's `code-review`'s ground.

## Entered directly

Dispatched by `review`, this axis inherits a pinned fixed point, the severity ladder it assigns against, and a record `wrap-up` reads before it merges. Reached on its own it has none of those, so say that with the findings — and where the work is heading for a merge, run `review` for this axis instead, so what you find lands where the merge gate can see it.

## Severity

Assign each finding a severity per `review`'s ladder. On this axis, high is a requirement missing, partial, or implemented wrong that a user will run into; critical is reserved for the case where that gap is itself what leaves data loss or a security breach unguarded — a requirement the spec stated precisely to prevent one.
