# Changelog

Every release of the `sovai` plugin, newest first.

Versioning is manual: bump `version` in `.claude-plugin/plugin.json` and add a dated entry here. Claude Code surfaces a new version to everyone who has the plugin installed, and that is what makes the number load-bearing rather than decorative — it is the only signal an installed user gets that the process running inside their sessions changed under them. The reasoning is in [ADR-0017](docs/adr/0017-release-discipline.md).

What the parts mean for a plugin whose product is process rather than code:

- **Patch** — a fix or a rewording. The same process, working or reading better than it did.
- **Minor** — a new capability: a skill, an agent, a hook, a review axis. Everything you were already doing still runs the way it ran.
- **Major** — the workflow changes shape. A stage moves, splits, or disappears; a gate redefines what counts as done in a way that invalidates how you worked before; or the plugin installs differently.

Entries say **why**. What changed is recoverable from the diff forever; why it was worth changing is recoverable only while someone still remembers, and that window is short.

## Release step

Work on a branch. **Merging to main is the release**, because that is what `/plugin update` pulls — so steps 2 through 5 apply at the merge, not at every commit. Pushing a change straight to main releases it either way; the only thing skipping the version does is take away the one signal an installed user gets that their process changed.

1. Make the change — skill, agent, hook, or doc.
2. Run the plugin's reference linter, `skills/knowledge/lint-references/lint.sh`, from the repo root. Exit 0 or the release stops. Every cross-reference in this plugin is a bare name in prose — a skill naming a skill, an ADR citing an agent — that nothing else validates, and the manifest has to agree with what is on disk in both directions, since an undeclared skill never loads and a declared path that no longer exists is a load error someone else meets first. A dead reference does not raise an error; it silently does not happen, in a session you are not in, and the person who installed the plugin has no way to tell it was ever meant to work.
3. Bump `version` in `.claude-plugin/plugin.json`, per the policy above.
4. Add a dated entry below, saying why the change was made.
5. Merge the branch to main. Installed users pick it up with `/plugin update sovai@sovai`.

---

## 1.1.1 — 2026-08-23

An audit of the plugin against itself. Nothing here changes what the workflow does; two things it already claimed are now true.

**Fixed: the reference linter passes.** `skills/development/verify/` sat in the working tree, undeclared in the manifest and untracked in git, which meant it never loaded — and it was the one dead reference `lint-references` reported, so step 2 of the release above could not have been cleared by anyone who ran it. The skill is retired rather than declared. Its in-ticket half was already inlined into `implement`, and `verify-before-claiming` already owns the evidence discipline; what neither covered was the orchestrator checking a build outside a ticket, which is one rule about where a log may land and now sits in `delegate`, beside the decision it qualifies. Retiring it also removes a name one suffix away from `verify-before-claiming` for a different job.

**Fixed: the planning stages say why they stay in the session.** Every one of them ends with the user reading a draft and correcting it, and a cold agent can only be re-briefed, never corrected — that was the reason the pipeline keeps planning in the orchestrator, and it was written down nowhere. Against a SessionStart bootstrap that mandates delegation, each stage read as an arbitrary exception. Each now carries the specific mechanism that keeps it: nobody to interview, nobody to put the seams to, nobody to react to the artifact. `delegate` carries the conclusion the five share, so there is one index and five reasons rather than one assertion repeated.

**Changed: the release step names the branch.** Merging to main is what `/plugin update` pulls, so that is the release, and steps 2–5 apply there. Written down because the alternative on offer was relaxing the version policy to fit the habit of committing to main, which would have cost the signal the policy exists for.

**Why patch.** No capability was added or removed. The retired skill was never in the manifest, so nothing possible in 1.1.0 became impossible — no installed session could reach it.

## 1.1.0 — 2026-07-30

v1.0.0 wrote its rules down and trusted the agent to reach for them. This release makes the ones that matter fire on their own, and stops the plugin taking the agent's word for anything it could have gone and checked.

**Added: an enforcement layer** (ADR-0012). Mandatory TDD for production logic, and UI as the deliberate exception tested after the fact (ADR-0007), were stated in the skills and in an ADR — and whether either applied to a given session came down to whether the agent happened to invoke the skill. Hooks make them deterministic: a session-start bootstrap that states the orchestration mandate and indexes the blocks, a pre-edit gate that names the skill which should already be in play before the edit lands, phase tracking across the red-green loop, and a stop gate that refuses to end a session which edited production logic without ever entering `tdd`. The gate is a heuristic and says so in its own header — it catches TDD skipped entirely, never green-before-red ordering, which no Stop hook can see — and it carries an explicit per-session override for the changes it gets wrong.

What a file *is* comes from a `sovai.config.json` at the edited project's root, which the hooks reach by walking up from the file. No project name, stack, or directory convention is baked into the plugin: only the project knows which of its directories are UI, and ADR-0007 makes that distinction load-bearing, so there is no plugin-side default honest enough to stand in for it. A project with no config is not gated at all, which makes onboarding a one-file drop and makes the hooks fail open by construction — the cost of under-gating is a missed reminder, and the cost of over-gating is a developer who cannot work (ADR-0013).

**Added: `verify-before-claiming`** (ADR-0014). Every brief in this plugin asks for checkable done criteria, and then the plugin accepted the word "done" as evidence they were met. This is the standing rule that closes the gap: run the check that would contradict the claim, show what it said, and where no command exists behind a claim, state what you could not verify. It binds a subagent exactly as it binds the orchestrating session — which is where it earns its place, because a subagent's confident report is the one artifact in the whole flow that nobody re-examines.

**Added: `goal-review`, a sixth review axis** (ADR-0015). The five existing axes all judge the diff, and the diff cannot show that the change was never merged, that the flag gating it is still off, or that a third of the ticket was quietly deferred. Well written, on spec, well tested, and inert reads as done to every axis that existed. This one reads the state of the world the ticket wanted changed instead, reporting merge, enforcement, scope coverage, and tracker agreement as facts — a fact becomes a finding only where it contradicts a claim that the work is shipped, so a draft PR on a ticket still in Doing stays silent.

**Added: `screen-verifier`, a third agent.** Nothing in the plugin had ever looked at a rendered screen, so a claim that a UI worked was reasoning about source code. This agent drives a browser against a running app and returns a verdict backed by artifacts — the screenshot, the entry point it actually loaded, the console and network output — or an honest UNVERIFIED where no browser tooling is reachable, which is the answer that reasoning-about-source was standing in for. It is a third execution mode beside writes and reads-only rather than a job title, and the browser deliberately stays out of `reviewer`'s grant: a browser can click, and `reviewer` being unable to touch what it finds is what makes its findings auditable (ADR-0016).

**Added: `lint-references`.** The plugin is self-referential — skills name skills, skills name agents, ADRs cite both, and the manifest declares every skill path — and none of those references is checked by the filesystem, by Claude Code, or by anything else, because they are bare names in backticks rather than paths. A rename leaves the old name sitting in prose, still reading live. The linter resolves them, checks the manifest against disk in both directions, refuses to print clean if it resolved a plugin root with no skills under it, and is now step 2 of the release above.

**Removed: `grill-me`.** Its entire body was an instruction to run a `grilling` session. But `grilling` is model-invoked, and per `writing-great-skills` model-invocation always *includes* user reach rather than replacing it: `/grilling` was already typeable, "grill me" was already a trigger phrase in `grilling`'s own description, and the wrapper therefore bought no reach at all while adding a second name for one meaning and one more skill for the human to remember. `grill-with-docs` survives the same question because it composes two skills instead of aliasing one, and it gained the boundary that distinguishes it from `brainstorm`: it ends at a settled design with its trace written, where `brainstorm` carries on into the planning documents.

**Added: this file, and a release step.** The plugin shipped at 1.0.0 with no record of what was in it and no procedure for cutting the next one, which holds up for exactly as long as there is one user who is also the author.

**Why 1.1.0 and not 2.0.0.** Every addition above is a new capability, and the one removal is an alias whose target stays reachable both by name and by trigger phrase — nothing possible in 1.0.0 is impossible now. The hooks are the strongest case for a major, since they change sessions that invoke nothing at all; but what they enforce is the process 1.0.0 already documented, and making a stated rule deterministic instead of advisory is the same workflow rather than a new one. The pipeline's stages, their order, and their contracts are untouched. Major stays reserved for the reshaping that first contact with a real project will cause — which, as the README says, has still not happened.

## 1.0.0 — 2026-07-29

First installable release: the six blocks, complete and internally consistent, and honest that they were unproven. Every stage was reference-checked and reviewed against its own standards; none of it had been run against a real project. Reconstructed from the commit history rather than written at the time, which is the gap this file exists to close.
