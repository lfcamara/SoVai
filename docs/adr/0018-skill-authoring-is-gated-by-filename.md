# Skill authoring is gated by filename, not by config

Editing a file named `SKILL.md` fires a pre-edit reminder to read `writing-great-skills` in full. The check runs before any other classification in `sovai-pre-edit-gate.sh` and consults no configuration at all.

## Why a gate rather than the instruction that already existed

The repo's `CLAUDE.md` already said to read the standard in full before authoring or editing a skill. It failed. A rework of the entire planning block — twelve commits, seven skills, six new reference files — was written after a targeted grep of the standard rather than a read of it, and the audit afterwards found a functional defect the standard would have caught on the first page: a skill given a second entrance whose trigger never reached its description, leaving that entrance unreachable from the cold session it exists to serve.

That is the failure ADR-0012 was written about. Prose in a file the agent has loaded is advice; a hook that fires at the moment of the action is a mechanism. The instruction stays — sharpened, and naming the specific defects it prevents — but it is no longer the only thing standing there.

## Why the filename, and not the path classification

Every other branch of this hook resolves the edited file through the project's `sovai.config.json`, and exits silently when there is none (ADR-0013). Applying that here would break the gate in the one place it matters most: **SoVai's own repo has no `sovai.config.json`**, having no production logic of its own to gate, so a config-driven check would fire in consuming projects and never in the repo where skills are actually authored.

A file named `SKILL.md` means a skill is being authored. That is true in any project, needs nothing declared, and cannot be got wrong. So the check sits above the config lookup and keys off the basename alone.

## Why it reminds rather than blocks

A hook cannot verify that a file was read. It can only observe the edit that follows, and refusing every edit to a `SKILL.md` until some unobservable precondition holds would block the work it is trying to improve — the failure mode ADR-0013 calls out, where a gate that breaks a session gets uninstalled and takes every rule it carried with it.

It fires once per session, on the first `SKILL.md` edit, like the other branches. A reminder repeated on every edit is a reminder that gets skimmed.

A Stop-gate analogue was once possible and deliberately not built. It is now not possible at all: the TDD Stop gate that would have been its model was removed on 2026-09-04 for a reason that applies here identically — a Stop hook's every output reaches the model rather than the user, and the model holds Bash, so any clearing condition it sets is writable by the party being gated ([ADR-0012](0012-the-plugin-ships-an-enforcement-layer.md), amended). The reminder is cheap and lands at the right moment, and it was always the load-bearing half.

## Why not make the standard model-invocable instead

Removing `disable-model-invocation: true` from `writing-great-skills` would let the `Skill` tool reach it and put it under the bootstrap's mandatory-invocation contract. Rejected: its description would then load in every session of every consuming project, a permanent context cost for a rule that only applies while authoring a skill — which most consuming projects never do. The skill's own guidance is to pick model-invocation only when the agent must reach the skill on its own, and the hook gives it that reach at the moment it is needed, for nothing.
