# Trackers

Publishing needs four capabilities, whatever the tracker is called:

1. **Create** an issue with a title and a body.
2. **Express a blocking edge** — that ticket B cannot start until ticket A closes.
3. **Set a parent**, so a phase can hold its tickets. Optional; skip where the tracker has no such concept.
4. **Set state**, so a ticket can be moved to Doing when dispatched and Done when merged. `implement` and `wrap-up` depend on this one.

A tracker missing capability 1 or 2 cannot be published to. Say so plainly and fall to local markdown rather than publishing a partial graph — a dependency graph with the edges dropped is worse than a directory of files, because it looks complete.

## Local markdown — the floor

Always available. Needs no network, no connection, and no configuration. This is what `"kind": "local"` selects, and what every other branch falls back to.

- One file per ticket at `docs/planning/<effort>/tickets/<NN> — <Ticket title>.md`, numbered from `01` in dependency order. One ticket per file, never a combined file.
- Blocking edges are the **Blocked by** field, naming other tickets by their number and title.
- State is the file's position in the flow and nothing else. There is no Doing and no Done here, which is the honest cost: `wrap-up`'s move-to-Done has nothing to move, and it should say so rather than pretend.

## Linear

`"kind": "linear"`. Needs `team` and `project` in the config — neither is guessable from the repo.

- One issue per ticket, on the project matching the effort.
- Blocking edges use Linear's native blocking relationship.
- Where the tracker models phases as parent issues, make each ticket a sub-issue of its phase. Leave any parent issue open and unmodified.

**Verification status:** the Linear connection this was written against has exposed documents, diffs, releases and attachments but not issue CRUD, and has at times not been reachable at all. Check that issue creation actually works before relying on it, and fall to local markdown loudly if it does not.

## Jira / Atlassian

`"kind": "jira"`. Needs `project`, and `team` where the instance uses it.

- One issue per ticket.
- Blocking edges use issue links of type "blocks" / "is blocked by".
- Phases map to Epics: set the ticket's parent to the phase's Epic where one exists.

## GitHub Issues

`"kind": "github"`. Needs `repo` (as `owner/name`).

- One issue per ticket, via `gh`.
- GitHub has no native blocking relationship. Express the edge in the **Blocked by** field of the body, referencing issues by number, and say in the run summary that the edges are prose rather than structured — a reader of the tracker cannot compute the frontier from them.
- Phases map to milestones. Labels are not a substitute for a parent; do not invent one.

## Adding a tracker

Add a section here, not a branch in `SKILL.md`. The skill states the four capabilities and the order of publication; this file is the only place that knows what any particular tracker calls them.
