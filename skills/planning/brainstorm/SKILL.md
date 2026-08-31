---
name: brainstorm
description: Shape a raw idea into a shared understanding, then carry it into planning documents. Use when the user opens with a new feature, product, or project idea whose boundaries are not yet settled, mentions wanting to think something through, or asks to brainstorm.
---

# Brainstorm

An idea has arrived **unshaped** — the user knows roughly what they want and why, but the boundaries, the actors, and the trade-offs are still open. Shaping it is the first act of planning, and everything downstream inherits its quality.

## Recognize

An idea is unshaped when you can restate its goal but cannot yet answer, from what the user said:

- Who it is for, and what they do differently once it exists
- Where it starts and stops
- What it deliberately leaves out

Work that already answers these is shaped, and shaping it again spends the user's time buying nothing. Say so and route it:

- **Shaped, and the size of a feature** — go to `to-prd`. What you are skipping is the interview, not the documents.
- **Shaped, and fits inside a single ticket** — go to `to-tickets`, or straight to `implement` where the ticket already exists. A PRD for a copy change is a PRD nobody will read.

Name the route before you take it and let the user redirect you.

## Shape it

Run the `grilling` skill together with the `domain-modeling` skill. `grilling` owns the interview; `domain-modeling` captures terms in `CONTEXT.md` and decisions in `docs/adr/` as they crystallize, so the shaping leaves a durable trace rather than living only in the transcript.

Look facts up in the environment — the codebase, the docs, the tracker. Put the **decisions** to the user.

The interview itself stays in this session. Looking a fact up is legwork and can go to an `Explore` agent; the interview cannot, because a subagent has nobody to interview.

## Carry it forward

The session is done shaping when no open questions remain **and the user has confirmed the shared understanding** — `grilling` holds that gate; do not step past it.

Once confirmed, continue in the same session: run the `to-prd` skill. A shaped idea whose understanding evaporates with the transcript has wasted the interview, so the handoff to a written document is part of this skill's work, not a separate errand the user must remember to ask for.
