---
name: review
description: Review the diff since a fixed point across independent axes — code, spec, test, security, migration. Use when the user wants a branch, a PR, or work-in-progress changes reviewed, asks to "review since X", or when another skill needs a change checked before it lands.
---

# Review

Dispatch the diff to whichever review axes apply, run them as parallel `reviewer` subagents, and report each on its own terms. The axes are `code-review`, `spec-review`, `test-review`, `security-review`, `migration-review` — five independent skills, each carrying its own patterns and anti-patterns. This skill only decides which fire and hands each its brief; the judgement lives in the axis.

## Pin the fixed point

Whatever the user names is the fixed point — a commit, branch, tag, `main`, `HEAD~5`. If they didn't name one, ask.

Confirm it resolves (`git rev-parse <fixed-point>`) and that `git diff <fixed-point>...HEAD` is non-empty before going further. A bad ref or an empty diff fails here — cheap and local — rather than inside five parallel subagents where the failure is expensive to trace back.

Capture `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline` once; every axis brief reuses them.

## Select the axes

Run `code-review` and `test-review` always. Check the rest against the diff:

- **`spec-review`** — run it when a spec exists to hold the diff to: the commit trail names a ticket, `docs/planning/<effort>/<effort> — Spec.md` or `<effort> — PRD.md` exists for the matching effort, or the user supplies a spec path. Check the commit messages and the filesystem before deciding; if none of the three turn up anything, skip it rather than inventing a spec to check against.
- **`security-review`** — run it when the diff touches a security-relevant surface: authentication or authorization code, input parsing or deserialization, secrets or credentials, a dependency manifest or lockfile, or a network-facing boundary (routes, handlers, API definitions). Check `git diff --name-only` against those paths and grep the diff body for the keywords. Run it regardless of the diff if the user asks for a security pass explicitly.
- **`migration-review`** — run it when the diff touches a schema or data migration: files under a `migrations/` directory, a schema file (`schema.prisma`, `*.sql` under a migrate path), or an ORM model whose column or type changed. Check `git diff --name-only` against those paths.

State which axes you selected and why before dispatching — the user should be able to see the decision, not just its result.

## Severity

Every finding carries one of four severities, assigned by the axis that found it — severity depends on what that axis knows about the diff, which the dispatcher aggregating five reports afterward cannot re-derive.

- **critical** — will cause data loss, a security breach, or a broken production path.
- **high** — will cause incorrect behaviour a user meets, or defeats a guarantee the code claims to provide.
- **medium** — a real defect with a bounded blast radius, or a standard breach that will cost later.
- **low** — worth fixing, costs little if it isn't.

The boundary that matters most sits between high and medium: it's where a fix stops being optional (see "What happens next"). Each axis names, in one sentence, what typically reaches critical or high in its own domain — the same word means something different to a migration reviewer than to a test reviewer.

## Dispatch

Send one message with one `Agent` call per selected axis, all using the `reviewer` subagent type. Build each brief per the `delegate` skill's contract:

- **Outcome** — findings for this axis against the diff, each assigned a severity per the Severity section above, ranked by severity.
- **Skill** — the axis skill by name (`code-review`, `spec-review`, …); point the subagent at it rather than restating its process.
- **Inputs** — the diff command and commit list from the pin step, plus the paths this axis needs. Where selecting the axis already turned up its reference — the spec you found deciding whether `spec-review` runs, the migration files you matched for `migration-review` — pass those paths rather than making the agent search for what you have already located.
- **Done** — every hunk in the diff accounted for under this axis's criteria.
- **Fence** — read-only, which `reviewer` already enforces; no edits, no scope beyond this one axis.
- **Report** — a verdict for this axis alone. The `reviewer` agent already carries the shape findings come back in; the brief only names what is specific to this axis.

The `reviewer` subagent is read-only by construction, which is what lets its findings be trusted as findings rather than quiet fixes made along the way.

## Aggregate

Report each axis under its own heading, in the order dispatched, findings as the subagent returned them. Do not merge or rerank across axes.

The axes are independent on purpose: a change can pass `code-review` while failing `spec-review`, or the reverse, and a merged list would let a clean axis bury a failing one under a wash of minor style notes. Keeping them apart is what makes a failing axis visible regardless of how the others read.

## Close with per-axis verdicts

End with one verdict per axis that ran — pass, or fail with its worst finding — never a single combined score. A reader who only wants to know whether the security pass is clean should get that answer without wading through style notes from `code-review`.

## Diagnose cause

For every finding that reached review, ask why it wasn't prevented earlier, and record a short cause beside it. A finding is a defect caught; a cause that repeats across reviews is a hole in the process — but only if it's written in a form a later review can match against. Name the gap ("the spec never said which seam", "no rule in code-review covers this"), not the person or the moment ("missed it", "rushed") — those can't be matched against next time's finding.

One occurrence is not a pattern. Record the cause and move on; whether it recurs, and whether a skill needs hardening for it, is a judgement for a later pass over the accumulated records, not one this review makes off a single data point.

## Write the review record

Write a durable record of this review into the project's Obsidian vault, at `docs/reviews/<YYYY-MM-DD> — <ticket or branch>.md`. Documents in this vault are Obsidian notes — link the ticket with a wikilink (`[[checkout-flow — Spec]]`), not a relative markdown link.

The record isn't archival. It's the input to skill hardening later, which only works if every finding also carries why it wasn't prevented — the cause from the step above.

```markdown
# Review: <ticket or branch> — <YYYY-MM-DD>

Fixed point: <ref>
Ticket: [[<ticket>]]

## Axes run
- <axis>: <why it was selected>

## Findings
### <axis> — <severity>
<where, what, why it matters>
Cause: <why this wasn't prevented earlier>

## Resolution
- Fixed: <critical/high findings resolved before merge>
- Deferred: <medium/low findings the user chose to leave, or "none raised">
```

## What happens next

**critical and high findings are always fixed** — not proposed, not discussed. Send them back to the ticket's `implementer` as a fresh brief naming the findings; this skill and the agents it dispatches are read-only so that findings stay findings.

**medium and low findings are fixed only when the user says so.** Present them alongside the resolution and wait — fixing a medium the user never asked for spends their time without asking.

Once every critical and high finding is resolved and re-reviewed, the work is ready for the user to approve, and `wrap-up` merges it on that approval. Reviews passing is what makes the PR reviewable, never what authorizes the merge.
