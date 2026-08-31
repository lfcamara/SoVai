---
name: to-roadmap
description: Break a large effort into phases that each ship something useful on their own. Use when a spec covers more work than one release, when the user asks how to sequence or stage a project, or when another skill needs a roadmap before tickets can be written.
---

# To Roadmap

An effort is too large to build in one go. Break it into **phases** — each one ending in something that **ships**.

Shipping is the whole discipline. A phase that ends with work merged but nothing a user can do is not a phase; it is a checkpoint someone drew on a plan. Naming those honestly is the difference between a roadmap and a wish.

## Gather context

Resolve the **effort**. Where more than one could match, ask rather than guessing.

Work from the PRD, the spec, and the wireframes under `docs/planning/<effort>/`, plus whatever the session already established. Read the codebase to see what exists today — the starting point decides how much has to happen before the first phase can ship at all.

## Draft the phases

Each phase carries:

- **What ships** — the capability that exists at the end of it, stated as something a user can do
- **Why it stands alone** — the value it delivers even if everything after it is cancelled
- **Exit criteria** — the observable conditions that make it done
- **Depends on** — the earlier phases that must land first

Two tests decide whether the breakdown holds. Apply both to every phase before showing it to anyone:

- **The cancellation test.** If every later phase were cancelled tomorrow, is the user better off than before this phase existed? A phase that fails leaves the project stranded mid-migration, and should be merged into the phase that completes its value.
- **Full coverage.** Every capability in the spec's scope lands in exactly one phase. Walk the spec and account for each one — work that appears in no phase is work that will surface late, and work that appears in two is a boundary drawn in the wrong place.

Order the phases so each one raises the floor: the earliest phases carry the load-bearing risk and the thinnest end-to-end path, later phases widen it.

Phases are coarse — a phase spans many sessions and holds several tickets. Slicing a phase into ticket-sized work is `to-tickets`, not this skill.

## Quiz the user

Present the phases as a numbered list, each with what ships, why it stands alone, and its exit criteria. Then ask:

- Does each phase ship something they would actually release?
- Is the ordering right — does anything valuable sit behind work that could come later?
- Should any phase be split or merged?

Iterate until the user approves.

That iteration is what keeps this skill in the session. Each round is a correction to the last one; a subagent receives briefs, not corrections, and every round would start from nothing.

## Write the roadmap

Write the approved breakdown to `docs/planning/<effort>/<effort> — Roadmap.md`, beside the PRD and spec.

<roadmap-template>

# <Effort name> — Roadmap

PRD: [[<effort> — PRD]] · Spec: [[<effort> — Spec]] · Wireframes: [[<effort> — Wireframes]]

## Phase 1 — <name>

**Ships:** what a user can do at the end of this phase.

**Stands alone because:** the value that survives if everything after is cancelled.

**Depends on:** earlier phases, or "Nothing — can start immediately".

**Exit criteria:**

- [ ] Criterion 1
- [ ] Criterion 2

</roadmap-template>

## Carry it forward

Phases are planned once; everything after runs **per phase**, at the start of that phase, against the codebase as it stands then. Planning a later phase's detail now means planning against a codebase that will have moved by the time the work starts.

So continue in the same session for **phase 1 only**, and leave the later phases untouched — each gets its own run when it begins:

- **The phase ships something a user sees** — run the `prototype` skill to validate the interface before it is broken into work, then let it carry on to design and tickets.
- **The phase ships no interface** — run the `to-tickets` skill directly.
