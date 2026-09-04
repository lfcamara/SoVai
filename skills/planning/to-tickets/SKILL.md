---
name: to-tickets
description: Break a phase, spec, or conversation into tracer-bullet tickets with their blocking edges, and publish them to the issue tracker. Use when work is ready to be picked up, when the user asks for tickets or issues, or when another skill needs a plan turned into trackable work.
---

# To Tickets

Break work into **tickets** — tracer bullets, each cutting a narrow but complete path through every layer, each declaring what **blocks** it.

Scope the run to one **phase** when a roadmap exists (`docs/planning/<effort>/<effort> — Roadmap.md`). Ticketing phases that have not started plans against a codebase that will have moved by the time they do.

## Gather context

Resolve the **effort** first. This skill routinely runs weeks after the plan was written, in a session that knows nothing but the filesystem, so where more than one could match, ask instead of guessing.

Work from the session, plus the roadmap and this phase's spec (`<effort> — Phase <N> Spec.md`) under `docs/planning/<effort>/` if they exist. A spec belongs to one phase, so read the one for the phase being ticketed and leave the others alone. If the user passes a reference — a path, an issue id, a URL — fetch it and read it in full.

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

### Resolve the tracker

The tracker is recorded in the project's `sovai.config.json`, under a `tracker` key:

```json
"tracker": { "kind": "linear", "team": "Core", "project": "Billing", "phasesAsParents": true }
```

That file already exists in any project SoVai gates, sits at the project root, and is found by walking up from the work — so tracker facts live where every other per-project fact already does, rather than in a second convention nobody remembers to write.

Where no `tracker` is recorded, ask once: which tracker, and the destination it needs. Offer to write the answer into `sovai.config.json` — a fact re-asked every run is a fact that was never captured. Where the user is not reachable, publish to local markdown and say plainly that you did.

**Resolve, never assume.** Every run gets its tracker from one of exactly three places — the config, the user, or the floor. Guessing a fourth means publishing into somebody's wrong project or failing against a service nobody connected, and both read as the plugin being broken.

A project needing more than the config holds — a house convention for how blocking is expressed, a naming rule for titles — records it in `docs/agents/issue-tracker.md`. Read that file where it exists: it refines the config, never replaces it.

### Publish in dependency order

Read [TRACKERS.md](./TRACKERS.md) for what the resolved tracker calls each of the four capabilities publishing needs, and for the mechanics of expressing a blocking edge there.

Publish blockers first, so each ticket can reference real identifiers by the time it needs them. Work the **frontier**: any ticket whose blockers are all published.

Write each ticket to the shape in [TICKET-FORMAT.md](./TICKET-FORMAT.md). The body is identical whatever the tracker; only the mechanics of the edge change.

## Cut the phase branch

The last act of publishing is cutting the branch the phase will land on: `phase/<effort>-<NN>`, cut from `main`, pushed. Every ticket in this phase branches from it, and it merges to `main` once, when the phase closes — the phase is the unit that ships, so it is the unit `main` receives (ADR-0020). Where it already exists from an earlier run of this phase, use it as it stands.

Confirm `worktrees/` is in the project's `.gitignore` before any ticket is dispatched, adding the line where it is missing. Each ticket is worked in a worktree under that directory, and an unignored one turns every code search in the project into duplicate hits across N copies of the tree.

## Carry it forward

Publishing ends planning. What exists now is a **frontier** — the tickets whose blockers have all closed — and each of those is workable immediately.

Execution runs one ticket at a time through the `implement` skill, dispatched to an `implementer` per the `delegate` contract, and tickets on the frontier can run in parallel. `delegate` moves a ticket to **Doing** as it dispatches — the frontier is computed from ticket state, so a ticket being worked while still showing To Do invites a second session to claim it.

Tickets go straight into the loop. Where the user asks to see what will be tested on a ticket before code is written, say so in that ticket's brief: the implementer returns its list of behaviours and stops, and you re-dispatch with the approved list (ADR-0011). Unlike the planning stages, that round trip does not continue in the same session — a ticket is sized to a fresh context window, and spending that window on the planning conversation that produced it defeats the sizing.
