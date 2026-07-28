# Wireframes precede phasing; prototypes follow it

Validation of an interface is split across two stages sitting on either side of `to-phases`.

`to-wireframes` runs between the spec and the roadmap, once, covering the whole effort at low fidelity. A phase is defined by what it ships, and that stays abstract until the screens have names — the cancellation test is hard to apply to a capability and easy to apply to a screen. Wireframes also routinely surface scope nobody had accounted for, and discovering that after the roadmap is drawn means redrawing it.

`prototype` runs per phase, after the roadmap and before tickets, at higher fidelity and only for what that phase ships. Prototyping every phase up front would validate interfaces against a codebase and a product that will have moved by the time those phases start. This is the same cadence argument that separated phases from tickets in ADR-0003.

Final visual design (`frontend-design`, an ambient skill this plugin does not own) comes after a prototype has validated the structure, so design effort is spent on a direction that survived contact with the user.

The pipeline is therefore: spec → wireframes → phases → per phase: prototype → design → tickets.

Deliberately platform-agnostic. The unit is a "screen", covering a page on a site, a screen in an app, or a step in a flow, and the prototype's variant switcher is specified by the properties it must have rather than by a web mechanism. The upstream `prototype` skill from mattpocock/skills assumed both a web target and an existing codebase; neither holds for a project still being planned, and the target platform for any given effort is not known in advance.
