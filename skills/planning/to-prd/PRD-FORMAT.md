# PRD Format

The PRD lives at `docs/planning/<effort>/<effort> — PRD.md`.

## Template

```md
# <Effort name>

## Problem

The problem the user faces, from the user's perspective. What it costs them today.

## Solution

What changes for that user once this exists — described as an experience, not a mechanism.

## User stories

A long, numbered list, extensive enough to cover the whole feature:

1. As an <actor>, I want <capability>, so that <benefit>

## Success

How we will know this worked. Prefer an observable signal over a sentiment.

## Out of scope

What this effort deliberately leaves out, and why. The explicit no's carry as much weight as the yes's.
```

## Rules

- **Every section, in this order.** A later stage resolves the PRD by path and reads it by heading, so a missing or renamed section is a section that silently does not exist.
- **Numbered user stories.** `to-wireframes` builds its story-coverage table by number, and `ui-testing` derives a test list from that table. An unnumbered list breaks both.
- **One vocabulary.** Every term comes from the project's `CONTEXT.md`.
