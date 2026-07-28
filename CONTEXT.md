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

**Effort**:
One unit of planned work, from idea through tickets. Its name is the kebab-case directory under `docs/planning/` holding every document it produces — `to-prd` names it, every later stage resolves it.
_Avoid_: Feature, project, initiative, epic

**Screen**:
One coherent view the user is looking at, whatever the platform calls it — a page on a site, a screen in an app, a step in a flow.
_Avoid_: Page, view, route (each is platform-specific; "screen" is the neutral term)

**Wireframe**:
A low-fidelity layout of the screens and the flows between them, deliberately greyscale and unstyled so review lands on structure rather than visuals.
_Avoid_: Mockup, sketch, design

**Prototype**:
Throwaway code that answers one design question, built without tests or abstractions and never promoted to production.
_Avoid_: MVP, spike, proof of concept
