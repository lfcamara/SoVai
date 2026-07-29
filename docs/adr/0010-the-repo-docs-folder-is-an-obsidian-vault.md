# The repo's docs folder is an Obsidian vault, and reviews feed back into the skills

Every document a project produces — planning, reviews, troubleshooting — lives in the project repo's `docs/` folder, which is also an Obsidian vault. Documents link each other with wikilinks, and those links are what make the vault a graph rather than a pile.

## The vault is the repo folder

A vault is a folder of markdown; `.obsidian/` appears when the folder is opened in the app. So nothing needs scaffolding and nothing needs to move, and every guarantee ADR-0004 protects survives intact: documents stay versioned with the code they describe, diffable, reviewable in a pull request, and resolvable by absolute path from a cold agent session with no network.

Vaults are per project. There is therefore no cross-project sharing requirement that would justify pulling documents out of the repo — the argument that would have forced a separate location does not exist.

## Filenames carry the effort

Documents are named `<effort> — PRD.md`, `<effort> — Spec.md`, and so on, rather than `prd.md` and `spec.md`.

The graph shows the note's name and nothing else. A project with fifteen efforts would otherwise render fifteen nodes labelled "spec", which is a graph that costs something to draw and returns nothing. A node has to describe itself to be worth having.

Links are spent, not sprayed. A link exists to be traversed — a ticket to its phase, a spec to the PRD it serves — and linking everything a document touches produces a graph as useless as none.

## Findings carry severity, and severity decides obligation

Review findings are ranked critical, high, medium, or low, assigned by the axis that found them because severity depends on what that axis knows.

Critical and high are always fixed. Medium and low are fixed only when the user says so — presenting them and waiting is what keeps a reviewer from spending the user's time on work they did not ask for. The boundary between high and medium is therefore the one that carries weight: it is where a fix stops being optional, and `wrap-up` will not merge with an unresolved critical or high finding regardless of approval.

## Every finding records why it was not prevented

A finding is a defect caught. A **cause** that repeats is a hole in the process, and the two are not the same thing.

So each finding records a short cause alongside its severity, and the review record persists in the vault. This is the only part of the loop that cannot be reconstructed later: without a written cause in a form later reviews can be matched against, recurrence is invisible and the knowledge base accumulates incidents instead of lessons.

Causes name the gap — "the spec never said which seam", "no rule in code-review covers this" — rather than the moment or the person. A cause phrased as "missed it" is unmatchable and unfixable.

## Recurrence hardens the skills, on its own cadence

The `harden` skill reads accumulated review records, groups findings by cause, and turns a recurring cause into an amendment to whichever skill should have prevented it.

It runs periodically, never per review: one occurrence is not a pattern, and a rule added per incident is exactly the sediment `writing-great-skills` warns against. An amendment competes with what is already in the skill rather than being appended beside it — where an existing rule was almost right, it gets sharpened instead of joined by a second.

`harden` runs in the SoVai repo, because that is where the skills it amends live, and reads review records from whichever project vaults it is pointed at. This crosses repositories deliberately: a cause appearing once in each of three projects is invisible from inside any one of them, and that is the pattern most worth catching.

It proposes rather than applies. A skill change alters every future run, which is too consequential to land from a pattern the user has not seen.

## Troubleshooting notes are written at wrap-up

A troubleshooting note records a bug, why it happened, and how it was resolved. It is written when the fix merges, not when the bug is diagnosed — `diagnose` deliberately ends at a ticket, and at that point the resolution does not exist yet to be recorded.

The note is written in the words of the **symptom** rather than the diagnosis. Its value is being found again by someone hitting the same behaviour later, and the name of the root cause is precisely what that person does not yet have to search on.
