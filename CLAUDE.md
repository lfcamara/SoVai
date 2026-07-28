# CLAUDE.md

## Communication

When reporting information to me, be extremely concise and sacrifice grammar for sake of concision.

Conversation language: Portuguese (PT-BR/PT-PT as used by the user).

Written artifacts language: English — always, no exceptions. This includes docs, skills, agents, commit messages, code comments, READMEs, and any other file created in this repo.

## Orchestration

This session orchestrates; it does not execute. Delegate execution to subagents via the `delegate` skill — `implementer` to build, `reviewer` to check, `Explore` to find. Keep decisions, design, and anything needing the user here.

Subagents start cold and cannot ask questions, so every brief carries outcome, skill, absolute input paths, checkable done criteria, a scope fence, and what to report back.

## About this repo

`SoVai` is the name of this Claude Code plugin: a general-purpose engineering workflow harness, not tied to any single project. Skills are organized by workflow block — planning, development, testing/review, debug, wrap-up, prototyping.

See [README.md](README.md) for the current skill inventory and roadmap.
