# SoVai

A Claude Code plugin: general-purpose engineering workflow harness, organized into workflow blocks (planning, development, testing/review, debug, wrap-up, prototyping).

## Language

**Block**:
A phase of the engineering workflow (e.g. Planning, Development) that groups a set of related skills.
_Avoid_: Stage, phase, module

**Brainstorm**:
The interview stage of the Planning block — a `grilling`-based session that turns a loose idea into a shared understanding, one question at a time.
_Avoid_: Interview, grill session (use "grilling" only for the underlying skill name)

**PRD**:
The business-facing planning document: problem statement, solution, and user stories. Written first, in plain language, owning the "what and why".
_Avoid_: Product doc, requirements doc, brief

**Spec**:
The technical planning document: implementation decisions, testing decisions, out of scope. Written after the PRD and referencing it, owning the "how".
_Avoid_: Technical design doc, RFC, plan

**Phase**:
A stage of an effort that ends in something shippable and valuable on its own, spanning many sessions and holding several tickets.
_Avoid_: Milestone, stage, sprint

**Ticket**:
A vertical slice of work sized to one agent session, declaring the tickets that block it.
_Avoid_: Issue, task, story (the tracker may call it an issue; the skills call it a ticket)

**Seam**:
The surface at which a feature's behaviour can be observed from outside — where tests attach.
_Avoid_: Boundary, interface, test hook
