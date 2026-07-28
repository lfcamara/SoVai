---
name: diagnose
description: Diagnose a hard bug or performance regression down to a confirmed root cause and a filed bug ticket — no fix included. Use when the user reports something broken, throwing, failing, slow, or asks to debug or diagnose an issue.
---

# Diagnose

A discipline for hard bugs, ending at a **ticket**, not a fix. Diagnosis and fix are different kinds of work — one finds the truth, the other changes the code — and routing the fix through the normal pipeline (`implement` with TDD, then `review`, then `wrap-up`) keeps one path for all code instead of a side channel that skips review. A bug ticket also makes the diagnosis durable: without it, the root cause lives only in this session's context and is gone once it ends.

When exploring the codebase, read `CONTEXT.md` (if it exists) for the domain vocabulary and check ADRs in the area you're touching.

## Get the evidence

Before anything else, obtain concrete evidence of the bug. Prefer getting it yourself over relying on the user's report — a reported symptom is a secondhand account, and going to the source (reading the database, driving the browser, reading logs or traces) often surfaces something the report left out. Where you cannot reach the source yourself, ask the user for it: the exact error, a screenshot, a log excerpt, the request that triggered it.

Move on once you have something concrete enough to check a fix against later — not a description of the bug, an instance of it.

## Build the feedback loop

**This is the skill.** Everything else is mechanical. A **tight** pass/fail signal that goes red on this bug will find the cause; bisection, hypothesis-testing, and instrumentation only consume it. No amount of reading code substitutes for it.

Spend disproportionate effort here. Be aggressive. Be creative. Refuse to give up.

### Ways to construct one — try roughly in this order

1. **Failing test** at whatever seam reaches the bug — unit, integration, e2e.
2. **Curl / HTTP script** against a running dev server.
3. **CLI invocation** with a fixture input, diffing stdout against a known-good snapshot.
4. **Headless browser script** — drives the UI, asserts on DOM/console/network.
5. **Replay a captured trace** — save a real request, payload, or event log to disk and replay it through the code path in isolation.
6. **Throwaway harness** — a minimal subset of the system exercising the bug path with a single function call.
7. **Property / fuzz loop** — for "sometimes wrong output", run many random inputs and look for the failure mode.
8. **Bisection harness** — if the bug appeared between two known states, automate "boot at state X, check, repeat" so it can run under `git bisect run`.
9. **Differential loop** — run the same input through old vs. new (or two configs) and diff the outputs.
10. **HITL loop** — last resort, when a human must click something. Drive them with `scripts/hitl-loop.template.sh` so the loop stays structured; captured output feeds back to you.

### Tighten the loop

Treat the loop as a product once you have one. Make it faster (cache setup, skip unrelated init, narrow scope), make the signal sharper (assert on the specific symptom, not "didn't crash"), make it more deterministic (pin time, seed RNG, isolate the filesystem, freeze network). A 30-second flaky loop is barely better than no loop; a 2-second deterministic one is a debugging superpower.

### Non-deterministic bugs

The goal is a higher reproduction rate, not a clean repro. Loop the trigger many times, parallelise, add stress, narrow timing windows, inject sleeps. A 50%-flake bug is debuggable; 1% is not — keep raising the rate until it is.

### When you genuinely cannot build a loop

Stop and say so explicitly, with what you tried. Ask the user for access to whatever environment reproduces it, a captured artifact (HAR file, log dump, core dump, timestamped recording), or permission to add temporary instrumentation. Do not proceed to hypothesise without a loop.

### Completion criterion

Done when you can name **one command** — a script path, a test invocation, a curl — that you have **already run at least once** (paste the invocation and its output), and that is:

- **Red-capable** — drives the actual bug code path and asserts the user's exact symptom, not "runs without erroring".
- **Deterministic** — same verdict every run (non-deterministic bugs: a pinned, high reproduction rate).
- **Fast** — seconds, not minutes.
- **Agent-runnable** — runs unattended; a human enters only via the HITL script.

Reaching for a hypothesis before this command exists is the exact failure this skill prevents.

## Reproduce and minimise

Run the loop and watch it go red. Confirm the failure is the one the **user** described, not a different one that happens to be nearby — the wrong bug produces the wrong fix. Capture the exact symptom (error message, wrong output, timing) so later steps can verify it's actually gone.

Then shrink the repro to the smallest scenario that still goes red: cut inputs, callers, config, data, and steps one at a time, re-running the loop after each cut. A minimal repro shrinks the hypothesis space below and becomes the reproduction the ticket carries forward. Done when every remaining element is load-bearing — removing any one of them turns the loop green.

## Hypothesise

Generate 3–5 ranked hypotheses before testing any of them — testing the first plausible idea anchors on it and buries better explanations.

Each hypothesis must be falsifiable, stated as a prediction: "If `<X>` is the cause, then `<changing Y>` will make the bug disappear / `<changing Z>` will make it worse." A hypothesis with no prediction is a vibe — discard or sharpen it.

Show the ranked list to the user before testing. Domain knowledge often re-ranks it instantly ("we just deployed a change to #3") or rules a hypothesis out entirely. Don't block on it if the user is unavailable — proceed with your own ranking.

## Test the hypotheses in parallel

Dispatch the ranked hypotheses as parallel subagents, one hypothesis per agent, each returning a verdict on its own hypothesis alone. Hypotheses are independent by construction — nothing in testing #2 depends on the outcome of #1 — so running them in parallel is strictly faster than sequentially, and it avoids an agent that tests several in one pass anchoring on whichever it tried first.

Build each brief per the `delegate` skill's contract. Use `reviewer` when a hypothesis can be settled by reading and running checks against the loop from the step above; use `implementer` when settling it requires adding instrumentation first, since a read-only agent cannot write a probe. Each brief carries: the hypothesis and its prediction, the minimised repro and the one command that runs it, and instructions to report only a verdict on that single hypothesis — confirmed, refuted, or inconclusive, with evidence.

Where a hypothesis needs instrumentation, keep the source's discipline regardless of which agent adds it: change one variable at a time, prefer a debugger or REPL over logs, never "log everything and grep". Tag every debug log with a unique prefix (`[DEBUG-a4f2]`) so cleanup before the ticket is filed is a single grep.

For a performance regression, logs are usually the wrong tool: establish a baseline measurement (timing harness, profiler, query plan) and bisect against it instead. Measure first.

Collect the verdicts. One hypothesis confirmed with evidence is the root cause; if none confirm, or more than one does, return to the codebase with what the failed tests ruled out and generate a fresh round.

## Open the bug ticket

Diagnosis ends here — filing the ticket, not fixing the bug. Follow `to-tickets` for tracker mechanics, publish location, and the ticket template; this step only says what a bug ticket must carry beyond the standard fields, so the implementer who eventually picks it up inherits the diagnosis instead of re-deriving it:

- The evidence gathered in the first step.
- The one command that reproduces the bug, and its output.
- The minimised repro.
- The confirmed root cause and which hypothesis proved it, with the evidence from that agent's verdict.
- The **correct seam** for a regression test: a seam that exercises the real bug pattern as it occurs at the call site. If the only available seam is too shallow — a single-caller test when the bug needs multiple callers, a unit test that can't replicate the chain that triggered it — say so; a test at that seam would give false confidence. If no correct seam exists at all, that absence is itself a finding, and the ticket should say why (architecture preventing the bug from being locked down) so `implement` doesn't have to rediscover it.
- What would have prevented this bug — a missing test seam, tangled callers, hidden coupling. Answer this after the diagnosis is confirmed, not before; you have more information now than when you started.

Before filing, remove every `[DEBUG-...]` log (`grep` the prefix to confirm none remain) and delete any throwaway harness built to construct the loop, or move it somewhere clearly marked if it has lasting value. The loop that reproduces the bug should survive in the ticket as a command, not as leftover scaffolding in the working tree.
