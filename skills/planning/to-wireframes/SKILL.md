---
name: to-wireframes
description: Lay out every screen an effort needs and the flows between them, at deliberately low fidelity. Use after a spec is written and before work is sequenced into phases, when the user asks for wireframes or wants to see the shape of an interface, or when another skill needs the screens named before it can plan.
---

# To Wireframes

Name every **screen** the effort needs and the flows between them. A screen is one coherent view the user is looking at — a page on a site, a screen in an app, a step in a flow, a pane in a tool. Whatever the target platform calls it, the unit is the same.

Wireframes come before phases. A phase is defined by what it ships, and that stays abstract until the screens have names — the cancellation test is hard to apply to a capability and easy to apply to a screen a user can reach.

## Fidelity is a budget

Low fidelity is the point, not a shortcut. Fidelity spent on visuals buys critique of visuals: give a reviewer colour and type and they will discuss colour and type, while the flow that is missing a step goes unmentioned.

So spend the budget on **structure** and starve everything else:

- Boxes, labels, and hierarchy — what is on the screen and what dominates it
- Real content shape — a list of nine items, a title that wraps, an empty state. Placeholder lorem hides the problems that real length exposes
- Greyscale, one typeface, no imagery, no brand

Visual design has its own stage later. Naming it here keeps the reviewer's attention where it belongs.

## Derive the screens

Resolve the **effort**. Where more than one could match, ask rather than guessing.

Work from the PRD and spec under `docs/planning/<effort>/`. Walk the PRD's user stories and ask, for each one, which screen the actor is looking at when they do the thing. Stories cluster onto screens; a story that maps to no screen is a screen you have not drawn yet.

Cover the unglamorous states too — empty, loading, error, permission denied, first run. These are where scope hides, and finding them now is the reason this stage sits before phasing.

## Record the screens

Write `docs/planning/<effort>/<effort> — Wireframes.md`, beside the PRD, to the shape in [WIREFRAMES-FORMAT.md](./WIREFRAMES-FORMAT.md).

This file is the record and the source of truth. The brief written next is derived from it, and the canvas the user builds from that brief is the presentation — both are regenerable, and this is not. It is what `to-roadmap` and `ui-testing` read, and a plan that kept only the canvas would leave the roadmap pointing at screens nobody can find once the link is lost.

## Hand off to the design tool

The record is not what the user reacts to. Write a second file — the **design brief** — that they can take to a visual design tool as it stands: `docs/planning/<effort>/<effort> — Design Brief.md`, to the shape in [DESIGN-BRIEF-FORMAT.md](./DESIGN-BRIEF-FORMAT.md).

The brief *is* the prompt. It opens addressed to the tool and carries the fidelity budget from above, the target platform's proportions, and one block per screen. The user opens it, takes the whole thing to Claude Design or whatever they use, and gets a canvas back.

This skill does not render the canvas itself. Three reasons, and none of them is effort:

- **No dependency it cannot keep.** A design tool is someone else's skill or someone else's product. A markdown file depends on nothing and still works when that changes.
- **The user is the one sitting in the tool.** They will move things by hand regardless, so a canvas generated from this session is a canvas they immediately re-drive.
- **This session holds decisions, not execution.** Rendering here spends the orchestrator's context on presentation.

Tell the user where the brief is and what to do with it. Then stop.

## Reconcile what comes back

Wireframes exist to surface the missing step and the screen that turns out to be two — and that discovery now happens in a tool outside this session. If nothing comes back, the record is stale from the moment the user starts drawing, and `to-roadmap` will draw phase boundaries through screens that no longer exist.

So this skill has a second entrance. When the user returns with a canvas — a link, an export, or just a description of what changed — reconcile the record against it:

- Add screens that appeared, drop ones that went, update what each holds and the states it has
- Redraw the flow where transitions moved
- **Rebuild the story-coverage table**, then re-run Completion below against it
- Write the canvas URL into the record, so it points at its own presentation

Reconcile before anything downstream runs. A roadmap drawn from a stale record is the exact failure this section exists to prevent.

## Completion

The wireframes are done when **every user story in the PRD is reachable** — that is what the coverage table is for. Fill a row per story and point it at the screen where it happens. A story with no screen means a gap; a screen no story reaches means scope nobody asked for. Resolve both before moving on.

## Carry it forward

This is the one stage of planning that leaves the session, so it does not chain on its own. Stop at the handoff and say so plainly: the brief is written, and the record is provisional until the user comes back with a canvas.

Once they have and the record is reconciled, continue in the same session: run the `to-roadmap` skill. The screens are now concrete enough to draw phase boundaries through.

Deriving the screens and reconciling them both run here rather than in a subagent. The screens are settled by the user reacting to them, and a cold agent has nobody to react.
