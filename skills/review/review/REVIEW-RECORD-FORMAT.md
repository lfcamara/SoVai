# Review Record Format

The record lives in the project's Obsidian vault at `docs/reviews/<YYYY-MM-DD> — <ticket or branch>.md`.

## Template

```md
# Review: <ticket or branch> — <YYYY-MM-DD>

Fixed point: <ref>
Ticket: [[<ticket>]]

## Axes run
- <axis>: <why it was selected>

## Findings
### <axis> — <severity><, owed where the axis marked it>
<where, what, why it matters>
Cause: <why this wasn't prevented earlier>

## Resolution
- Fixed: <critical/high findings, and every owed refactor, resolved before merge>
- Deferred: <medium/low findings the user chose to leave, or "none raised">
```

## Rules

- **Links are wikilinks.** `docs/` is an Obsidian vault (ADR-0010), so the ticket and any document referenced resolve by note name — `[[checkout-flow — Phase 1 Spec]]`, never a relative markdown path.
- **One record per ticket, however many rounds it takes.** A fix run and its re-review append their axes, findings and resolution to the record already on disk under a `## Round <N>` heading rather than opening a second file. `wrap-up` reads one file to decide whether anything critical, high or owed is still unresolved, and two files for one ticket is how a resolved round hides an unresolved one.
- **Every finding carries a cause.** The cause is what `harden` reads later to tell a recurring process hole from a one-off defect, and it is the only part of the record that cannot be reconstructed from the diff afterward. Name the gap ("the spec never said which seam"), not the moment ("missed it").
- **Resolution is the merge gate's input.** `wrap-up` will not merge while a critical, high or owed finding sits outside the Fixed list, so a finding moved to Fixed is one somebody checked, not one that stopped being mentioned.
