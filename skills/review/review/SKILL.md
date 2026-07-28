---
name: review
description: Review the diff since a fixed point (commit, branch, tag, or merge-base) across independent axes — code, spec, test, security, migration. Each selected axis runs as its own parallel reviewer subagent and is reported separately, never merged into one verdict. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
---

# Review

Dispatch the diff to whichever review axes apply, run them as parallel `reviewer` subagents, and report each on its own terms. The axes are `code-review`, `spec-review`, `test-review`, `security-review`, `migration-review` — five independent skills, each carrying its own patterns and anti-patterns. This skill only decides which fire and hands each its brief; the judgement lives in the axis.

## Pin the fixed point

Whatever the user names is the fixed point — a commit, branch, tag, `main`, `HEAD~5`. If they didn't name one, ask.

Confirm it resolves (`git rev-parse <fixed-point>`) and that `git diff <fixed-point>...HEAD` is non-empty before going further. A bad ref or an empty diff fails here — cheap and local — rather than inside five parallel subagents where the failure is expensive to trace back.

Capture `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline` once; every axis brief reuses them.

## Select the axes

Run `code-review` and `test-review` always. Check the rest against the diff:

- **`spec-review`** — run it when a spec exists to hold the diff to: the commit trail names a ticket, `docs/planning/<effort>/spec.md` or `prd.md` exists for the matching effort, or the user supplies a spec path. Check the commit messages and the filesystem before deciding; if none of the three turn up anything, skip it rather than inventing a spec to check against.
- **`security-review`** — run it when the diff touches a security-relevant surface: authentication or authorization code, input parsing or deserialization, secrets or credentials, a dependency manifest or lockfile, or a network-facing boundary (routes, handlers, API definitions). Check `git diff --name-only` against those paths and grep the diff body for the keywords. Run it regardless of the diff if the user asks for a security pass explicitly.
- **`migration-review`** — run it when the diff touches a schema or data migration: files under a `migrations/` directory, a schema file (`schema.prisma`, `*.sql` under a migrate path), or an ORM model whose column or type changed. Check `git diff --name-only` against those paths.

State which axes you selected and why before dispatching — the user should be able to see the decision, not just its result.

## Dispatch

Send one message with one `Agent` call per selected axis, all using the `reviewer` subagent type. Build each brief per the `delegate` skill's contract:

- **Outcome** — findings for this axis against the diff, ranked by severity.
- **Skill** — the axis skill by name (`code-review`, `spec-review`, …); point the subagent at it rather than restating its process.
- **Inputs** — the diff command and commit list from the pin step, plus whatever that axis needs to locate its own reference (standards files, spec path, migration files) — the axis skill says what to look for.
- **Done** — every hunk in the diff accounted for under this axis's criteria.
- **Fence** — read-only, which `reviewer` already enforces; no edits, no scope beyond this one axis.
- **Report** — findings ranked by severity, each with where, what, and why it matters, plus a verdict for this axis alone.

The `reviewer` subagent is read-only by construction, which is what lets its findings be trusted as findings rather than quiet fixes made along the way.

## Aggregate

Report each axis under its own heading, in the order dispatched, findings as the subagent returned them. Do not merge or rerank across axes.

The axes are independent on purpose: a change can pass `code-review` while failing `spec-review`, or the reverse, and a merged list would let a clean axis bury a failing one under a wash of minor style notes. Keeping them apart is what makes a failing axis visible regardless of how the others read.

## Close with per-axis verdicts

End with one verdict per axis that ran — pass, or fail with its worst finding — never a single combined score. A reader who only wants to know whether the security pass is clean should get that answer without wading through style notes from `code-review`.
