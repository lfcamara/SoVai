# Screen verification is a third agent

The plugin gains `screen-verifier`, an agent that drives a browser against a running app and reports whether a screen renders and works, backed by artifacts. Until now nothing in the plugin ever looked at a rendered screen.

`ui-testing` writes tests for a screen after it is implemented, derived from the effort's wireframes. ADR-0007 argues that ordering and it still holds — but a test derived from a wireframe and a screen that actually renders are independent facts. A component test passes against a mounted component while the screen it belongs to fails to load, throws on mount, or renders against a request that failed. Every claim the plugin could previously make about an interface was inferred from source or from a test harness, never observed. `screen-verifier` closes that one gap.

## Why an agent rather than a skill

ADR-0006 ships two agents split by execution mode, rejects a roster of role agents, and sets the bar for adding one: a role earns an agent when it implies a distinct standing context pack, not when it names a job title.

This clears that bar on both halves. It is not a job title — "frontend developer" is a person, while "observes a running system through a browser" is an execution mode, and it is a third one sitting beside writes and reads-only on exactly the axis ADR-0006 chose. And the standing context pack is real and specific: bring the app up without owning how, authenticate without echoing credentials, drive the browser, decide what counts as evidence, hold an honest UNVERIFIED state, and report in a fixed shape. That is content, not an empty label.

The tool grants settle it. `reviewer` holds `Read, Glob, Grep, Bash, WebFetch`: Bash means it could start a dev server, but nothing in that list can navigate to an entry point, capture a screenshot, or read a console. `implementer` adds writing, `Skill` and `TodoWrite`, and no browser either. Neither existing agent can perform this verification at all, so a skill would have had no host but the orchestrating session — which is the one place output like this must not land.

## What was rejected

**A skill dispatched to `reviewer`, with its tool grant widened.** This was the leading alternative and it costs more than it saves. All five review axes would inherit a browser none of them uses, and — the deciding objection — a browser can click. An agent able to submit a form or press a Delete control is not read-only against the running system, however read-only it stays against the repository. That guarantee is load-bearing: ADR-0006 rests on it and the `review` skill cites it as what makes findings trustworthy as findings. Keeping the browser out of `reviewer`'s grant keeps the guarantee true rather than aspirational.

**Giving the check to `implementer`.** It holds Write, so it would fix what it found, which destroys the evidence and returns a verdict nobody can audit. That is the reasoning that made `reviewer` read-only, and the reasoning behind the Testing state in ADR-0007.

**Folding it into `ui-testing`.** Different artifact, different claim, different requirements: one produces a suite that runs again on every commit, the other produces a verdict about one moment and needs a running app and a browser to reach it. Merging them would make writing tests depend on a stack being up.

ADR-0007's argument that verification stays inside the subagent is satisfied rather than contradicted. Browser output — page dumps, console logs, network traces — is exactly the verbose class that argument covers, and it dies with this subagent as it does with the implementer's. The argument requires a subagent boundary; it does not require that the boundary be the implementer's.

## Read-only by discipline, not by construction

`screen-verifier` declares no `tools` allowlist, because a fixed allowlist cannot name browser tooling whose names vary by environment, and an agent that cannot reach a browser is the one thing this agent must not be. It therefore holds a full grant and carries the constraint in writing instead: it observes, reports what it would have fixed, and confines its own writes to evidence artifacts in a scratch directory and a throwaway driver script.

This is deliberately weaker than `reviewer`'s guarantee, and the trade is stated rather than hidden — tooling-agnosticism is bought by downgrading an enforced constraint to a stated one.

## Platform-agnostic by construction

The agent names no framework, no port, no authentication provider and no route. Project facts — how to start the app, the entry point, how to authenticate, which identifiers the screen needs — arrive in the brief per the `delegate` contract, or are looked up in the project's own configuration. Nothing project-specific is baked into the plugin, which is what lets one agent serve every repository that installs it.

The unit stays the screen in the platform-neutral sense ADR-0005 fixed. A browser is the usual driver, not the definition: the same four capabilities — navigate, read the page, capture a screenshot, read console and network output — and the same report apply wherever a screen lives, with whatever driver that platform provides.

Where no such driver is available, the verdict is UNVERIFIED with the reason. Reading the source and reasoning about what it would render is the assertion this agent exists to replace, so producing one anyway would be worse than reporting the gap.

## Cost

The plugin now ships three agents, and the count in `README.md` moves with it.
