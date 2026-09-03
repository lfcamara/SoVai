# Wireframes precede phasing; prototypes follow it

Validation of an interface is split across two stages sitting on either side of `to-roadmap`.

`to-wireframes` runs between the spec and the roadmap, once, covering the whole effort at low fidelity. A phase is defined by what it ships, and that stays abstract until the screens have names — the cancellation test is hard to apply to a capability and easy to apply to a screen. Wireframes also routinely surface scope nobody had accounted for, and discovering that after the roadmap is drawn means redrawing it.

`prototype` runs per phase, after the roadmap and before tickets, at higher fidelity and only for what that phase ships. Prototyping every phase up front would validate interfaces against a codebase and a product that will have moved by the time those phases start. This is the same cadence argument that separated phases from tickets in ADR-0003.

Final visual design (`frontend-design`, an ambient skill this plugin does not own) comes after a prototype has validated the structure, so design effort is spent on a direction that survived contact with the user.

The pipeline is therefore: spec → wireframes → phases → per phase: prototype → design → tickets.

Deliberately platform-agnostic. The unit is a "screen", covering a page on a site, a screen in an app, or a step in a flow, and the prototype's variant switcher is specified by the properties it must have rather than by a web mechanism. The upstream `prototype` skill from mattpocock/skills assumed both a web target and an existing codebase; neither holds for a project still being planned, and the target platform for any given effort is not known in advance.

## Prototyping leaves the automatic chain

**Status: accepted, 2026-08-31.** Amends the per-phase cadence above, which had `to-roadmap` chain into `prototype` for every phase shipping an interface.

The cadence argument was right and is untouched: a prototype belongs to the phase that is starting, never to the whole effort up front. What was wrong is running one unconditionally. A prototype is throwaway code that answers a question, and a phase reaching this point has a PRD, wireframes, a spec and a roadmap behind it. Most of them arrive with nothing open. Building one anyway spends a session producing an answer nobody was waiting for, and — worse for a harness whose whole claim is that each stage earns its place — teaches the user that a stage can be ceremony.

`to-roadmap` now goes to `to-tickets` and offers `prototype` instead of invoking it. The offer has a trigger rather than a mood: the spec's **Risks and unknowns** section names what is still unverified, and a prototype is warranted when something there is a question only running code settles. Where that section is empty of such questions, the offer is not made at all — an offer raised every time is a chain wearing a question mark.

`prototype` itself stops assuming it was reached by a chain. It records its answer, hands to `frontend-design` where visual design is the next open question, and otherwise stops and reports rather than continuing into `to-tickets` — because it is now usually entered deliberately, mid-phase, by a user who had a question, and it has no way to know what that session was doing before it arrived.

The skill is unchanged in every other respect and is still model-invocable. What it loses is a guaranteed slot in the pipeline, which was the only thing making it fire when nobody had asked a question.


## to-wireframes hands off instead of rendering

**Status: accepted, 2026-08-31.** Amends the stage above, which had `to-wireframes` build and publish the artifact the user reacts to.

The skill did two separable things. It **derived** the screens from the PRD's user stories, recorded them, and checked story coverage — the load-bearing half, read downstream by `to-roadmap` for phase boundaries and by `ui-testing` for its minimum test list. And it **rendered** them, by hand, as a self-contained HTML artifact.

The rendering is now a handoff. `to-wireframes` writes a second file, `<effort> — Design Brief.md`, which is not a document about the design but the prompt itself: addressed to a design tool, carrying the fidelity budget, the platform proportions, and one block per screen. The user takes it to Claude Design or whatever they use.

Three reasons, none of them effort. A design tool is someone else's skill or someone else's product, and a markdown file depends on nothing and survives that changing — where auto-invoking a tool the plugin does not own would make the pipeline's most visual stage its most fragile. The user is the one who will sit in the tool moving things by hand, so a canvas generated from this session is a canvas they immediately re-drive. And the orchestration mandate says this session holds decisions rather than execution; rendering spends its context on presentation.

**The cost is a real stop in the pipeline, and it is paid deliberately.** Wireframes exist to surface the missing step and the screen that turns out to be two, and that reaction now happens outside the session. So the chain does not continue on its own here — the only planning stage where it does not — and the skill gains a second entrance: the user comes back with a canvas, and the record, the flow, and the story-coverage table are reconciled against what was actually drawn before `to-roadmap` runs. A roadmap drawn through a stale record is the failure that reconciliation exists to prevent.

The record stays the source of truth, which is what makes the trade safe: the brief is derived from it and the canvas from the brief, so both are regenerable and neither is load-bearing.

The templates for both documents moved out to `WIREFRAMES-FORMAT.md` and `DESIGN-BRIEF-FORMAT.md`, matching the format files the rest of the planning block now uses.


## The order stated above is superseded

**Status: superseded, 2026-08-31.** The line "spec → wireframes → phases → per phase: prototype → design → tickets" no longer describes the pipeline. The spec moved below the roadmap and became per-phase ([ADR-0019](0019-the-spec-is-written-per-phase.md)), and prototyping left the automatic chain in the amendment above.

The current order is PRD → wireframes → roadmap → per phase: spec → (prototype, on request) → tickets. Everything this ADR decided about wireframes preceding phasing is unaffected: the argument was always that phase boundaries need named screens, and screens come from the PRD's user stories rather than from the spec.
