# Planning documents live in the repo, tickets in the tracker

PRDs and specs are written as Markdown under `docs/planning/<slug>/` in the target repo. Tickets are published to the issue tracker (Linear by default).

Documents go in git because they are versioned alongside the code they describe, diffable, reviewable in a pull request, readable in later sessions without a network call, and unaffected by a change of tracker. Tickets go in the tracker because that is where execution, assignment, and status actually happen.

The rejected alternative was PRDs and specs as Linear Documents. Linear's `save_document` supports this today, and it would centralize everything for readers who never open the repo. Rejected because it decouples the documents from the code's history and binds the planning block to one vendor.

Skills reference the tracker through `docs/agents/issue-tracker.md` in the target repo rather than hardcoding one, so tracker mechanics are written once and the plugin stays portable. Linear is the default when that file is absent.

Note on capability: the Linear MCP connection available at the time of writing exposes documents, diffs, releases, and attachments but no issue CRUD. Publishing tickets therefore depends on a Linear connection that exposes issue tools, or on the GraphQL API with an API key. This constrains the tracker adapter, not the skill structure.
