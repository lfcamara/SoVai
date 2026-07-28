---
name: to-wireframes
description: Lay out every screen an effort needs and the flows between them, at deliberately low fidelity, as a self-contained HTML artifact. Use after a spec is written and before work is sequenced into phases, when the user asks for wireframes or wants to see the shape of an interface, or when another skill needs the screens named before it can plan.
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

Work from the PRD and spec under `docs/planning/<slug>/`. Walk the PRD's user stories and ask, for each one, which screen the actor is looking at when they do the thing. Stories cluster onto screens; a story that maps to no screen is a screen you have not drawn yet.

Cover the unglamorous states too — empty, loading, error, permission denied, first run. These are where scope hides, and finding them now is the reason this stage sits before phasing.

## Build the artifact

Load the `artifact-design` skill, then write a self-contained HTML file and publish it with the Artifact tool. An artifact works whatever the target platform is, needs no codebase, and gives the user one link to react to.

The page holds two things:

- **A flow diagram** — the screens as nodes, the transitions as labelled edges. Artifacts render Mermaid natively, so a `<pre class="mermaid">` block is enough.
- **Every screen, laid out** — each with its name, its purpose in one line, and the states it has. Size the frames to the target platform's proportions so density reads honestly; a layout that works wide often fails narrow.

## Completion

The wireframes are done when **every user story in the PRD is reachable** — walk the list and point each story at the screen where it happens. A story with no screen means a gap; a screen no story reaches means scope nobody asked for. Resolve both before moving on.

## Carry it forward

Show the user the artifact and let them react. The useful feedback is usually a missing step or a screen that turns out to be two.

Once they are satisfied, continue in the same session: run the `to-phases` skill. The screens are now concrete enough to draw phase boundaries through.
