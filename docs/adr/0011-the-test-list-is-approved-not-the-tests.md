# The test list is approved, not the tests

Before the red-green loop runs, the developer may approve what will be tested. What they approve is a **list of behaviours** — one line each, at the seams the spec agreed — never a set of written tests.

Tests are the behaviour contract at its finest grain, so approving them is high leverage: a wrong test produces correct code implementing the wrong thing, and unwinding that after the implementation exists costs a ticket. Reviewing a list costs minutes. This is the same reasoning that puts gates on seams, phases, tickets and the merge — steer where steering is cheap.

## Why the list rather than the tests

Writing every test before any implementation is the **horizontal slicing** that the `tdd` skill names as an anti-pattern: it commits to a test structure before the implementation has taught anything, and the resulting tests verify an imagined shape rather than behaviour a user meets. The loop is deliberately vertical — one test, one implementation, each responding to what the last cycle revealed.

A full set of written tests is also not knowable up front. In a real loop, the third cycle's test comes from what the second cycle exposed. Approving a prediction of it would buy confidence in a guess.

A list of intended behaviours is legitimately knowable, does not constrain how the loop discovers the rest, and is far quicker to judge than a wall of test bodies. Cases the loop surfaces later are reported as they appear rather than being suppressed for sitting outside the approved list.

## Where the decision lives

The `implementer` is a cold subagent that cannot ask questions, so the approval cannot be requested from inside the loop. The existing stop-and-report mechanic carries it instead: the agent produces the list, reports, and ends; the orchestrator puts it to the developer and re-dispatches with the approved list. No new machinery, at the cost of one extra round trip per ticket while it is switched on.

Whether approval is wanted is a standing preference, recorded in the target repo's `CLAUDE.md` alongside the other per-project facts. Asking per ticket would make a control the developer wanted into a prompt they learn to dismiss.
