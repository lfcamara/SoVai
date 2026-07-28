---
name: to-tickets
description: Break a phase, spec, or conversation into tracer-bullet tickets with their blocking edges, and publish them to the issue tracker. Use when work is ready to be picked up, when the user asks for tickets or issues, or when another skill needs a plan turned into trackable work.
---

# To Tickets

Break work into **tickets** — tracer bullets, each cutting a narrow but complete path through every layer, each declaring what **blocks** it.

Scope the run to one **phase** when a roadmap exists (`docs/planning/<effort>/roadmap.md`). Ticketing phases that have not started plans against a codebase that will have moved by the time they do.

## Gather context

Resolve the **effort** first — the directory under `docs/planning/` holding this work's documents. This skill routinely runs weeks after the plan was written, in a session that knows nothing but the filesystem, so where more than one effort could match, ask instead of guessing.

Work from the session, plus the spec and roadmap under `docs/planning/<effort>/` if they exist. If the user passes a reference — a path, an issue id, a URL — fetch it and read it in full.

Explore the codebase before slicing. Ticket titles and bodies use the vocabulary in `CONTEXT.md`, and respect the ADRs covering the area. Look for prefactoring that would make the real change simple: make the change easy, then make the easy change — and give the prefactoring its own ticket, first.

## Slice

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer — schema, API, UI, tests. Vertical, never a horizontal slice of one layer.
- A completed slice is demoable or verifiable on its own.
- Each slice fits in a single fresh context window.
- Prefactoring lands first.

</vertical-slice-rules>

Give each ticket its **blocking edges** — the tickets that must close before it can start. A ticket with none can start immediately.

**Wide refactors are the exception.** A mechanical change whose blast radius fans across the codebase — renaming a column, retyping a shared symbol — breaks thousands of call sites at once, and no vertical slice lands green. Sequence it as **expand–contract** instead. Expand: add the new form beside the old, so nothing breaks. Migrate: move call sites in batches sized by blast radius, each batch its own ticket blocked by the expand, CI green throughout because the old form still stands. Contract: delete the old form in a ticket blocked by every migrate batch.

## Quiz the user

Present the breakdown as a numbered list — title, blocked by, what it delivers. Then ask:

- Is the granularity right?
- Does each ticket depend only on tickets that genuinely gate it?
- Should any be merged or split?

Iterate until the user approves. Publish nothing before then.

## Publish

Read `docs/agents/issue-tracker.md` in the repo for where issues live and how this project expresses blocking. Absent that file, default to **Linear**.

Linear needs a team and a project to publish into, and neither is guessable from the repo. Look for them in the repo's `CLAUDE.md`, which is where a project records the facts every session needs. Where they are not recorded anywhere, ask once and offer to write the answer into `CLAUDE.md` — a fact re-asked every run is a fact that was never captured.

Publish in dependency order — blockers first — so each ticket can reference real identifiers by the time it needs them. Work the **frontier**: any ticket whose blockers are all published.

- **Linear** — one issue per ticket, on the project matching the effort. Use Linear's native blocking relationship for the edges, and make each ticket a sub-issue of the phase where the tracker models phases as parent issues. If the connected Linear tools cannot create issues, say so plainly and write the tickets to the local fallback instead of silently dropping them.
- **Local markdown** — one file per ticket at `docs/planning/<effort>/tickets/<NN>-<ticket-slug>.md`, numbered from `01` in dependency order. One ticket per file, never a combined file.

<ticket-template>

# <Title>

**Phase:** the phase this belongs to, linked, or omitted when there is no roadmap.

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective — not a layer-by-layer implementation list.

**Blocked by:** the tickets that gate this one, or "Nothing — can start immediately".

**Acceptance criteria:**

- [ ] Criterion 1
- [ ] Criterion 2

</ticket-template>

Keep file paths and code snippets out of ticket bodies — they go stale before the ticket is picked up. One exception: a prototype snippet that pins a decision more precisely than prose can, trimmed to the decision-rich part.

Leave any parent issue open and unmodified.
