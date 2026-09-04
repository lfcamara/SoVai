---
name: to-prd
description: Write the PRD for an idea that has already been shaped — problem, solution, and user stories, in the language of the people who have the problem. Use when a brainstorm has reached shared understanding, when the user asks for a PRD, or when another skill needs the business half of a plan written down.
---

# To PRD

Synthesize what the session already established into a **PRD**: the business-facing half of the plan. The interview happened in `brainstorm` — draw on it rather than reopening it. Ask only where synthesis exposes a genuine gap.

The PRD owns the **what** and the **why**. The **how** belongs to the spec (`to-spec`), which is written next and references this document. Leaving implementation out is what keeps the two documents from drifting apart.

## Name the effort

Everything this work produces — spec, wireframes, roadmap, tickets — lives in one directory: `docs/planning/<effort>/`, where `<effort>` is a kebab-case slug naming the work.

Name it here, before writing anything. Every later stage finds its inputs by resolving that directory, and stages run weeks apart in fresh sessions with nothing but the filesystem to go on. The name is the anchor the whole pipeline hangs from, so prefer one that will still be recognizable when the session that chose it is long gone.

**A new effort gets a new directory, always.** A feature arriving at a project that already has efforts on disk starts its own. A PRD is a dated argument for one piece of work: what the problem was, what was in, and what was deliberately left out. Editing it to also cover work decided months later destroys the record of both. Where the new effort builds on an earlier one, link to it and move on. What genuinely outlives an effort — the vocabulary, the architectural decisions — already has homes in `CONTEXT.md` and `docs/adr/`, and those are built to be revised.

## Write it

Use the project's domain glossary (`CONTEXT.md`) for every term, so the PRD, the code, and the conversation stay in one vocabulary.

Write to `docs/planning/<effort>/<effort> — PRD.md`, creating the directory if it does not exist.

Write it to exactly the shape in [PRD-FORMAT.md](./PRD-FORMAT.md). Read that file before writing, and follow its sections and their order — later stages read this document by heading.

Keep mechanism, file paths, and code out of it. A reader who does not write code should be able to read the PRD end to end and recognize their own problem in it — that is the checkable standard for whether it is written at the right altitude.

## Carry it forward

Show the user the PRD and let them correct it. Then continue in the same session, taking the branch that fits the work:

- **The effort has a user-facing interface** — run the `to-wireframes` skill. Naming the screens before sequencing the work is what makes phase boundaries concrete, and wireframes routinely surface scope that would otherwise land after the roadmap was drawn.
- **No interface to draw** — run the `to-roadmap` skill directly, and say that you skipped wireframes so the roadmap knows to cover the user stories alone.

The spec comes later either way. It is written once per phase, when that phase starts, from the roadmap entry that scopes it (ADR-0019) — so it is `to-roadmap` that reaches it, never this skill.

Write the PRD here rather than dispatching it. Synthesis is a judgement about what the session meant, and the session is the only place that judgement can be made — a subagent would be handed the transcript and asked to guess at it.
