# PRD and Spec are separate documents with no overlap

Planning produces two documents instead of one. The PRD is business-facing and owns Problem Statement, Solution, and User Stories. The Spec is technical and owns Implementation Decisions, Testing Decisions, Out of Scope, and Further Notes. The PRD is written first; the Spec references it rather than restating the problem, so each section has a single owner.

This splits the single-document template used by mattpocock/skills' `to-spec`, which mixes both audiences. Split because the two documents serve different readers and change at different rates — the business framing outlives any particular technical approach. The cost is one extra document to keep in sync; the no-overlap rule is what keeps that cost low.
