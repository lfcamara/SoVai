# CLAUDE.md

## Communication

When reporting information to me, be extremely concise and sacrifice grammar for sake of concision.

Conversation language: Portuguese (PT-BR/PT-PT as used by the user).

Written artifacts language: English — always, no exceptions. This includes docs, skills, agents, commit messages, code comments, READMEs, and any other file created in this repo.

## Orchestration

This session orchestrates; it does not execute. Delegate execution to subagents via the `delegate` skill — `implementer` to build, `reviewer` to check, `screen-verifier` to observe a screen running, `Explore` to find. Keep decisions, design, and anything needing the user here.

Subagents start cold and cannot ask questions, so every brief carries outcome, skill, absolute input paths, checkable done criteria, a scope fence, and what to report back.

The shipping copy of this mandate is the SessionStart bootstrap under `hooks/`, which is what reaches a consuming project — a plugin does not ship its CLAUDE.md (ADR-0012). That bootstrap does not necessarily load in a session working on this repo, which is why the mandate stays here too. The duplication is deliberate: edit both, and treat the bootstrap's wording as the one that ships.

## About this repo

`SoVai` is the name of this Claude Code plugin: a general-purpose engineering workflow harness, not tied to any single project.

- `skills/<block>/<name>/SKILL.md` — every skill, organized by workflow block. Each one must also be declared in the plugin manifest or it never loads.
- `agents/` — `implementer`, `reviewer`, `screen-verifier`.
- `hooks/` — the enforcement layer: SessionStart bootstrap, pre-edit gate, `Skill` phase tracker, Stop gate, plus the shared config resolver and the wiring that registers them. Paths there are plugin-relative via `${CLAUDE_PLUGIN_ROOT}`, and path classification comes from the edited project's own config, never from this plugin.
- `docs/adr/` — why each decision was made the way it was.

**Read `skills/productivity/writing-great-skills/SKILL.md` in full before you touch any `SKILL.md`.** The whole file, not a grep — a grep returns what you already suspected, and the defects this standard catches are the ones you did not: a branch whose trigger never reached the description, so the branch is unreachable; a rule steered by prohibition, which makes the banned behaviour more available; reference duplicated across files, so the meaning drifts. It is user-invoked, so no `Skill` call reaches it and it has to be read. A pre-edit hook now says the same at the moment of the edit ([ADR-0018](docs/adr/0018-skill-authoring-is-gated-by-filename.md)), because this instruction on its own has already failed once. After any structural change — a skill, agent, ADR, hook, or manifest edit, and any rename — run `bash skills/knowledge/lint-references/lint.sh` from the repo root and get CLEAN before finishing. Cross-references here are bare names in prose that nothing else validates, so a stale one reads live until that linter resolves it.

See [README.md](README.md) for the current skill inventory and roadmap.
