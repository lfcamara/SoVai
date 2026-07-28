---
name: ui-testing
description: Write tests for a screen, component, or flow after it is implemented, derived from the effort's wireframes.md story-coverage table. Use when the user wants to test a UI that has already been built, asks for UI test coverage or regression tests for a screen, wants to verify a wireframed flow works end to end, or needs tests for a screen's empty, loading, error, or permission-denied states.
---

# UI Testing

## Test after, not first

TDD is mandatory for backend work, but a UI is the deliberate exception: test it after implementation, not before. A UI's shape moves during build — layout, copy, and structure shift as the screen takes form — and a test written against that moving shape breaks on every change without ever catching a real defect. Write the screen, then write its tests.

## Coverage is a budget

The target is covering the wireframes, not finding every scenario a UI could theoretically hit. A suite chasing maximum coverage on a UI grows slow and brittle, gets disabled at the first flaky run, and a disabled suite protects nothing — which is worse than a smaller suite the team trusts.

`docs/planning/<effort>/wireframes.md` already names exactly what matters: every screen, the states each one has, and a story-coverage table mapping each PRD user story to the screen where it happens. That table is a ready-made, checkable spec — derive the test list from it rather than from what you can imagine going wrong.

## Derive the test list

Resolve the effort and read `docs/planning/<effort>/wireframes.md`. For each row of the story-coverage table, write down the story and the screen it maps to — this is your minimum test list, one item per row. Then walk each screen's **States** entry and add one item per state listed (empty, loading, error, permission denied, first run, or whatever else that screen names).

Where no wireframes exist — work that predates the pipeline, or a screen that arrived without one — derive the same two lists from the screen itself: what a user can do on it, and the states it can be in. Say that you did this, because a list read off an implementation inherits its blind spots, while one read off wireframes was agreed before the code existed.

Weight the suite toward states over the happy path. Happy path is the case every implementation gets built around, so it rarely ships broken; empty, loading, error, and permission-denied are the branches nobody exercised by hand, and that is where defects actually ship.

## Write at the seam

Test at the seam a user actually operates — what is rendered and what responds to interaction — never component internals or state variables. Follow the `tdd` skill's Seams and Anti-patterns sections for what that means in practice; nothing about seams changes because the target is a UI.

Where the platform has an accessibility tree, query by role and accessible name rather than by CSS selector or test id. A control your test can only reach by selector is usually a control a screen-reader user can't reach either, so writing the test this way makes the accessibility check and the behavioral check the same act. Follow whatever testing library the project already uses to do this — this skill names no framework.

## Completion

Done when every row of the story-coverage table has at least one test, and every state listed for each screen is exercised by at least one test. Check both directions: a story with no test is a gap to close; a test covering something no story asked for and no state names is scope nobody requested — cut it rather than keep it for thoroughness's sake.
