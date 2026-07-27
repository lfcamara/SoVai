---
name: to-prd
description: Write the PRD for an idea that has already been shaped — problem, solution, and user stories, in the language of the people who have the problem. Use when a brainstorm has reached shared understanding, when the user asks for a PRD, or when another skill needs the business half of a plan written down.
---

# To PRD

Synthesize what the session already established into a **PRD**: the business-facing half of the plan. The interview happened in `brainstorm` — draw on it rather than reopening it. Ask only where synthesis exposes a genuine gap.

The PRD owns the **what** and the **why**. The **how** belongs to the spec (`to-spec`), which is written next and references this document. Leaving implementation out is what keeps the two documents from drifting apart.

## Write it

Use the project's domain glossary (`CONTEXT.md`) for every term, so the PRD, the code, and the conversation stay in one vocabulary.

Write to `docs/planning/<slug>/prd.md`, where `<slug>` names the effort in kebab-case. Create the directory if it does not exist.

<prd-template>

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

</prd-template>

Keep mechanism, file paths, and code out of it. A reader who does not write code should be able to read the PRD end to end and recognize their own problem in it — that is the checkable standard for whether it is written at the right altitude.

## Carry it forward

Show the user the PRD and let them correct it. Once they are satisfied, continue in the same session: run the `to-spec` skill.
