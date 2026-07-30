# Planning documents live in the repo, tickets in the tracker

PRDs and specs are written as Markdown under `docs/planning/<slug>/` in the target repo. Tickets are published to the issue tracker (Linear by default).

Documents go in git because they are versioned alongside the code they describe, diffable, reviewable in a pull request, readable in later sessions without a network call, and unaffected by a change of tracker. Tickets go in the tracker because that is where execution, assignment, and status actually happen.

The rejected alternative was PRDs and specs as Linear Documents. Linear's `save_document` supports this today, and it would centralize everything for readers who never open the repo. Rejected because it decouples the documents from the code's history and binds the planning block to one vendor.

Skills reference the tracker through `docs/agents/issue-tracker.md` in the target repo rather than hardcoding one, so tracker mechanics are written once and the plugin stays portable. Linear is the default when that file is absent.

## Tracker capability is an accepted limitation, not an open question

**Status: accepted, 2026-07-30.** Publishing has a floor that always works and a ceiling that depends on the environment, and `to-tickets` is written to fall to the floor loudly rather than fail.

The floor is the local markdown branch: one file per ticket under the effort's own directory, in dependency order, needing no network and no connected tracker at all. `to-tickets` already instructs the agent to say so plainly and write there when the connected tracker cannot create issues, so no run of the planning block is blocked by tracker capability. That is what makes this a limitation rather than a gap in the pipeline.

The ceiling is a real tracker, and it is reached per repo rather than by this plugin. The Linear connection this ADR was written against exposed documents, diffs, releases, and attachments but no issue CRUD; as of this amendment no Linear tooling is reachable from the authoring environment at all, which makes Linear-by-default the least-verified path rather than the safe one. A connected Atlassian tool set in that same environment does expose the full set — create, edit, transition, and the issue links that carry the blocking edges — so a repo that wants tracker issues instead of files writes `docs/agents/issue-tracker.md` naming a tracker whose connected tooling can create them.

The cost, stated plainly: a repo that never writes that file gets local markdown, and `wrap-up`'s move-to-Done then has nothing to move. The degradation is visible in the session rather than silent, which is why it is accepted. It is superseded the moment either a Linear connection exposing issue tools or the GraphQL API with an API key is available — but neither is required for the block to run, and the default should not be read as a claim that Linear has been verified.
