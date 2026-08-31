# Wireframes precede phasing; prototypes follow it

Validation of an interface is split across two stages sitting on either side of `to-phases`.

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

