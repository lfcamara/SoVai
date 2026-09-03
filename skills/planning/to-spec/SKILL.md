---
name: to-spec
description: Write the technical spec for the phase about to start — implementation decisions, testing seams, and scope boundaries. Use when a phase begins and its work needs specifying, when the user asks for a spec or technical design, or when another skill needs the engineering half of a plan written down.
---

# To Spec

Turn the phase about to start into its **spec**: the engineering half of the plan, scoped to what that phase ships. Do not re-interview — synthesize the session, the PRD, the roadmap, and the codebase. Ask only where a decision genuinely has not been made.

The spec owns the **how**. It references the PRD for problem and users, and the roadmap for what this phase ships, rather than restating either — so each fact has one home.

**One spec per phase, written when that phase starts.** It is the most detail-dense document the pipeline produces, and detail planned against a codebase that will have moved is detail thrown away. The decisions that outlive any single phase are not in here at all: they are ADRs, written during `to-roadmap` when the sequencing forced them.

## Resolve the effort and the phase

Resolve the **effort**, then the **phase** inside it. Where more than one could match, ask — writing into the wrong one corrupts a plan silently, and one question costs nothing against that.

This skill routinely runs weeks after the roadmap was drawn, in a session that knows nothing but the filesystem. Read that phase's entry in `docs/planning/<effort>/<effort> — Roadmap.md` for what it ships and its exit criteria. Those are the scope of this spec; anything outside them belongs to a phase that has not started.

## Explore first

Read the codebase before writing a line of the spec. Read `CONTEXT.md` for the vocabulary and the ADRs covering the area you are touching — including the ones `to-roadmap` wrote for this effort, which carry the architectural forks already settled. An ADR records a decision already made, so respect it rather than reopening it. If the spec genuinely needs to contradict one, say so explicitly and say why.

## Find the seams

Sketch the **seams** before the implementation — the `tdd` skill defines them and this is where they get chosen, because the seam you pick decides what the tests can see.

Prefer an existing seam to a new one, and the highest seam available to a lower one. Fewer seams across the codebase is better; one is ideal. Where a new seam is unavoidable, propose it at the highest point you can.

Put the proposed seams to the user and get agreement before writing the spec — a wrong seam is expensive to move later.

This gate is why the spec is written in this session rather than dispatched to a subagent: a cold agent has nobody to put the seams to, and would pick one and carry on.

## Write it

Write to `docs/planning/<effort>/<effort> — Phase <N> Spec.md`, beside the PRD and the roadmap it serves. The phase number is in the filename because the vault graph shows a note's name and nothing else, and a project with three efforts of three phases would otherwise draw nine nodes labelled "Spec".

Write it to exactly the shape in [SPEC-FORMAT.md](./SPEC-FORMAT.md). Read that file before writing, and follow its sections and their order — `spec-review` and `implement` both read this document by heading.

Leave specific file paths and code snippets out; they go stale faster than the spec is read. One exception: where a prototype produced a snippet that pins a decision more precisely than prose can — a schema, a state machine, a type — inline the decision-rich part and note that it came from a prototype.

## Carry it forward

Show the user the spec and let them correct it. Then continue in the same session: run the `to-tickets` skill for this phase.

**Prototyping is a question you raise, not a stage you run.** Where the **Risks and unknowns** you just wrote names something only running code would settle — a state model nobody can reason about on paper, a layout that may not survive real content — name that question and let the user decide whether to spend a `prototype` run on it first. Where nothing there is open, go to tickets and leave it unmentioned.
