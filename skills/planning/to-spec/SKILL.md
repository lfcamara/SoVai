---
name: to-spec
description: Write the technical spec for an effort whose PRD already exists — implementation decisions, testing seams, and scope boundaries. Use after a PRD is written, when the user asks for a spec or technical design, or when another skill needs the engineering half of a plan written down.
---

# To Spec

Turn a PRD into the **spec**: the engineering half of the plan. Do not re-interview — synthesize the session, the PRD, and the codebase. Ask only where a decision genuinely has not been made.

The spec owns the **how**. It references the PRD for problem and users rather than restating them, so each fact has one home.

## Explore first

Read the codebase before writing a line of the spec. Read `CONTEXT.md` for the vocabulary and any ADRs covering the area you are touching — an ADR records a decision already made, so respect it rather than reopening it. If the spec genuinely needs to contradict one, say so explicitly and say why.

## Find the seams

A **seam** is where you can observe the feature's behaviour from outside — the surface the tests attach to. Sketch the seams before the implementation, because the seam you pick decides what the tests can see.

Prefer an existing seam to a new one, and the highest seam available to a lower one. Fewer seams across the codebase is better; one is ideal. Where a new seam is unavoidable, propose it at the highest point you can.

Put the proposed seams to the user and get agreement before writing the spec — a wrong seam is expensive to move later.

## Write it

Write to `docs/planning/<slug>/spec.md`, beside the PRD it belongs to.

<spec-template>

# <Effort name> — Spec

PRD: [prd.md](./prd.md)

## Implementation decisions

The decisions that shape the build: modules built or changed, the interfaces that move, schema changes, API contracts, architectural choices, and the constraints behind them.

## Testing decisions

The seams the tests attach to, what gets tested through each, and prior art in the codebase to follow. Good tests describe external behaviour, so state the behaviour each seam is meant to expose.

## Risks and unknowns

What could invalidate this plan, and what is still unverified.

## Out of scope

Technical work deliberately excluded — the boundaries of this spec, distinct from the product scope the PRD sets.

</spec-template>

Leave specific file paths and code snippets out; they go stale faster than the spec is read. One exception: where a prototype produced a snippet that pins a decision more precisely than prose can — a schema, a state machine, a type — inline the decision-rich part and note that it came from a prototype.

## Carry it forward

Show the user the spec and let them correct it. Then continue in the same session, taking the branch that fits the work:

- **The effort has a user-facing interface** — run the `to-wireframes` skill. Naming the screens before sequencing the work is what makes phase boundaries concrete, and wireframes routinely surface scope that would otherwise land after the roadmap was drawn.
- **No interface to draw, and the effort has intermediate points worth shipping on their own** — run the `to-phases` skill.
- **No interface, and the whole effort ships in one go** — run the `to-tickets` skill directly.
