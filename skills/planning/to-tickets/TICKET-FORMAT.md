# Ticket Format

## Template

```md
# <Title>

**Phase:** the phase this belongs to, linked as `[[<effort> — Roadmap#Phase <N> — <name>]]`, or omitted when there is no roadmap.

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective — not a layer-by-layer implementation list.

**Blocked by:** the tickets that gate this one, or "Nothing — can start immediately".

**Acceptance criteria:**

- [ ] Criterion 1
- [ ] Criterion 2
```

## Rules

- **The same body goes to every tracker.** A ticket published as a tracker issue and a ticket written to local markdown carry identical content; only the mechanics of the blocking edge differ. See [TRACKERS.md](./TRACKERS.md).
- **Behaviour, not layers.** "What to build" describes what works when the ticket closes. A ticket that reads as a task list for one layer is a horizontal slice wearing a vertical slice's title.
- **Acceptance criteria are checkable.** Each one is a thing someone can observe being true or false, because `wrap-up` verifies them and `implement` derives its test list from them.
- **No file paths, no code snippets.** They go stale before the ticket is picked up. One exception: a prototype snippet that pins a decision more precisely than prose can, trimmed to the decision-rich part.
- **Spend links on the jump a reader would actually make** — a ticket to its phase, a ticket to the spec decision it implements. Linking everything a document touches produces a graph as useless as no graph.
