# The test list is approved, not the tests

Before the red-green loop runs, the developer may approve what will be tested. What they approve is a **list of behaviours** — one line each, at the seams the spec agreed — never a set of written tests.

Tests are the behaviour contract at its finest grain, so approving them is high leverage: a wrong test produces correct code implementing the wrong thing, and unwinding that after the implementation exists costs a ticket. Reviewing a list costs minutes. This is the same reasoning that puts gates on seams, phases, tickets and the merge — steer where steering is cheap.

## Why the list rather than the tests

Writing every test before any implementation is the **horizontal slicing** that the `tdd` skill names as an anti-pattern: it commits to a test structure before the implementation has taught anything, and the resulting tests verify an imagined shape rather than behaviour a user meets. The loop is deliberately vertical — one test, one implementation, each responding to what the last cycle revealed.

A full set of written tests is also not knowable up front. In a real loop, the third cycle's test comes from what the second cycle exposed. Approving a prediction of it would buy confidence in a guess.

A list of intended behaviours is legitimately knowable, does not constrain how the loop discovers the rest, and is far quicker to judge than a wall of test bodies. Cases the loop surfaces later are reported as they appear rather than being suppressed for sitting outside the approved list.

## Where the decision lives

The `implementer` is a cold subagent that cannot ask questions, so the approval cannot be requested from inside the loop. The existing stop-and-report mechanic carries it instead: the agent produces the list, reports, and ends; the orchestrator puts it to the developer and re-dispatches with the approved list. No new machinery, at the cost of one extra round trip per ticket while it is switched on.

## The default is to start the loop

Approval happens where the developer asks for it on the ticket in front of them, and every other ticket goes straight into the red-green loop. There is no standing answer and no per-ticket question: a question asked every time becomes a prompt to dismiss, and a question asked once becomes a line in a config file that nobody revisits when the answer changes. Where the developer does ask, `to-tickets` carries it into that ticket's brief and the implementer stops on the list.

What this costs is stated plainly: a list the developer would have wanted goes unasked-for, and those tests are written without their eyes on them first. That is the trade — this gate stood in front of some tickets, where the spec's agreed seams, the six review axes, and the merge approval stand behind all of them.
