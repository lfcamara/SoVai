# Roadmap and tickets are separate skills

Decomposing an effort into phases (`to-roadmap`) is a different skill from breaking a phase into tickets (`to-tickets`), rather than one skill that does both.

The deciding reason is cadence, not size. Phase decomposition runs once, at the end of planning. Ticket generation runs once per phase, at the start of that phase — possibly weeks later, in a fresh session, against a codebase that has moved. A single skill would have to be re-entered halfway through on every phase boundary.

Two supporting reasons. Per `writing-great-skills`, keeping the ticket-writing steps out of view while phases are still being decided avoids premature completion — phase boundaries are the judgment call, and a mechanical task in view invites rushing the judgment. And `to-tickets` already exists as an imported skill, so `to-roadmap` points at it instead of restating ticket-breaking rules in a second place.

Separate skills does not mean separate manual invocations: `to-roadmap` chains into `to-tickets` for the first phase in the same session. The seam only becomes visible when a later phase begins, which is exactly when a separate entry point is wanted.

## Renamed to to-roadmap, and there is no epic stage

**Status: accepted, 2026-08-31.** `to-phases` is now `to-roadmap`.

Every other skill in the planning block is named for the artifact it writes — `to-prd` writes the PRD, `to-spec` the Spec, `to-tickets` the tickets. This one wrote `<effort> — Roadmap.md` while calling itself `to-phases`, and was the only name in the block that did not tell you what you would get. "Phase" is untouched as the unit inside the document: it is what `CONTEXT.md` defines and what the cancellation test is applied to.

**A separate `to-epics` was considered and rejected.** It would add a third level between the roadmap and the tickets, and the argument that split this skill from `to-tickets` in the first place was **cadence** — phases are decomposed once, tickets are written per phase, weeks apart. Epics have no cadence of their own; they run exactly when phases do, which makes a separate skill a level of hierarchy bought for nothing.

"Epic" is also a tracker's word where "phase" is a shipping word, and shipping is this block's criterion. Where a project's tracker models epics, that is a **publishing** concern and `to-tickets` already handles it: it hangs each ticket off a parent issue representing its phase wherever the tracker has such a concept, which is exactly the phase-to-epic mapping, made at the moment it becomes real rather than planned as its own stage.
