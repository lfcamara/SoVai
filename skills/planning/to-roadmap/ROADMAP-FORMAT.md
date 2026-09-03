# Roadmap Format

The roadmap lives at `docs/planning/<effort>/<effort> — Roadmap.md`, beside the PRD.

## Template

```md
# <Effort name> — Roadmap

PRD: [[<effort> — PRD]] · Wireframes: [[<effort> — Wireframes]]

## Phase 1 — <name>

**Ships:** what a user can do at the end of this phase.

**Stands alone because:** the value that survives if everything after is cancelled.

**Depends on:** earlier phases, or "Nothing — can start immediately".

**Exit criteria:**

- [ ] Criterion 1
- [ ] Criterion 2

**Spec:** `[[<effort> — Phase 1 Spec]]`, once that phase starts.
```

## Rules

- **Phase headings are link targets.** A ticket points at its phase as `[[<effort> — Roadmap#Phase <N> — <name>]]`, so the heading text is an interface: renaming a phase after tickets exist breaks every link into it.
- **No effort-wide spec link.** Each phase gets its own spec when it starts, and the phase entry is where that link belongs — a roadmap written before any spec exists cannot point at one.
- **Exit criteria are observable.** `wrap-up` verifies them when the phase's last ticket merges, so each has to be a thing someone can check rather than a summary of intent.
