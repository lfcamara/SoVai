---
name: harden
description: Harden a skill, review axis, agent definition, or gate against a defect that keeps recurring across review records. Use when the user asks to harden the plugin, mentions recurring or repeated review findings, wants a skill updated based on what keeps failing review, or is due for periodic maintenance on the review-to-skill feedback loop — never off a single review's findings.
---

# Harden

Runs in this repo — the SoVai plugin — because this is where the skills, review axes, agent definitions, and gates it amends live. Reads `docs/reviews/` from one or more project repos, whose paths the user supplies: the vaults hold the review records, the plugin holds what gets changed.

## Confirm the run is worthwhile

One occurrence is not a pattern. Amending a skill off a single finding adds a rule the next reader cannot judge — they see one instance and no way to tell it from noise. This skill runs periodically, never per review.

Read `LEDGER.md` in this skill's folder for the date of the last run (none yet on a first run). Count review records with findings, across every supplied vault, dated after it. Below roughly ten new records, recurrence has nowhere to show — report the count and say when the next run would have enough, and stop. This is a floor, not a target: more records make every count below it sharper.

## Gather the vaults

Ask the user for each project's `docs/` root if not already supplied — this crosses repositories on purpose. A cause that shows up once in each of three projects is invisible from inside any single one of them; only reading across all three surfaces it at all.

Read every `docs/reviews/<YYYY-MM-DD> — <ticket or branch>.md` newer than the last run, in every supplied vault. Each finding already carries a **severity** (critical, high, medium, low) and a recorded **cause** — read `review`'s convention as-is, don't re-derive it.

## Group by cause, not symptom

Cluster findings by their recorded cause, matched on meaning, not string — two findings can read as unrelated bugs and still share one hole in the process (an SQL-injection finding and a path-traversal finding both tracing to "no rule requires input validation at the boundary"). Grouping by symptom instead of cause hides exactly the pattern this skill exists to find.

Within each cluster, weight by severity: a cause behind two critical findings has earned an amendment; a cause behind five low findings may not have yet. Rank clusters by that weight, not by raw count — recurrence at low severity is weaker evidence than recurrence at high severity, and the ranking should say so before the next step spends effort on it.

## Find the owner

A recurring cause points at exactly one owner — pick it with this test: **what single artifact, present at the moment the defect was introduced, would have stopped it?**

- A rule was missing from a review axis's criteria → that axis skill (`code-review`, `spec-review`, `test-review`, `security-review`, `migration-review`, `goal-review`).
- A skill's completion criterion was loose enough to let the defect pass as done → that skill.
- An agent definition permitted an action it should have fenced off → that agent definition.
- Nothing was watching an action a **gate** could have refused → the hook that should have fired, under `hooks/`. Where the gate exists and stayed silent because the project's own config classified the path wrong, the owner is that config, in the project's repo rather than this one.

Choosing wrong spreads a rule across files that don't need it and leaves the one that does still exposed. If a cluster's evidence doesn't point cleanly at one owner, report that as its own finding rather than forcing a guess.

## Draft the amendment, sharpened rather than appended

Read the owner file in full before writing anything. Where an existing rule is close — covers the class of defect but is too loose, too narrow, or silent on this specific case — rewrite that rule to close the gap. Adding a new rule beside a near-right one is how a skill accumulates **sediment**, the exact failure `writing-great-skills` names: safe to add, risky to remove, and the thing that let the original rule stay too weak to catch this in the first place.

Add a genuinely new rule only when nothing existing is close. Either way, hold the result to `writing-great-skills` in full: a checkable completion criterion where it binds a step, positive phrasing over prohibition, and no restatement of what `review`, `diagnose`, or the owner file's own content already covers elsewhere.

Where the owner is a **gate**, the amendment is a change to a shell script rather than to prose, and the one property it must preserve is failing open: a hook that breaks a session over its own configuration gets uninstalled, taking every rule it carried with it.

## Propose, don't apply

Show the user, per cluster: the recurring cause, its severity weight, the review records it came from (path and date), the owner chosen and why, and the amendment as a diff against the current file. Wait for their decision on each before touching anything.

A skill amendment changes how every future run of that skill behaves — too consequential to land from a pattern the user has not seen. Apply only what they approve, editing the owner file directly.

## Close the loop

Append a dated entry to `LEDGER.md` — vaults scanned, review records considered, every cluster found with its verdict (amended, held below the bar, no clean owner), and the file and rule changed where one was. A later run reads this before re-deriving the same conclusion, and a rule sitting in a skill today can be traced back to the reviews that earned it.
