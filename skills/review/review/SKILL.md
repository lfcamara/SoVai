---
name: review
description: Review the diff since a fixed point across independent axes — code, spec, test, security, migration. Use when the user wants a branch, a PR, or work-in-progress changes reviewed, asks to "review since X", or when another skill needs a change checked before it lands.
---

# Review

Dispatch the diff to whichever review axes apply, run them as parallel `reviewer` subagents, and report each on its own terms. The axes are `code-review`, `spec-review`, `test-review`, `security-review`, `migration-review` — five independent skills, each carrying its own patterns and anti-patterns. This skill only decides which fire and hands each its brief; the judgement lives in the axis.

## Pin the fixed point

Whatever the user names is the fixed point — a commit, branch, tag, `main`, `HEAD~5`.

Reviewing a ticket's branch, the process already knows it: the phase branch that ticket was cut from, `phase/<effort>-<NN>`. Resolve it and say which you used. Asking there puts a question to the user that the branch itself answers, and `...` already excludes whatever the phase branch gained meanwhile. Ask only when the review is of something else and the user named nothing.

Confirm it resolves (`git rev-parse <fixed-point>`) and that `git diff <fixed-point>...HEAD` is non-empty before going further. A bad ref or an empty diff fails here — cheap and local — rather than inside five parallel subagents where the failure is expensive to trace back.

Capture `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline` once; every axis brief reuses them.

## Select the axes

Run `code-review` and `test-review` always. Check the rest against the diff:

- **`spec-review`** — run it when a spec exists to hold the diff to: the commit trail names a ticket, a `<effort> — Phase <N> Spec.md` or `<effort> — PRD.md` exists under `docs/planning/<effort>/` for the matching effort, or the user supplies a spec path. Check the commit messages and the filesystem before deciding; if none of the three turn up anything, skip it rather than inventing a spec to check against.
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

`code-review` carries a second marker beside severity: **owed**, for the structural cleanup the `tdd` loop deliberately postponed to it. An owed finding is fixed before the work merges whatever its severity, because that debt was created by the process rather than found by accident. Carry the marker through aggregation exactly as the axis assigned it.

## Dispatch

Send one message with one `Agent` call per selected axis, all using the `reviewer` subagent type. Build each brief per the `delegate` skill's contract:

- **Outcome** — findings for this axis against the diff, each assigned a severity per the Severity section above, ranked by severity.
- **Skill** — the axis skill by name (`code-review`, `spec-review`, …); point the subagent at it rather than restating its process.
- **Inputs** — the diff command and commit list from the pin step, plus the paths this axis needs. Where selecting the axis already turned up its reference — the spec you found deciding whether `spec-review` runs, the migration files you matched for `migration-review` — pass those paths rather than making the agent search for what you have already located. `spec-review` needs the ticket as well as the spec, with its text where the agent cannot reach the tracker itself: the ticket's acceptance criteria are what scope is checked against.
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

Write a durable record of this review to the shape in [REVIEW-RECORD-FORMAT.md](./REVIEW-RECORD-FORMAT.md), at `docs/reviews/<YYYY-MM-DD> — <ticket or branch>.md`.

The record isn't archival. It is the input to skill hardening later, which works only if every finding also carries why it wasn't prevented — the cause from the step above — and it is what `wrap-up` reads to decide whether anything still blocks the merge.

## What happens next

**critical and high findings are always fixed**, and so is **every finding marked owed** — not proposed, not discussed. The first two are defects; the third is the refactor `tdd` postponed, and leaving it is how "relocated, not deleted" quietly becomes deleted.

**medium and low findings are fixed only when the user says so**, owed ones aside. Present them alongside the resolution and wait — fixing a medium the user never asked for spends their time without asking.

## Dispatch the fix run

The fixes are a fresh `implementer` run, because this skill and every agent it dispatches are read-only so that findings stay findings, and because the run that wrote the code ended when it reported.

Move the ticket back to **Doing** and dispatch one brief per the `delegate` contract:

- **Inputs** — the findings to fix, quoted as the axis wrote them, plus the path to the review record. The ticket's worktree and branch are still on disk — `wrap-up` retires them only after the merge — so the brief names that worktree and the work continues where it stopped.
- **Skill** — `tdd` for anything that changes behaviour, since a fix to a real defect starts at a red test that reproduces it. An owed refactor changes no behaviour and needs no new test: it runs against the suite already green, which is the whole reason the cleanup was moved here.
- **Fence** — the findings named and nothing else. A fix run that also tidies what nobody flagged is the uninvited diff `delegate` warns about, arriving at the least reviewable moment.
- **Done** — each finding resolved, and lint, build and tests green afterward.

Then re-review: the axes that raised those findings, plus any axis whose selection criteria the fix diff newly matches — a fix that touches a migration file gets `migration-review` whether or not it ran the first time. Move the ticket back to Testing as you dispatch it. Findings raised on a fix run are handled exactly like the first round, with no cap on rounds: the loop ends when a review comes back with nothing that must be fixed.

## Take the PR out of draft

Once the loop ends, mark the PR ready with `gh pr ready`. `open-pr` opened it as a draft to say the diff was not asking for a merge decision yet; this is the moment that stops being true, and this skill is the only thing that knows it — the implementer that opened the PR ended its run before any review existed, and `wrap-up` reads the draft state as a precondition rather than setting it.

Ready is not approval. It says the reviews are done and the diff is now asking; the user still decides, and `wrap-up` still asks. A PR sitting in draft when `wrap-up` runs means this loop never finished, which is exactly what that precondition is for.

Then the work is ready for the user to approve, and `wrap-up` merges it on that approval. Reviews passing is what makes the PR reviewable, never what authorizes the merge.
