# PRD and Spec are separate documents with no overlap

Planning produces two documents instead of one. The PRD is business-facing and owns Problem Statement, Solution, and User Stories. The Spec is technical and owns Implementation Decisions, Testing Decisions, Out of Scope, and Further Notes. The PRD is written first; the Spec references it rather than restating the problem, so each section has a single owner.

This splits the single-document template used by mattpocock/skills' `to-spec`, which mixes both audiences. Split because the two documents serve different readers and change at different rates — the business framing outlives any particular technical approach. The cost is one extra document to keep in sync; the no-overlap rule is what keeps that cost low.

## The split holds; the spec's grain changed

**Status: accepted, 2026-08-31.** The two-document split above is unchanged and is what made this possible. What changed is that there is no longer one spec per effort: `to-spec` writes one per phase, when that phase starts ([ADR-0019](0019-the-spec-is-written-per-phase.md)).

The no-overlap rule is what let the spec move without dragging the PRD with it. Because the PRD never held mechanism and the spec never held problem framing, changing the spec's cadence touched only one of the two documents — the business framing still outlives any particular technical approach, exactly as argued above, and now outlives several specs rather than one.

The sync cost this ADR accepted does not multiply with the phase count. A phase spec references the PRD and the roadmap; it does not restate them, so there is one edge to keep true per spec rather than a document to keep aligned.
