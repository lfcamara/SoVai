---
name: to-spec
description: Write the technical spec for an effort whose PRD already exists — implementation decisions, testing seams, and scope boundaries. Use after a PRD is written, when the user asks for a spec or technical design, or when another skill needs the engineering half of a plan written down.
---

# To Spec

Turn a PRD into the **spec**: the engineering half of the plan. Do not re-interview — synthesize the session, the PRD, and the codebase. Ask only where a decision genuinely has not been made.

The spec owns the **how**. It references the PRD for problem and users rather than restating them, so each fact has one home.

## Resolve the effort

Resolve the **effort** before reading anything else. Where more than one could match, ask — writing into the wrong effort corrupts a plan silently, and one question costs nothing against that.

## Explore first

Read the codebase before writing a line of the spec. Read `CONTEXT.md` for the vocabulary and any ADRs covering the area you are touching — an ADR records a decision already made, so respect it rather than reopening it. If the spec genuinely needs to contradict one, say so explicitly and say why.

## Find the seams

Sketch the **seams** before the implementation — the `tdd` skill defines them and this is where they get chosen, because the seam you pick decides what the tests can see.

Prefer an existing seam to a new one, and the highest seam available to a lower one. Fewer seams across the codebase is better; one is ideal. Where a new seam is unavoidable, propose it at the highest point you can.

Put the proposed seams to the user and get agreement before writing the spec — a wrong seam is expensive to move later.

This gate is why the spec is written in this session rather than dispatched to a subagent: a cold agent has nobody to put the seams to, and would pick one and carry on.

## Write it

Write to `docs/planning/<effort>/<effort> — Spec.md`, beside the PRD it belongs to.

Write it to exactly the shape in [SPEC-FORMAT.md](./SPEC-FORMAT.md). Read that file before writing, and follow its sections and their order — `spec-review` and `implement` both read this document by heading.

Leave specific file paths and code snippets out; they go stale faster than the spec is read. One exception: where a prototype produced a snippet that pins a decision more precisely than prose can — a schema, a state machine, a type — inline the decision-rich part and note that it came from a prototype.

## Carry it forward

Show the user the spec and let them correct it. Then continue in the same session, taking the branch that fits the work:

- **The effort has a user-facing interface** — run the `to-wireframes` skill. Naming the screens before sequencing the work is what makes phase boundaries concrete, and wireframes routinely surface scope that would otherwise land after the roadmap was drawn.
- **No interface to draw, and the effort has intermediate points worth shipping on their own** — run the `to-roadmap` skill.
- **No interface, and the whole effort ships in one go** — run the `to-tickets` skill directly.
