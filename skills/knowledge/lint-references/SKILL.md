---
name: lint-references
description: Check that this plugin's own cross-references resolve — bare skill and agent names, plugin.json skill paths, relative links, hook wiring. Use after editing or renaming any skill, agent, ADR, or hook in this repo, before cutting a release, or when the user asks whether the plugin is internally consistent.
---

# Lint References

This plugin's cross-references are **bare names in backticks** — `review` naming six axes, `wrap-up` naming `to-tickets`, an ADR citing an agent. Nothing reads them back: not the filesystem, not Claude Code, not any other tool. A rename leaves the old name sitting in prose, reading exactly as live as the day it worked. This is what reads them back.

## Run it

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/knowledge/lint-references/lint.sh"
```

With `CLAUDE_PLUGIN_ROOT` unset — a plain shell rather than a plugin session — run it by absolute path instead; the script walks up from itself to find the plugin root.

## What it checks

- **Bare skill and agent names** in backticks, across every `skills/**/*.md`, `agents/*.md` and `docs/adr/*.md`, plus `CLAUDE.md`, `CONTEXT.md`, `README.md` and `engineering-workflow.md`. A token counts as a name when it is kebab-case with no dot, slash or space; a single word counts only when its line also says "skill" or "agent", without which every backticked English word reports as dead. Fenced code blocks are skipped whole — they hold commands, not references.
- **`plugin.json` skill paths** — every declared entry is a directory holding a `SKILL.md`.
- **Undeclared skills** — every `SKILL.md` on disk appears in `plugin.json`. One that does not is never loaded, and nothing else in the repo says so.
- **Relative markdown links** resolve on disk. External URLs and `[[wikilinks]]` are skipped: a wikilink addresses a note in a project's vault, which does not exist from here.
- **Hook script paths** wired in `hooks/hooks.json`, when that file exists.

## Read the exit code

- **0, and CLEAN** — every reference resolved.
- **1, and a MISSING list** — each line carries the dangling reference plus the file and line that named it. For each one: either the target moved and the reference follows it, or the reference is stale and comes out. A name that was never ours to resolve — a skill the environment supplies, an alternative an ADR rejected — belongs in the allowlist at the top of `lint.sh`, with the reason it is exempt.
- **2, and an error** — the plugin root misresolved and nothing was scanned. Fix the root; a run that scanned nothing is never clean.

## What it does not check

- **Frontmatter semantics** — whether a `description` carries usable triggers, whether a name matches its directory, whether `disable-model-invocation` is the right call. This resolves references; `writing-great-skills` judges skills.
- **A real name written without backticks.** Backticks are the convention here, and a reference written as bare prose is invisible to this.
- **Whether a resolved reference is the right one.** A skill pointing at a real but wrong target passes.
- **Hook script bodies** — only the paths `hooks.json` wires up, not what those scripts reach for in turn.

## When to run

- After editing a skill, agent, ADR, or hook.
- After renaming or moving anything in the plugin tree — the move that produces dead references silently.
- Before a release, and periodically as a health check.
