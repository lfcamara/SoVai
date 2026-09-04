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

## 2.2.1 — 2026-09-04

**The five review axes stop advertising themselves as entry points.** Each description opened with a standalone trigger — "Use to check code quality on a diff", "Use when reviewing a diff's security implications" — so a plain-language request could fire one on its own, outside the dispatcher. Everything that makes an axis's findings count lives in `review` and not in the axis: the pinned fixed point, the severity ladder, the **owed** marker, the recorded cause, and the record `wrap-up` reads before it merges. An axis reached alone produced findings the merge gate never sees, while reading exactly like a real review.

The descriptions are now reach clauses — "the security axis of `review`… use when `review` dispatches this axis" — and `review` states that a request for a single axis is served by running `review` with that axis selected. It already did this for a security pass asked for explicitly; the rule is now general.

**Merging the five into `review` was considered and rejected.** As reference files they would be *read* by a subagent rather than *loaded* as skills, and `delegate`'s own contract is that pointing at a skill "beats restating it and cannot drift from it" — weaker exactly where the criteria need to be reliably in the reviewer's head. The `reviewer` agent holds the `Skill` tool for this reason. Five skills, five parallel agents, five separate reports: unchanged.

**What this does not do, stated plainly.** `disable-model-invocation` would make the bypass impossible, and is unavailable — a user-invoked skill cannot be reached by another skill either, so `review` could no longer dispatch. Reach-only wording steers; it does not lock. The residual case is a user typing an axis name deliberately, and each axis now carries a short **Entered directly** section for it: say what is missing, and run `review` for that axis where the work is heading for a merge. Silent-wrong becomes self-correcting.

Recovers 235 characters of always-loaded description.

## 2.2.0 — 2026-09-04

**The TDD Stop gate is removed, and the hooks stop claiming to enforce.** What is left is two hooks that remind: the SessionStart bootstrap and the pre-edit reminder. The phase tracker, the `/tmp` sentinels that crossed between hooks, and the per-session override go with the gate ([ADR-0012](docs/adr/0012-the-plugin-ships-an-enforcement-layer.md), amended).

Three reasons, and the first is structural. **Every output channel a Stop hook has reaches the model and not the user** — the block `reason`, `systemMessage` (documented as "shown to Claude, not the user"), stderr on exit 2 — and the model holds `Bash`. So the gate's clearing condition, `touch /tmp/sovai-tdd-override-<session>`, was writable by the only party in a position to want it written. A constraint the actor can lift is a request, which is the reasoning ADR-0006 used to make `reviewer` read-only by tool grant rather than by instruction.

Second, it fired in the wrong place. A ticket reaches an `implementer` through a brief naming `implement`, and `implement` points at `tdd` — three explicit pointers, so nothing on the pipeline's own path depended on the model spontaneously reaching for the skill. The gate only ever fired on work that bypassed the pipeline: the one-line fix, the ad-hoc edit. That is exactly the population where "this did not need TDD" is usually right, which is why the override existed at all. A gate whose exception is its normal case teaches its reader to dismiss it.

Third, it could not see the thing TDD is about. Its own header admitted it: a session invoking `tdd` after writing the code cleared it exactly as a disciplined one did. It checked that a skill was invoked, never that a test came first.

**What holds a diff to mandatory TDD was already here.** `test-review` reads the tests against the diff and asks whether they would fail on a real regression, `code-review` marks the postponed refactor **owed**, and `wrap-up` refuses to merge past an unresolved critical, high or owed finding. Those run on evidence, by a party that is not the one being checked, and no `touch` clears them.

The pre-edit reminder survives unchanged in substance and simplified in mechanism: it keeps one fire-once marker per class so each message lands once rather than on every edit, and its Green-minimal branch is gone with the tracker that fed it. Its header now says it reminds. The cost is stated: a session that slid into implementation and never invoked `tdd` is no longer told so at the end — only at the first edit.

**Why 2.2.0 and not 3.0.0.** By this file's own definition a gate disappearing is major. The version exists to signal a changed process to installed users, and there are none — 2.0.0 shipped and has still not been run against a real project. Escalating the major on a workflow nobody has used spends the signal on an empty room. This is a deliberate departure from the policy above rather than a reading of it, recorded here so the policy stays intact for the release where it matters.

## 2.1.2 — 2026-09-04

**The workflow page's version badge is checked against the manifest.** It read `v1.1.1` while the plugin was on 2.1.1 — three releases stale, and stale in the one place a reader has no way to test what they are being told.

The fix that worked for the markdown does not transfer. `engineering-workflow.md` stopped restating the version and points at `plugin.json`, which is available to it as a link; the HTML is a rendered page where a version belongs on the page itself. So the badge stays and the linter keeps it honest instead.

What is deliberately **not** attempted is generating the page from the markdown, or checking that their sections cover each other. The two are structured differently on purpose — one reads top to bottom in stages, the other browses an interactive pipeline — so neither derives from the other and a coverage check between them would report noise rather than drift. The version is the one fact on that page with a single correct value, which is why it is the one thing asserted.

## 2.1.1 — 2026-09-04

**The pull request now comes out of draft.** `open-pr` carried the instruction — "mark it ready only once its reviews pass" — and could not execute it: it runs inside the implementer, immediately after the red-test push, and that run ends before any review exists. Nothing else claimed the step. So every PR stayed a draft, and `wrap-up`'s first precondition is that the PR is not one, which meant the merge gate could never open on a ticket that had gone through the process exactly as written.

`review` owns it now, at the end of its round loop, which is the only place that knows the loop ended. The split matches the one `open-pr` already makes for linking the ticket back: a step goes to whoever can observe its condition, not to whoever the concept belongs to.

Ready is not approval, and the distinction is worth keeping sharp — it says the reviews are done and the diff is now asking, where the merge still waits on the user saying so about that specific PR. `wrap-up`'s precondition stops being unsatisfiable and becomes diagnostic: a PR still in draft when it runs means the review loop never finished.

## 2.1.0 — 2026-09-04

**The linter now checks the pipeline's order.** Everything it did before asks whether a name resolves. This asks whether it is the *right* name, and it exists because 2.0.1 had to fix a case where it was not: `to-prd` handed off to `to-spec` after the spec moved below the roadmap, and the reference was clean by every check — `to-spec` is a real skill, sitting in a real directory, declared in the manifest.

That class is invisible by construction. The pipeline auto-continues (ADR-0001), so nobody types a stage name; a moved stage leaves five documents updated and one closing line pointing at where it used to be, and the only party who could notice is a reader who already knows the order. Two failure modes are now caught: a hand-off naming a stage the pipeline does not go to next, and a stage that has a successor declaring none at all — the chain stopping, which reads as a skill that finished rather than one that broke.

The order lives in `lint.sh`, in one ordered list, and that placement is the decision. The README, the SessionStart bootstrap, `engineering-workflow.md`, ADR-0019 and this file all state the same sequence in prose; none of them executes. When they disagree with the skills, this copy fails the release rather than the five of them agreeing quietly with each other.

What it reads is the imperative form — "run the `x` skill" — which is what actually drives the chain, as distinct from prose naming a stage in passing. A name that is not a pipeline stage is not a hand-off and is left alone, so `grilling`, `domain-modeling` and `frontend-design` go on being named freely. A branch is expressed as more than one allowed successor, which is what `to-prd` needs now that it routes on whether the effort has an interface.

**Why minor.** A new capability in the release step, and nothing about the workflow changes shape. The cost is that adding, removing or reordering a planning stage now means editing the list in `lint.sh` too — which is the point rather than a side effect.

## 2.0.1 — 2026-09-04

An audit of 2.0.0 against itself, the day after it landed. Two fixes, both in the seam the rework left behind.

**`to-prd` was still handing off to `to-spec`.** The spec moved below the roadmap and became per-phase, and every surface describing the pipeline was updated — README, SessionStart bootstrap, workflow document, ADR-0019, the entry below. The skill's own closing line was not. Because the pipeline auto-continues (ADR-0001), nobody types the stage names, so nobody was placed to notice the chain went somewhere else; and where it went could not work, since `to-spec` now opens by resolving a phase and reading the roadmap entry that scopes it. It also skipped `to-wireframes`, whose screens `to-roadmap` draws boundaries from and whose coverage table `ui-testing` reads.

The linter did not catch it and could not: `to-spec` is a real skill, and `lint-references` says in its own limits that it does not check whether a resolved reference is the right one. The pipeline's order is currently written on five surfaces and asserted on none, which is the gap worth closing next.

**The no-interface branch had gone missing with it.** The old `to-spec` carried the test for whether an effort has a user-facing interface and routed a headless one past wireframes. When the spec moved, the branch travelled to a stage that now runs too late to make the choice, and nothing picked it up — so a backend-only effort was routed into the stage whose whole job is naming screens it does not have. `to-prd` carries it now, where the PRD has just settled whether anyone is looking at anything. `to-roadmap` takes the other end: its full-coverage test walks the PRD's stories and the wireframes' screens, and an effort that skipped wireframes has only the first list, which it now says rather than claiming coverage against a file nobody wrote.

**Two stale counts.** ADR-0011 and `lint-references`' own description still said six review axes. Neither is load-bearing, and both are the kind of number a reader trusts without checking.

**Why patch.** No stage moved, split or disappeared, and nothing changes what a working 2.0.0 session did. A chain that pointed at the wrong stage now points at the right one, and a branch that existed before the rework exists again.

## 2.0.0 — 2026-09-03

Planning and execution reworked end to end. Major by this changelog's own definition: stages move, a stage leaves the automatic chain, another stops mid-pipeline and waits for you, the pipeline gains entrances that are not the top, and work lands on a different branch than it used to. If you learned the old shape, it no longer holds.

**The spec moved below the roadmap and became per-phase.** This is the change the rest was clearing the way for. The pipeline's spine is that detail planned against a codebase that will have moved is detail thrown away — it is why tickets are written per phase and why prototyping left the chain. The spec broke that rule at the worst point: the most detail-dense document here (seams, interfaces, schema, contracts), written earliest, covering the widest scope, at the moment least was known. A phase starting four months after its spec inherited decisions made against a codebase that no longer existed. `to-spec` now runs once per phase, when that phase starts.

The obvious objection is that phase boundaries need to be technically informed. They do, but not by a spec: a phase is defined by what it ships, so coverage now walks the PRD's user stories and the wireframes' screens — one indirection closer to where that list always came from. What the roadmap genuinely needed was the handful of technical **forks** the sequencing depends on, and those are now settled in `to-roadmap` itself and recorded as ADRs. That is the whole of an effort's architecture record, deliberately: an architectural decision outlives every phase it touches, implementation detail belongs to the phase that is starting, and splitting them by lifetime is what keeps both true. The cost is stated rather than hidden — nothing forces the ADR to be written, because it is a judgement and a judgement cannot be gated.

**You can enter in the middle.** Every request used to land at the top — `brainstorm` chained unconditionally into `to-prd`, so a copy change and a new product got the same documents. Three entrances now, sized by the work, and the routing rule lives in the SessionStart hook rather than in a new skill: a router only works if it fires before everything else, and skill invocation is semantic rather than ordered. One that fires most of the time is worse than none, because the misses go unrouted and the always-loaded description is paid for anyway.

**`to-wireframes` hands you a design brief instead of drawing the screens.** It was doing two separable jobs: deriving the screens from the PRD's user stories with a coverage table, and rendering them by hand as an HTML artifact. The first is load-bearing — `to-roadmap` draws phase boundaries from it, `ui-testing` derives its minimum test list from it. The second was the plugin doing a design tool's job. It now writes a brief that *is* the prompt, and you take it to Claude Design or whatever you use. Not auto-invoking that tool is the point: it is someone else's product, and hard-wiring it would make the most visual stage of the pipeline its most fragile. The cost is a real stop in the chain, so the skill gained a second entrance — you come back with a canvas and it reconciles the record against what you actually drew.

**`prototype` is offered, not scheduled.** The per-phase cadence was right; running one every phase was not. A phase arriving there has a PRD, wireframes, a roadmap and now its own spec behind it, and most have nothing left open. The offer has a trigger rather than a mood: the spec's Risks and unknowns section is where an open question is already written down.

**`to-phases` is now `to-roadmap`.** Every other skill in the block is named for the artifact it writes. A separate epics stage was considered and rejected: epics have no cadence of their own, and phase-to-epic is a publishing concern `to-tickets` already handles.

**Tickets stopped assuming Linear.** Tracker facts had three competing homes and the config file that already sits at every project root held none of them. They live in `sovai.config.json` now, under one key. The Linear default is withdrawn — an unconfigured project either published into the wrong place or failed against a service nobody had connected, both of which read as the plugin being broken rather than as one missing line of config. With nothing configured, `to-tickets` asks once, offers to write the answer, and falls to local markdown when nobody is there to ask.

**Editing a `SKILL.md` now points at the standard for writing one.** A branch in the pre-edit hook, fired once per session, naming `writing-great-skills`. It exists because the instruction it enforces already existed in `CLAUDE.md` and was skipped during this very rework — the audit afterwards found a skill given a second entrance whose trigger never reached its description, leaving that entrance unreachable from the cold session it exists to serve. It keys off the filename and reads no config: SoVai's own repo has no `sovai.config.json`, so a config-driven version would have fired everywhere except the repo where skills are actually written.

**The documents got format files.** PRD, spec, roadmap, ticket, wireframes, design brief and the review record moved out of the skill bodies, following the convention `domain-modeling` set. This is not progressive disclosure and is not defended as such — every run reaches these templates. What it buys is a shape that can carry its own constraints, and the ones previously implicit are now written down: user stories are numbered because two downstream skills key off those numbers, and sections are fixed because `spec-review` and `implement` find what they need by heading.

Phase specs are named `<effort> — Phase <N> Spec.md` rather than nested in a per-phase directory, because `docs/` is an Obsidian vault and the graph shows a note's name and nothing else.

**A phase gets a branch, and a ticket gets a worktree** ([ADR-0020](docs/adr/0020-work-lands-on-a-phase-branch-through-worktrees.md)). Tickets used to go one at a time into `main`, which meant `main` routinely held two thirds of a capability and the way back out was a sequence of reverts nobody planned. `to-tickets` now ends by cutting `phase/<effort>-<NN>` from `main`; every ticket branches from that, targets it with its PR, and the phase reaches `main` as one merge, at close, under its own approval. The phase is what ships, so the phase is what merges.

The worktree half fixes something that was simply broken. `to-tickets` has always ended on a frontier and said those tickets can run in parallel — and in a single working tree they cannot, because two implementers share one checkout and one HEAD, so the second one's first commit lands on the first one's branch. Each ticket now gets `<project root>/worktrees/<TICKET-ID>-<slug>`. Inside the root, because a cold subagent can derive that path from the root it already knows; git-ignored, because otherwise every code search returns the same hit once per tree. A worktree is a checkout of tracked files and nothing else, so it has no `.env` and no `node_modules` and is not runnable when created — the project says what makes it runnable, in a new `worktreeSetup` list in its own `sovai.config.json`, for the same reason no path list is hardcoded here. `wrap-up` removes the worktree and the branch once the merge is confirmed, and never forces: a tree holding uncommitted work is a fact to report, not a directory to delete.

The costs are real and were taken deliberately. `main` is no longer releasable per ticket, so a project that deploys on every merge cannot use this shape. A phase branch ages, so it integrates `main` whenever `main` moves and each ticket rebases before its PR. And a worktree under the root has to be excluded again in any tool that globs on its own terms rather than honouring `.gitignore`.

**The test list is asked for, not offered** ([ADR-0011](docs/adr/0011-the-test-list-is-approved-not-the-tests.md), amended). Approving the behaviours before the loop runs was a standing preference, read from the target repo's `CLAUDE.md`, with `to-tickets` asking once and offering to record the answer. Both halves were wrong in practice: a question asked every time becomes a prompt to dismiss, and a question asked once becomes a config line nobody revisits when the answer changes — meanwhile every ticket paid a round trip for a control that was rarely wanted. Tickets now go straight into the red-green loop, and the list is produced for the tickets where you ask for it. What you approve is still a list of behaviours rather than written tests; that argument did not change.

**Review is back to five axes** ([ADR-0015](docs/adr/0015-review-has-a-goal-axis.md), reversed). `goal-review` was added to close a structural gap: every other axis reads the diff, and a diff looks identical whether the change was merged, held behind a flag still switched off, or two thirds of its ticket. The gap was real; what changed is that it acquired other owners. `wrap-up` gates the merge on the PR's state and CI and verifies a phase's exit criteria at close — both were preconditions this axis reported on separately — and its **tracker consistent** state was never verifiable in the first place, since reaching Linear or Jira takes connectors the `reviewer` does not hold. The one question with no second owner, scope the ticket promised and the diff quietly does not carry, moves to `spec-review` as a fourth finding type, where the ticket and the spec were already being read. An axis that mostly re-reports what other gates already enforce costs a parallel agent per review and trains its reader to skim.

**The postponed refactor stopped being optional, and the fix run got written down** ([ADR-0007](docs/adr/0007-development-block-shape.md), amended). `tdd` defers refactoring to `code-review` — and the severity ladder then cancelled that: a baseline smell caps at medium, medium is fixed only on request, so the cleanup arrived at the merge as discretionary polish and "relocated, not deleted" was true of the skills and false of the process. Those findings now carry an **owed** marker beside their severity, and `wrap-up` will not merge past one. Severity still ranks urgency; it stopped deciding whether a debt the process created gets paid.

The step that applies review findings was also, until now, one sentence at the end of `review`. It is a run of its own: a fresh `implementer` brief into the ticket's existing worktree, quoting the findings and fenced to them, pointed at `tdd` where the fix changes behaviour and at the already-green suite where it does not — then the axes that raised them run again, with no cap on rounds. And a ticket review no longer asks where its fixed point is: it is the phase branch that ticket was cut from.

**Opening a PR and linking a ticket to it split owners** ([ADR-0007](docs/adr/0007-development-block-shape.md), amended). The implementer still opens the draft PR on the red-test push — it is the only thing alive in the window where a draft PR carries information. But it was also told to link the ticket back to the PR, and it cannot: Linear and Jira are MCP connectors, and the implementer holds file tools, `Bash` and `WebFetch`. The step was unexecutable on half the supported trackers and failed only at runtime. The orchestrator now does it when the report arrives, from the PR URL that report carries.

**`implement` says where the work is.** The report's job is to be the only thing that survives the run, and it did not carry the branch name or the PR link — the two things the orchestrator needs to reach the diff at all. It does now. Also: the branch is cut before the first commit rather than assumed to exist, the roadmap left the skill's reading list because reaching past the ticket is what its own scope rule forbids, the brief's paths take precedence over resolving them from the effort directory, and the verification commands are sourced where the project declares them instead of being guessed.

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
