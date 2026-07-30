# SoVai

A Claude Code plugin: general-purpose engineering workflow harness, organized into workflow blocks.

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

**Vault**:
The project repo's `docs/` folder, which is also an Obsidian vault. Documents link each other with wikilinks, and those links are what make it a graph rather than a pile.
_Avoid_: Knowledge base, wiki, docs folder

**Severity**:
The weight of a review finding — critical, high, medium, or low — assigned by the axis that found it. Critical and high are always fixed; medium and low only when the user says so.
_Avoid_: Priority, importance, level

**Cause**:
Why a finding was not prevented, recorded on the finding itself. A cause names the gap in the process ("no rule covers this"), never the moment or the person ("missed it") — a cause that repeats is what `harden` acts on.
_Avoid_: Reason, root cause (reserve that for the bug being diagnosed, not the process gap)

**Feedback loop**:
One command that goes red on a specific bug and green once it is fixed — red-capable, deterministic, fast, and runnable unattended. Building it is what finds a bug; hypothesising before it exists is the failure the debug block prevents.
_Avoid_: Repro, test case, harness

**Evidence**:
The output of the check that would have contradicted a claim, shown beside it — the test summary, the screenshot and the entry point that produced it, the lines that failed. A claim of done without it is a belief worded as a fact. A subagent boundary compresses the output, never the requirement.
_Avoid_: Proof, verification, result

**Gate**:
A mechanism that refuses rather than advises — a hook that will not let a session end with production logic edited and `tdd` never entered, or a rule that withholds the word "done" until its check has run. Gates here fail open: no configuration means no gating, because a gate that breaks a session gets uninstalled and takes every rule it carried with it.
_Avoid_: Check, guard, blocker, hook (the hook is the mechanism; the gate is what it refuses)

**Axis**:
One independent dimension of review — code, spec, test, security, migration, goal. Each runs as its own parallel `reviewer` subagent and is reported separately, never merged with the others.
_Avoid_: Check, pass, dimension

**Frontier**:
The tickets whose blockers have all closed — the set that can be worked, and therefore parallelized, right now.
_Avoid_: Ready set, available work, backlog

**Brief**:
The complete instruction set handed to a subagent: outcome, skill, inputs, done criteria, scope fence, and what to report. It is everything the subagent gets, since none of the orchestrator's conversation reaches it.
_Avoid_: Prompt, task description, instructions

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
