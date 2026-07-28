---
name: spec-review
description: Review whether a diff builds the right thing — missing requirements, scope creep, and requirements implemented wrongly. Use to check a diff against its originating ticket, spec, or PRD, or when the review skill dispatches its spec axis.
---

# Spec Review

Reviews WHETHER THE RIGHT THING was built, not how it's written — that split is what `code-review` is for. Impeccable code that implements the wrong thing passes every other axis; this is the one that catches it.

## Locate the spec

Check in this order and stop at the first hit:

1. The **ticket** the work came from — a reference in the commit messages or the diff's branch name.
2. `docs/planning/<effort>/spec.md` and `prd.md` for the effort this work belongs to.
3. A path the user supplies directly.

If none of the three turn up anything, say so plainly and stop — report "no spec available" rather than inventing a standard to judge the diff against. A finding without a spec behind it is a preference wearing this axis's clothes.

## What to report

Every finding quotes the spec line it comes from. A finding with no citation is a preference, not a finding — leave it out.

- **Missing or partial** — something the spec asked for that the diff doesn't do, or only half does.
- **Unasked (scope creep)** — behaviour present in the diff that no line in the spec called for.
- **Implemented wrong** — a requirement that looks handled but whose behaviour diverges from what the spec actually says.

Where the spec is a PRD (business-facing: problem, solution, user stories) rather than a technical spec, hold the diff to the behaviour those stories imply, not to implementation details the PRD never had — that's `code-review`'s ground.
