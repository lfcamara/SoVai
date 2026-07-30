# Per-project configuration is one file at the project root, found by walking up

The hooks learn what a project is shaped like from a `sovai.config.json` at that project's root, discovered by walking up from the edited file to the nearest one. Three keys, all lists of path patterns: `productionLogic` for paths where TDD is mandatory, `ui` for the exception, `tests` for files gated by nothing. Precedence runs tests, then ui, then productionLogic, so a UI path nested under a production path wins and no project has to write exclusions into `productionLogic`.

## The plugin cannot know, so it must be told

SoVai's premise is being project-agnostic. It has no idea which repositories it is installed into, what they are built with, or which of their directories hold screens. [ADR-0007](0007-development-block-shape.md) makes exactly that last distinction load-bearing: TDD is mandatory for non-UI logic and UI is the deliberate exception, so a gate that cannot tell UI from logic either blocks a UI-only session that was correct to skip TDD, or waves through backend logic that was not. Both failures are worse than no gate, because both teach the developer to route around it.

There is no plugin-side default that could stand in. `src/components` is a UI directory in one project, a component library with dense logic in another, and absent from a third. The only party that knows is the project, and one file is the smallest way for it to say so.

## Walking up is what makes it a drop rather than an edit

The alternative to discovery is a registry: a list inside the plugin mapping paths or repository names to shapes. That makes onboarding a code change to SoVai — a commit, a version bump, a plugin update on every machine — to teach it about a project that has nothing to do with it. Walking up inverts it. Onboarding is copying `sovai.config.example.json` to a project root and renaming it, and the plugin never learns any project's name.

Because the config sits at the project root and is found by ancestry rather than by an absolute path recorded somewhere, git worktrees and clones inherit it for free. A worktree carries the file because the file is tracked, and the walk resolves relative to whichever copy the edited file actually lives in. Nothing needs re-registering, and no path in the plugin points at a location on one developer's disk.

## The resolver fails open

No config found means no gating, and the hook exits 0. A malformed or unreadable config means the same: every reader returns empty rather than failing, and an empty pattern list matches nothing. A project is opted in by the presence of the file and opted out by its absence, with no third state.

This direction is chosen rather than incidental. Under-gating costs a missed reminder; over-gating costs a developer who cannot finish a session, and a hook that breaks work over its own configuration gets uninstalled, taking the rules it was carrying with it. A gate that fails closed protects nothing once it is gone.

Patterns are matched with shell globbing against the path relative to the project root, where `*` also crosses `/` — so `src/**` matches `src/a/b.ts`, and `*.test.*` matches a test file at any depth. Deliberately forgiving: a pattern matching slightly too much costs one extra reminder, while a regex dialect nobody remembers costs the config being written wrong, and a config written wrong is a gate that fires on the wrong files.

## Rejected alternatives

**A fixed enum of stacks.** The reference harness this pattern is ported from resolves a file to one of `backend | frontend | data | platform`, which works because that harness serves a known set of repositories with a known division of labour. SoVai serves none in particular. An enum would have to either enumerate every stack anyone might use — a list that is wrong the first time someone arrives with Rust, or a monorepo, or a project whose backend has no UI at all — or collapse to `backend`/`frontend`, which is the same wrong guess with fewer words. What the gates actually need is not a stack name but a path classification, and asking for the classification directly skips the mapping step entirely.

**Inferring from file extensions.** `.tsx` looks like UI, `.sql` looks like a migration, and the config file disappears. It fails on the thing that matters: a `.ts` file is production logic or a UI hook depending on where it sits, and extensions cannot see where a project draws that line. It also guesses silently — a wrong inference produces a gate that fires on the wrong files with no record of the assumption, whereas a config that says the wrong thing can be read, corrected, and reviewed in a pull request like any other decision.
