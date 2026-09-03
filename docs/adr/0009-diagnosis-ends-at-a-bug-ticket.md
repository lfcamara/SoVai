# Diagnosis ends at a bug ticket, not at a fix

**A sixth axis existed between 2026-07-30 and 2026-09-03 ([ADR-0015](0015-review-has-a-goal-axis.md), since reversed).** "The five axes" below is again the count; nothing else about this decision changed — a bug ticket still enters the normal flow and is still reviewed by every axis that applies.

The debug block diagnoses a bug and files a ticket. Fixing it is not part of it — the ticket enters the normal flow, implemented under TDD, reviewed across the five axes, landed by wrap-up.

This adapts the upstream `diagnosing-bugs` skill from mattpocock/skills, which runs through the fix and its regression test. Stopping earlier buys two things. Every line of production code then reaches main by one path, rather than fixes taking a shortcut that skips the review axes precisely when the code is being changed under time pressure. And the diagnosis becomes durable: root cause, reproduction command and minimised repro survive on the ticket instead of dying with the session that produced them, which matters because the fix is often not written by the session that found the cause.

The content that made the upstream fix phases valuable is relocated rather than dropped. The correct-seam analysis — whether a seam exists that exercises the real bug pattern at the call site, and the finding that none does when that is the case — travels on the ticket, so the implementer inherits it instead of rediscovering it. Removing tagged instrumentation still closes the diagnosis. The "what would have prevented this" question is still asked, and its answer rides on the ticket.

## Evidence comes before the loop

The upstream skill opens by building a feedback loop. Ours opens by obtaining evidence — from the user, or by going to the database, the browser, the logs. A reported symptom is a secondhand account, and going to the source routinely shows something the report omitted. Building a loop against a misdescribed symptom produces a loop that goes red on the wrong thing.

The feedback loop itself is kept intact and remains the core of the skill: a tight, red-capable, deterministic signal is what finds a bug, and reaching for a hypothesis before that command exists is the failure the discipline prevents.

## Hypotheses are tested in parallel

Where the upstream instruments hypotheses sequentially, ours dispatches them as parallel subagents, one hypothesis per agent, each returning a verdict on its own. Hypotheses are independent by construction, and a single agent working through them in order anchors on whichever it tried first — the same anchoring the skill already guards against by requiring three to five hypotheses before any is tested.
