---
name: to-roadmap
description: Break a large effort into phases that each ship something useful on their own. Use when a PRD covers more work than one release, when the user asks how to sequence or stage a project, or when another skill needs the work sequenced before any of it can be specced.
---

# To Roadmap

An effort is too large to build in one go. Break it into **phases** — each one ending in something that **ships**.

Shipping is the whole discipline. A phase that ends with work merged but nothing a user can do is not a phase; it is a checkpoint someone drew on a plan. Naming those honestly is the difference between a roadmap and a wish.

## Gather context

Resolve the **effort**. Where more than one could match, ask rather than guessing.

Work from the PRD and the wireframes under `docs/planning/<effort>/`, plus whatever the session already established.

## Settle the technical forks first

Read the codebase before drawing any phase: the starting point decides how much has to happen before the first one can ship at all.

A **fork** surfaces here whenever the sequencing depends on a technical choice nobody has made — build or buy, one service or two, synchronous or event-driven, migrate in place or alongside. Settle it now, with the user. A roadmap drawn over an unmade decision reorders itself the moment the decision lands.

Where a fork passes all three tests in `domain-modeling`'s ADR format — hard to reverse, surprising without context, the result of a real trade-off — write the ADR before the roadmap. Those ADRs are the whole of an effort's architecture record. There is deliberately no effort-wide technical document: implementation detail is written per phase, when that phase starts, while an architectural decision outlives every phase it touches and belongs somewhere built to be revised.

## Draft the phases

Each phase carries:

- **What ships** — the capability that exists at the end of it, stated as something a user can do
- **Why it stands alone** — the value it delivers even if everything after it is cancelled
- **Exit criteria** — the observable conditions that make it done
- **Depends on** — the earlier phases that must land first

Two tests decide whether the breakdown holds. Apply both to every phase before showing it to anyone:

- **The cancellation test.** If every later phase were cancelled tomorrow, is the user better off than before this phase existed? A phase that fails leaves the project stranded mid-migration, and should be merged into the phase that completes its value.
- **Full coverage.** Every user story in the PRD, and every screen in the wireframes, lands in exactly one phase. Walk both and account for each — work that appears in no phase is work that will surface late, and work that appears in two is a boundary drawn in the wrong place. An effort with no interface arrives here with no wireframes and covers the user stories alone; say that you did, because a coverage claim is only as strong as the lists it walked.

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

Write the approved breakdown to `docs/planning/<effort>/<effort> — Roadmap.md`, beside the PRD, to the shape in [ROADMAP-FORMAT.md](./ROADMAP-FORMAT.md).

## Carry it forward

Phases are planned once; everything after runs **per phase**, at the start of that phase, against the codebase as it stands then. Planning a later phase's detail now means planning against a codebase that will have moved by the time the work starts.

That is why the spec sits below this line rather than above it. It is the most detail-dense document the pipeline produces — seams, interfaces, schema, contracts — so writing one for the whole effort up front spends the most detail at the moment least is known.

So continue in the same session for **phase 1 only**, and leave the later phases untouched — each gets its own run when it begins: run the `to-spec` skill for phase 1.
