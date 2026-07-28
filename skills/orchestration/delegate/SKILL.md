---
name: delegate
description: Hand execution to a subagent with a brief complete enough to work from cold. Use when a task is specified well enough to be carried out without the conversation that produced it, or when several independent pieces of work could run at once.
---

# Delegate

Execution goes to a subagent; the decisions stay here. A subagent starts **cold** — none of this conversation reaches it — and it cannot ask a question. Everything it needs travels in the **brief**, or it does not travel.

## Delegate what is settled

Send work whose decisions are already made and whose result can be checked: implementing an approved plan, applying a mechanical change across files, writing something to a template, verifying work against criteria.

Keep work whose value is in the deciding — design, trade-offs, anything the user must weigh in on, anything where you would be inventing the requirements as you go.

The test is the brief itself. **If you cannot write the brief, you do not understand the task well enough to delegate it** — and the effort of discovering that is the effort of doing the thinking that was missing. Write the brief first; if it comes out vague, that is the signal to go back to the user or the codebase, not to send it anyway and hope.

## Write the brief

Six things, every time. The first three make the work possible; the last three make it safe.

1. **Outcome** — what is true when this is done, stated as a result rather than a list of steps. Steps invite mechanical compliance; an outcome lets the agent recognize when its route was wrong.
2. **Skill** — which skill to run, by name. The skill carries the process, so pointing at it beats restating it and cannot drift from it.
3. **Inputs** — absolute paths to every file it needs, and the facts it cannot look up. A cold agent shares none of your context: what "the spec" refers to is obvious here and unrecoverable there.
4. **Done** — the completion criteria, checkable. Name the command that proves it where one exists.
5. **Fence** — what it must not touch. Bound the blast radius explicitly; silence reads as permission.
6. **Report** — the specific facts to return. The subagent's report reaches you and not the user, so whatever you fail to ask for is lost.

State explicitly that unsettled decisions come back rather than getting resolved locally. The agents carry this rule, and repeating it in the brief costs a line and removes the most expensive failure.

## Pick the agent

- **`implementer`** — writes. Runs a task to completion, with the tools to build and verify.
- **`reviewer`** — reads only. Checks work against criteria and reports findings, so it cannot quietly fix what it should be surfacing.
- **`Explore`** — finding things. Locating files, symbols, or usages across a codebase.

Independent briefs run at once. Where two pieces of work do not touch the same files and neither needs the other's result, dispatch them together.

## Verify what comes back

Read the diff, not just the report. A subagent's account of its own work is a claim, and a confident summary of a broken change looks exactly like a confident summary of a working one — run the check yourself before building on it.

Where the work matters and the criteria are explicit, send it to `reviewer` rather than reviewing it here. Where the report says blocked or raises a question, answer it and re-dispatch with the brief corrected, rather than finishing the work yourself — the gap that blocked it will block the next one too.

Relay what matters to the user in your own words. The report itself never reaches them.
