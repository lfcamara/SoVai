---
name: verify-before-claiming
description: Evidence before the claim — run the check and show its output before calling work done, fixed, passing, or working. Use before committing, before opening a PR, and before reporting any outcome to the user or the orchestrator.
---

# Verify Before Claiming

Run the check that would contradict the claim, then show what it said. That output is the **evidence**, and the evidence is what makes it a claim; without it there is a belief worded like a fact. This binds every done, fixed, passing, working, or complete — in a report, a commit message, a PR body, a sentence to the user — and it binds a subagent exactly as it binds the orchestrator.

## Run the check

Name the claim, then run the thing that settles it:

- "tests pass" → run the suite; show the summary line and how many were skipped. Silent skips are not green.
- "it builds", "lint is clean" → run build and lint; show what came back.
- "the bug is fixed" → run the reproduction that went red; show it now goes green.
- "the feature works" → exercise it end to end; say what you observed happen.

Evidence is a real run, this session, against the change as it now stands. A run from before the last edit, a remembered result, and a confident "should pass" are the same thing: no evidence.

## Where nothing automated exists

Some claims have no command behind them. State how you verified — what you read, ran by hand, or watched happen — and then state **what you could not verify**. A named gap is usable, because the reader knows where to look; the same claim delivered with full confidence sends them nowhere, since nothing in it says anyone should check.

## Report a failure as a failure

A check that fails is reported as failing, with the output it produced. The failing lines are the most useful thing you can hand back — a reader who has them can act, where a reader given "mostly passing" has nothing. Say which parts ran, which failed, and which never ran at all.

Where a subagent boundary compresses the log — `implement` carries the verdict and failing lines forward, not the raw output — what crosses is still the command, its result, and the lines that failed.

## Done means checked

An `implementer` reports done once the brief's completion criteria are met **and it has checked each one against a run**, rather than once the editing is finished. Building the thing and verifying the thing are two acts, and only the second licenses the word.
