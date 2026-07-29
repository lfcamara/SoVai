---
name: test-review
description: Review the tests in a diff — whether they'd catch a real regression, sit at the right seam, and cover the cases that break. Use when reviewing a diff's test coverage or test quality, or when another skill needs the testing axis of a review run.
---

# Test Review

This axis reviews the tests a diff adds or changes, not the production code they cover — that's `code-review`'s job — and not whether the right feature was built — that's `spec-review`'s job. A test file with no production changes beside it is still in scope; production code with no test changes beside it is a finding for this axis to raise.

Hold every test in the diff against the `tdd` skill's definition of a good test, its seams, and its three anti-patterns (implementation-coupled, tautological, horizontal slicing) — this skill does not restate them. What follows is what to check for, and how to spot it in a diff specifically.

## Would it fail on a real regression

The question that matters is not "does this test pass" but "would this test fail if the behavior it names broke." A test that passes regardless of what the code does is worse than no test: it occupies the slot a real test should hold and reads as coverage that isn't there.

Tells to check in the diff:

- An assertion that's trivially true for any implementation — `expect(result).toBeDefined()`, `expect(response.status).not.toBe(500)` where the test's name promises something specific.
- A mock configured to return exactly what the assertion checks for, so the test verifies the mock rather than the code.
- A try/catch that swallows the one exception that would signal failure.
- An assertion inside a conditional or a loop that can execute zero times without the test failing.

When one of these appears, mentally break the implementation the test claims to cover and check whether the test would actually go red. If it wouldn't, that's a finding.

## Seam

Check where each new or changed test attaches, against `tdd`'s seam definition and anti-patterns. Flag a test that reaches into internals — private methods, mocked internal collaborators, a side channel like querying the database directly — rather than exercising the public interface the diff's spec (if one exists) agreed on.

## Independent source of truth

Check every expected value against `tdd`'s tautological anti-pattern: does the assertion come from a literal, a worked example, or the spec — or is it recomputed the way the code computes it. A diff that adds a helper function purely to generate a test's expected value is usually this anti-pattern wearing a disguise.

## Coverage of the cases that break

Happy-path coverage is not the review target — it's the case every implementation is built around, so it's the least likely to ship broken. Check the diff for:

- **Error paths** — what happens when a dependency fails, a validation rejects, or an operation the code performs can raise.
- **Empty and boundary inputs** — the empty list, the zero, the just-over-the-limit value, the missing optional field.
- **Screen states** — where the diff touches UI, cross-check against the screen's states as named in the effort's wireframes (see `ui-testing`'s coverage discipline). A screen with an error or empty state and no test for it is a gap.

A diff that only exercises the case the ticket described, with no test for what happens when an assumption fails, has not earned full marks on this axis regardless of how thorough the happy-path test is.

## Readability as specification

A test name should say what capability exists, in terms someone outside the diff could understand without reading the test body — `tdd`'s "user can checkout with valid cart" standard applies here too. A name that describes mechanics ("calls processPayment") or is generic ("works", "test 2") is a readability finding: the suite stops being able to answer "what does this system do" by itself.

## Coverage percentage is a weak signal

Do not use a coverage percentage, in the diff or in CI output, as evidence this axis passes. A percentage counts lines executed, not behavior verified — a suite full of the false-confidence tests described above can hit 100% while catching nothing, and a suite testing every error path and boundary on the code that matters can sit well below it. Look at what the tests actually assert and which cases they exercise instead; treat a percentage claim in a PR description as unverified until you've checked the tests behind it.

## Severity

Assign each finding a severity per `review`'s ladder. On this axis, high is a test that would not fail on a real regression to a path the code claims to guarantee — a tautological or implementation-coupled test standing in for real coverage. Critical is reserved for a gap in coverage that is itself the reason a data-loss or security defect could reach production undetected.
