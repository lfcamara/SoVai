# Phases and tickets are separate skills

Decomposing an effort into phases (`to-phases`) is a different skill from breaking a phase into tickets (`to-tickets`), rather than one skill that does both.

The deciding reason is cadence, not size. Phase decomposition runs once, at the end of planning. Ticket generation runs once per phase, at the start of that phase — possibly weeks later, in a fresh session, against a codebase that has moved. A single skill would have to be re-entered halfway through on every phase boundary.

Two supporting reasons. Per `writing-great-skills`, keeping the ticket-writing steps out of view while phases are still being decided avoids premature completion — phase boundaries are the judgment call, and a mechanical task in view invites rushing the judgment. And `to-tickets` already exists as an imported skill, so `to-phases` points at it instead of restating ticket-breaking rules in a second place.

Separate skills does not mean separate manual invocations: `to-phases` chains into `to-tickets` for the first phase in the same session. The seam only becomes visible when a later phase begins, which is exactly when a separate entry point is wanted.
