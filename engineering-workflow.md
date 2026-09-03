# Engineering Workflow

How work moves through SoVai, from an idea someone had in the shower to code merged into main.

This document is the process. The skills are its implementation, the ADRs in [`docs/adr/`](docs/adr/) are the reasoning behind each decision, and [`CONTEXT.md`](CONTEXT.md) is the vocabulary all three share.

---

## The shape of it

```
IDEA
 │
 ├─ brainstorm ──── shape it until the understanding is shared
 │
 ├─ to-prd ─────────────────────────► <effort> — PRD.md
 ├─ to-wireframes ──────────────────► <effort> — Wireframes.md
 │                                    <effort> — Design Brief.md  ──► you, in a design tool
 ├─ to-roadmap ─────────────────────► <effort> — Roadmap.md
 │
 └─ PER PHASE, when that phase begins:
      │
      ├─ to-spec ───────► <effort> — Phase <N> Spec.md
      ├─ to-tickets ──── break the phase into tracer bullets
      │
      │  (prototype and frontend-design sit beside this, on request — see below)
      │
      └─ PER TICKET, on the frontier, in parallel:
           │
           ├─ implement ──── red → green, push
           ├─ open-pr ────── draft PR
           ├─ review ─────── six axes, parallel
           └─ wrap-up ────── merge on YOUR approval, reconcile docs
```

Everything above `to-roadmap` runs **once**. Everything below runs **once per phase**, at the moment that phase starts — never in advance.

That single rule is the spine of the whole process, and the reasoning is always the same: detail planned against a codebase that will have moved by the time the work begins is detail that gets thrown away.

None of this waits to be invoked by name, and the parts of it that matter most no longer wait to be reached for either: four hooks make them fire on their own — see [What makes it non-optional](#what-makes-it-non-optional).

**You do not have to enter at the top.** The SessionStart hook routes by size: an idea whose boundaries are still open goes to `brainstorm`, a feature already shaped goes to `to-prd` — skipping the interview, not the documents — and a change that fits in one ticket goes to `to-tickets`, or straight to `implement` where the ticket exists. A pipeline that can only be entered at the top is a pipeline people stop entering, and a PRD for a copy change is a PRD nobody reads.

**One stage stops and waits for you.** `to-wireframes` ends by writing a design brief rather than drawing the screens itself; you take it to a design tool and come back with a canvas, which it reconciles the record against. Every other stage hands to the next in the same conversation.

---

## Stage 1 — Planning

### brainstorm

An idea arrives **unshaped**: you know roughly what you want and why, but not the boundaries.

The test for unshaped is concrete. Can you already say, from what was said, who it is for, where it starts and stops, and what it deliberately leaves out? If yes, it is shaped — skip ahead. If no, this stage runs.

It delegates the interview to `grilling` (one question at a time, always with a recommended answer) and `domain-modeling` (captures terms in `CONTEXT.md` and decisions in `docs/adr/` as they crystallize). Facts get looked up in the environment; **decisions get put to you**.

It ends when no open questions remain and you confirm the shared understanding — then it continues straight into the PRD, because a shaped idea whose understanding evaporates with the transcript has wasted the interview.

### to-prd

Two planning documents, no overlap, because they serve different readers and change at different rates — and, since the spec moved below the roadmap, at different grains. The PRD covers the effort; a spec covers one phase.

| | PRD | Spec |
|---|---|---|
| Audience | anyone with the problem | whoever builds it |
| Owns | problem, solution, user stories, success, out of scope | implementation decisions, testing seams, risks, technical scope |
| Test | a non-programmer reads it end to end and recognizes their own problem | — |

The PRD names the **effort** — the kebab-case directory under `docs/planning/` that everything else lives in. Every later stage resolves the effort from the filesystem, which is what lets a phase resume weeks later in a clean session.

The spec is described under [Stage 2](#stage-2--per-phase), where it now runs.

### to-wireframes

Every screen and the flows between them, at deliberately low fidelity, recorded in the effort's Wireframes note and handed to you as a design brief.

**Fidelity is a budget.** Spend it on visuals and you buy critique of visuals — give a reviewer colour and type and they discuss colour and type, while the flow missing a step goes unmentioned. So: boxes, labels, hierarchy, real content shape, greyscale.

It sits **before** phasing because a phase is defined by what it ships, and that stays abstract until the screens have names.

Completion is checkable: every user story in the PRD reaches a screen. A story with no screen is a gap; a screen no story reaches is scope nobody asked for.

**It hands off rather than renders.** Alongside the record it writes `<effort> — Design Brief.md`, which is not a document about the design but the prompt itself — addressed to a design tool, carrying the fidelity constraints, the platform proportions, and one block per screen. You take it to Claude Design or whatever you use.

The plugin does not invoke that tool. A design tool is someone else's skill or someone else's product, and hard-wiring one would make the most visual stage of the pipeline its most fragile; you are also the one who will move things by hand once you are in there. The record stays the source of truth, so the brief is regenerable from it and the canvas from the brief.

The cost is a genuine stop — the only planning stage that does not continue on its own. Wireframes exist to surface the missing step and the screen that turns out to be two, and that reaction now happens outside the session, so the skill has a second entrance: you come back with a canvas and it reconciles the record, the flow, and the coverage table against what you actually drew, before `to-roadmap` runs on it.

### to-roadmap

Breaks the effort into phases that each **ship**.

Shipping is the whole discipline. A phase ending with work merged but nothing a user can do is not a phase — it is a checkpoint someone drew on a plan.

Two tests, both applied to every phase:

- **The cancellation test.** If everything after this phase were cancelled tomorrow, is the user better off than before it existed? A phase that fails strands the project mid-migration and should be merged into whichever phase completes its value.
- **Full coverage.** Every capability in the spec lands in exactly one phase. Work in no phase surfaces late; work in two means the boundary is in the wrong place.

It is named for the document it writes, like every other stage in the block. "Phase" stays the unit inside that document. There is deliberately no separate epic stage: an epic is a tracker's word for the same thing, and mapping a phase onto one is a publishing concern that `to-tickets` already handles.

---

## Stage 2 — Per phase

### to-spec

The engineering half of the plan, scoped to **one phase** and written when that phase starts.

It used to run once per effort, before phasing — and that contradicted the rule the rest of the pipeline runs on. The spec is the most detail-dense document here (seams, interfaces, schema, contracts), so writing one for the whole effort up front spent the most detail at the moment least was known, and a phase starting four months later inherited decisions made against a codebase that no longer existed ([ADR-0019](docs/adr/0019-the-spec-is-written-per-phase.md)).

Its core work is finding the **seams**: where behaviour can be observed from outside, which is where tests attach. Prefer an existing seam to a new one, and the highest available seam to a lower one. The seam gets agreed with you before the spec is written, because moving one later is expensive.

Scope is the phase. Work the roadmap gave to a later phase goes under Out of scope by name, rather than being specified early.

**An effort's architecture is not in here.** The technical **forks** that sequencing depends on — build or buy, one service or two, migrate in place or alongside — are settled during `to-roadmap`, before any phase is drawn, and recorded as ADRs where they are hard to reverse. That split is by lifetime: an architectural decision outlives every phase it touches, implementation detail belongs to the phase that is starting. The cost is stated plainly in the ADR — nothing forces the record to be written, because it is a judgement and a judgement cannot be gated.

### prototype — on request, not on schedule

Throwaway code that answers one question. Two branches: several radically different UI variations to react to, or an interactive model to drive by hand.

**It is not a link in the chain.** A phase reaching this point has a PRD, wireframes, a spec and a roadmap behind it, and most arrive with nothing open — a prototype built anyway spends a session answering a question nobody asked. So `to-roadmap` goes straight to `to-tickets` and *offers* this instead, with a trigger rather than a mood: the spec's **Risks and unknowns** section is where an open question is already written down, and the offer is made only when something there needs running code to settle.

Variants must be **structurally** different — different layout, different hierarchy, different primary affordance. Three lightly-tweaked card grids is wallpaper, not a prototype.

The rule that matters most:

> Best practices exist to make code survivable, and this code is not meant to survive — applying them spends the time the prototype was supposed to save.

No tests, no abstractions, no error handling beyond what keeps it runnable. The most useful feedback is almost always *"the header from B with the sidebar from C"* — that recombination is the actual design.

When a direction wins, `frontend-design` takes it to a finished visual design. That skill is **ambient — this plugin deliberately does not own it** ([ADR-0005](docs/adr/0005-wireframes-precede-phasing-prototypes-follow-it.md)), so it stays whatever the environment provides rather than a vendored copy that drifts. It is the one stage in the pipeline SoVai names without shipping.

### to-tickets

Breaks **one phase** into tickets — tracer bullets, each cutting a narrow but complete path through every layer, each declaring what blocks it.

A ticket is sized to a single fresh context window. That sizing is not incidental: it is exactly a subagent's budget, which is what makes the ticket the unit of delegation.

Wide refactors are the exception — a mechanical change whose blast radius fans across the codebase cannot land green as a vertical slice, so it runs **expand–contract** instead: add the new form beside the old, migrate call sites in batches, delete the old form once nothing references it.

Publishing ends by **cutting the branch the phase will land on** — `phase/<effort>-<NN>`, cut from `main` and pushed. Every ticket in the phase branches from it, and it reaches `main` as a single merge when the phase closes, because the phase is the unit that ships ([ADR-0020](docs/adr/0020-work-lands-on-a-phase-branch-through-worktrees.md)). The same run confirms `worktrees/` is in the project's `.gitignore` before any ticket is dispatched: each one is worked in a worktree under that directory, and an unignored one turns every search in the project into duplicate hits across N copies of the tree.

---

## Stage 3 — Per ticket

Tickets on the **frontier** — those whose blockers have all closed — run in parallel, each in **its own git worktree** at `<project root>/worktrees/<TICKET-ID>-<slug>`. That is not a precaution taken when files might overlap; it is what makes the parallelism executable at all. Two implementers sharing one checkout share a HEAD, and the second one's first commit lands on the first one's branch ([ADR-0020](docs/adr/0020-work-lands-on-a-phase-branch-through-worktrees.md)).

A ticket's branch is cut from the **phase branch**, and its PR targets that branch rather than `main`. A fresh worktree holds tracked files and nothing else — no `.env`, no `node_modules` — so the project lists the commands that make one runnable under `worktreeSetup` in its `sovai.config.json`, and `delegate` runs them before dispatching an implementer in.

### The ticket lifecycle

| State | Set by | When |
|---|---|---|
| To Do | — | on the frontier, unclaimed |
| Doing | orchestrator | dispatching the implementer |
| Testing | orchestrator | implementer reported done; reviews dispatched |
| Done | orchestrator | reviews passed and the PR merged |

**Every transition belongs to the orchestrator.** Two reasons: a subagent that dies mid-task would leave its ticket stranded with nothing alive to reconcile it, and an implementer marking its own work Done bypasses the Testing state that exists to have something else validate first.

### implement

One ticket, from a cold context window to a pushed, verified branch.

**TDD is red → green.** The failing test first, then the code that satisfies it. Refactoring is not part of the loop — it is relocated to review, where the tests are already green and the code is free to move. Relocated, not deleted: the structural cleanup is still owed.

**You can ask to see the test list first.** Tests are the behaviour contract at its finest grain, so a wrong one produces correct code implementing the wrong thing — cheap to catch now, expensive once the implementation exists. Tickets go straight into the loop by default; ask on the ticket in front of you and `to-tickets` carries it into that brief, so the implementer returns a list of the behaviours it intends to verify, one line each, and stops until you approve. There is deliberately no setting behind it: a question asked every time becomes a prompt to dismiss, and an answer stored once becomes a config line nobody revisits when it changes ([ADR-0011](docs/adr/0011-the-test-list-is-approved-not-the-tests.md)).

What you approve is the *list*, never a set of written tests. Writing them all up front is the horizontal slicing `tdd` warns against, and the full set isn't knowable anyway — the third cycle's test comes from what the second one exposed. Cases the loop discovers later get reported rather than suppressed for sitting outside the list.

TDD is mandatory for backend and other non-UI logic. **UI is the deliberate exception**, tested after implementation, because a screen's shape moves while it is being built and a test written against a moving shape breaks on every layout change without ever catching a real defect. `ui-testing` covers the screen once it exists, deriving its test list from the effort's wireframes.

A component test passing and the screen working are **independent facts**, and until `screen-verifier` existed nothing here established the second one — every claim about an interface was inferred from source. That agent drives a browser against the running app and reports what it observed, with the artifacts behind it: the screenshot, the entry point it actually loaded, the console and network output. Where no browser tooling is reachable it returns an honest **UNVERIFIED** and names what stopped it, because reading the source and reasoning about what it would render is the assertion it exists to replace.

The red test is the first commit and the first push — which is what lets a draft PR exist that already states, through its failing test, what the ticket must make true.

The **implementer** opens that draft PR, not the orchestrator. The orchestrator's only channel out of a subagent is its final report, which arrives after the run is over and the work is already green — by then a draft PR says nothing the finished diff doesn't. Ticket state stays the orchestrator's, and so does the merge; a stranded ticket needs something alive to reconcile it, while a stray draft PR is visible and harmless.

The **ticket's link back to the PR** is the orchestrator's, though, split off by capability rather than by preference: reaching Linear or Jira takes MCP connectors the implementer does not hold, so left with it the step is silently unexecutable on half the supported trackers. It runs when the report arrives, from the PR URL that report carries ([ADR-0007](docs/adr/0007-development-block-shape.md)).

Before any of that is reported, the branch **rebases on the phase branch**, so what gets verified is what the phase will actually hold. Lint, build, tests and coverage run **inside** the implementer. Their output is enormous, and the subagent boundary is already the isolation: it dies with the run. Only the verdict and the failing lines travel back — which is the compressed form of the evidence `verify-before-claiming` requires, not an exemption from it.

### review

Six independent axes, dispatched as parallel read-only agents:

| Axis | The question it answers |
|---|---|
| `code-review` | Is it written well? Repo standards plus 12 Fowler smells. **Where refactoring lives.** |
| `spec-review` | Is it the right thing? Missing requirements, scope creep, wrong implementations. |
| `test-review` | Would the tests fail on a real regression? |
| `security-review` | What does it expose? A finding must name a concrete path to harm. |
| `migration-review` | Reversibility, destructive operations, backfills. Failure mode here is data loss. |
| `goal-review` | Does the outcome hold? Merged, switched on, delivered in full — not merely built well. |

`code-review` and `test-review` always run; the rest fire on a checkable test — `spec-review`, `security-review` and `migration-review` against the diff, `goal-review` against what the diff cannot contain.

That last one closes a structural gap rather than a thoroughness one. The other five all judge the diff, and a diff looks identical whether the change was merged, held behind a flag still switched off, or two thirds of its ticket. Well written, on spec, well tested and inert is the false-done nothing else on the run can see.

Its selection rule needs stating, because it is the subtle part. It runs when **both** references exist: a ticket naming the outcome, and a pull request whose state can be read. Neither is in the working tree, and a verdict reached without them is a guess in a finding's clothes.

Mid-ticket it still runs. `implement` opens the draft PR on the red-test push, so a PR almost always exists by review time — and *not merged* is then the **expected** state, where reporting it as a problem is pure noise, and an axis trained away as noise has stopped working. Gating the whole axis on a claim of done would have been the easy answer and the wrong one: it discards the two sub-checks that are most actionable exactly then, scope quietly deferred and a flag shipped switched off. So the noise is suppressed one level down instead. The axis reports four states — merged, enforced, scope covered, tracker consistent — as **facts**, whatever they say; a fact becomes a **finding** only where it contradicts a claim that the work is done.

Findings are reported **per axis, never merged or reranked** — a change can pass one axis and fail another, and a merged list lets a clean axis bury a failing one under minor style notes.

Reviewers are read-only by construction. A reviewer that fixes what it finds destroys the evidence and returns a verdict nobody can audit.

### wrap-up

**Merge is authorized only by your explicit approval of that specific PR.** Reviews passing and CI going green are signals you weigh when approving — they are not the approval. Approving one PR says nothing about the next.

Order is load-bearing: merge → confirm it landed → tracker → documents. A ticket moved to Done ahead of a merge that then fails is a tracker asserting something false, with nothing downstream able to catch it.

The ticket's **worktree and branch are retired** on the same ordering — after the merge is confirmed, never ahead of it, and **never forced**. A worktree holding uncommitted changes, or a branch holding commits the merge did not carry, is work the merge left behind: a fact to report, not a directory to delete. Nothing is lost by a worktree that outlives its ticket.

Then the documents get reconciled, under one rule:

> **A document follows a decision, not a diff.**

Code diverging from the spec because someone deliberately decided otherwise means the spec is stale — update it. Code diverging because the code is *wrong* is a defect belonging to `spec-review`; rewriting the spec to match would launder a bug into a requirement, which is worse than a stale spec because it destroys the record that would have caught it.

When the last ticket in a phase merges, the phase's exit criteria are **verified against the roadmap, not inferred** from tickets closing. Only once they hold does the phase branch go to `main`, as a pull request of its own carrying **its own explicit approval** — approving the tickets said nothing about shipping the phase, and this is the merge where a user first meets the capability whole ([ADR-0020](docs/adr/0020-work-lands-on-a-phase-branch-through-worktrees.md)). Until then the phase branch integrates `main` whenever `main` moves, or the final merge becomes the one conflict every ticket avoided. With the phase merged, the next phase gets its own `to-tickets` run.

---

## Debug

A bug does not get a special path. It gets diagnosed, and the diagnosis produces a ticket that enters the normal flow.

1. **Evidence.** Get an instance of the bug, preferring to go and get it — read the database, drive the browser, read the logs — over accepting the report. A reported symptom is a secondhand account.
2. **Build the feedback loop.** *This is the skill.* One command, already run once, that is red-capable, deterministic, fast and agent-runnable. Reaching for a hypothesis before that command exists is the exact failure the discipline prevents.
3. **Reproduce and minimise.** Cut until every remaining element is load-bearing.
4. **Hypothesise.** Three to five, ranked, each falsifiable with a stated prediction. A hypothesis with no prediction is a vibe.
5. **Test them in parallel.** One hypothesis per agent — they are independent by construction, and one agent testing several in sequence anchors on whichever it tried first.
6. **File the ticket.** Evidence, the reproduction command, the minimised repro, the confirmed root cause, the seam analysis, and what would have prevented the bug.

The fix is then `implement` → `review` → `wrap-up`, like anything else. One path for all code, and the diagnosis survives on the ticket instead of dying with the session.

---

## How delegation works

The main session **orchestrates** on Opus and holds the decisions. Execution goes to Sonnet subagents.

A subagent starts **cold** — none of the conversation reaches it — and it cannot ask a question. So the **brief** carries six things:

| | | |
|---|---|---|
| **Outcome** | what is true when this is done | *makes the work possible* |
| **Skill** | which skill to run, by name | |
| **Inputs** | absolute paths, and facts it cannot look up | |
| **Done** | checkable criteria, with the command that proves them | *makes it safe* |
| **Fence** | what it must not touch | |
| **Report** | the specific facts to return | |

The test for whether to delegate is the brief itself: **if you cannot write the brief, you do not understand the task well enough to delegate it.**

Three agents, split by execution mode rather than job title — there is no "frontend developer" agent, because a role label barely changes a capable model's behaviour, while tool grants and completion criteria change everything:

- **`implementer`** — writes and verifies.
- **`reviewer`** — reads only.
- **`screen-verifier`** — observes a running system through a browser, and fixes nothing.

The third sits **on** that axis rather than across it: "observes a running system" is a third execution mode beside writes and reads-only, where "frontend developer" is a person ([ADR-0016](docs/adr/0016-screen-verification-is-a-third-agent.md)). Widening `reviewer`'s grant instead was the leading alternative and was rejected: all six axes would inherit a browser none of them uses, and — the deciding objection — **a browser can click.** An agent able to submit a form or press a delete control is not read-only against the running system, however read-only it stays against the repo, and that guarantee is what makes a reviewer's findings auditable.

The trade is stated rather than hidden. No fixed tool allowlist can name browser tooling whose names vary by environment, so `screen-verifier` holds a full grant and carries the constraint in writing: it is read-only by discipline where `reviewer` is read-only by construction.

Two standing rules all three carry, and every brief repeats. **An unsettled decision goes back, it does not get resolved locally** — a plausible wrong answer arrives looking finished and nobody re-examines it, so one round trip is always cheaper. And **the report is bound by `verify-before-claiming`** — done means each criterion was checked against a run, with the output that settles it travelling alongside the claim.

And what comes back is a claim, not a fact. Read the diff, not just the report — a confident summary of a broken change reads exactly like a confident summary of a working one.

---

## What makes it non-optional

Everything above describes a process. Until this layer existed, all of it was **advisory** — a skill the model could reach for, or not, with nothing downstream noticing the difference. Two of the plugin's own decisions turned out to assume a mechanism nobody had built: that the planning pipeline auto-continues, which rested entirely on the model choosing the right skill at the right moment, and that TDD is mandatory for non-UI logic, which nothing checked ([ADR-0012](docs/adr/0012-the-plugin-ships-an-enforcement-layer.md)).

Four hooks now do. What a given file *is* — production logic, UI, or test — is never guessed by the plugin: it comes from the project's own config, described under [Per-project configuration](#per-project-configuration), and a project without that file is not gated at all. One check is deliberately exempt from that rule, and it is the next paragraph.

**SessionStart — the bootstrap.** It injects three things and nothing else: the orchestration mandate, the statement that invoking the matching skill is mandatory rather than optional, and one line per block of the pipeline. The mandate lives *here* rather than in a `CLAUDE.md`, because **a plugin does not ship its `CLAUDE.md`** — that file governs sessions working on SoVai itself and never loads in a consuming project, which is the only place the rule has anything to govern. The bootstrap is also the one file in the plugin where verbosity has a permanent cost, since every line loads into every session forever, so its brevity is a constraint rather than a preference.

**The pre-edit gate** fires on the first edit of each class per session. A production-logic path is pointed at `tdd` *before* the edit lands. A UI path is pointed at `ui-testing` instead, to run once the screen is built, and told explicitly not to open with a test.

It also has one branch that consults no config: editing a file named `SKILL.md` points at `writing-great-skills`, to be read in full before the edit ([ADR-0018](docs/adr/0018-skill-authoring-is-gated-by-filename.md)). The filename alone is the signal, which is the point — SoVai's own repo has no `sovai.config.json`, having no production logic to gate, so a config-driven version of this check would fire everywhere except the repo where skills are actually written. The instruction it enforces already existed in prose and had already been skipped once, which is the same argument that produced this whole layer.

**The phase tracker** records that `tdd` was entered, and two hooks read that record. The pre-edit gate uses it to switch a production edit into Green-minimal: telling a session mid-Green to go and fetch a skill it is already running pollutes Green with exactly the work `tdd` defers to `code-review`. The Stop gate uses it as the evidence that TDD happened at all.

**The Stop gate** refuses to end a session that edited production logic without ever invoking `tdd`. It is honest about being a heuristic — it detects TDD skipped entirely, never red-before-green ordering, which nothing observable at the end of a session can establish. **UI is never gated here**: [ADR-0007](docs/adr/0007-development-block-shape.md) makes it the deliberate exception, so the gate reads only the production signal and a UI-only session ends clean. Three escape paths, so the cases it gets wrong cost a line rather than a fight — invoke `tdd` to record that it genuinely happened, go and write the failing test, or record a per-session override for legitimate non-TDD work (a typo, a pure refactor, a dependency bump, a spike). The gate prints the exact override command rather than describing it.

### Enforcement survives delegation

This is the fact the whole layer rests on. Plugin hooks fire **inside subagents**, and the session id in hook input is identical in a subagent and in the session that dispatched it — subagents are told apart by a separate agent id. Every signal these hooks write is keyed on the session id, so a production edit made inside an `implementer` writes the same file the main session's Stop gate reads once that run is over. The gate sees edits it never witnessed.

Had the id been per-agent, the layer would have been decorative. The orchestrator writes almost no production code itself, so a gate able to see only the orchestrator's own edits would have gated nothing. That one property is what makes enforcement fit the orchestrate-don't-execute design rather than sit in tension with it.

### What was deliberately not built

**No hook forces delegation.** Counting the orchestrator's own edits and complaining would have been easy, and wrong. Mandatory TDD is a property of the work; whether to delegate is a judgement about context economy, and a two-line fix costs more to brief than to make. The honest test is the one stated above — being unable to write the brief means not understanding the task well enough to hand it off. Only the first kind of rule belongs in a gate.

### Evidence before the claim

A hook can observe that an edit happened, that a skill was entered, that a session is ending. It cannot observe whether the sentence about to be written carries evidence — and the failure that matters most here is not an unrun command but a report asserting more than its run supports, or with no run behind it at all ([ADR-0014](docs/adr/0014-completion-is-gated-globally.md)).

So that one is a rule the model holds while it writes. `verify-before-claiming` binds every *done*, *fixed*, *passing* and *working* — in a report, a commit message, a PR body, a sentence to you — and binds a subagent exactly as it binds the orchestrator: run the check that would contradict the claim, show what it said, and where no command stands behind a claim, name what you could not verify.

That binding travels rather than being assumed. `delegate` states it as a standing rule in every brief, which is the only thing a cold subagent certainly reads, and each agent definition names the skill that owns the standard instead of restating it — so the standard has one owner, and sharpening it stays one edit rather than four that have to agree.

It is one always-on rule rather than a criterion inside each skill, because a rule living in a skill is silent for precisely the runs where no skill was invoked — the quick fix, the ad-hoc edit, the question that turned into a change — which are the runs where an unverified *done* is likeliest. It reconciles with the rule that keeps verification inside the subagent: the output is required **where the check ran**, and only the compressed form crosses the boundary — the command, its result, and the lines that failed. A verdict with nothing behind it never qualified as either.

---

## The vault, and the loop that feeds itself

The project's `docs/` folder **is** an Obsidian vault — a vault is just a folder of markdown, so nothing needs scaffolding and nothing moves out of the repo. Documents link each other with wikilinks, and those links are what make it a graph rather than a pile.

Filenames carry the effort — `checkout-flow — Phase 1 Spec.md`, not `spec.md` — because the graph shows the note's name and nothing else. Fifteen efforts would otherwise render fifteen nodes labelled "spec", which costs something to draw and returns nothing. It is also why a phase's number sits in the filename rather than in a directory above it.

Links are spent, not sprayed: a ticket to its phase, a spec to the PRD it serves. Linking everything a document touches produces a graph as useless as none.

### Severity decides obligation

Review findings are ranked by the axis that found them, because severity depends on what that axis knows:

| | |
|---|---|
| **critical** | data loss, a security breach, or a broken production path |
| **high** | incorrect behaviour a user meets, or a broken guarantee the code claims |
| **medium** | a real defect with bounded blast radius, or a standard breach that costs later |
| **low** | worth fixing, cheap to leave |

**Critical and high are always fixed** — `wrap-up` will not merge with either unresolved, no matter how firmly the PR was approved. **Medium and low are fixed only when you say so.** The boundary between high and medium is the one that carries weight: it is where a fix stops being optional.

### Every finding records why it was not prevented

A finding is a defect caught. A **cause** that repeats is a hole in the process — and the two are not the same thing.

So each finding carries a short cause, and the review record persists in the vault. This is the one part of the loop that cannot be reconstructed later: without a written cause in a form later reviews can be matched against, recurrence is invisible and the vault accumulates incidents instead of lessons.

Causes name the gap — *"the spec never said which seam"*, *"no rule in code-review covers this"* — not the moment or the person. A cause phrased as "missed it" is unmatchable and unfixable.

### harden turns recurrence into a rule

`harden` reads accumulated review records, groups findings **by cause rather than symptom** — two findings that look unrelated can share one hole — weights the clusters by severity, and amends whichever skill should have prevented the defect.

Picking the owner uses one test: *what single artifact, present when the defect was introduced, would have stopped it?* A missing axis rule points at the axis; a loose completion criterion points at the skill that let it pass as done; a permitted action points at the agent definition.

The amendment **competes with what is already there**. Where an existing rule was almost right, it gets sharpened rather than joined by a second one nearby — a rule added per incident is exactly the sediment `writing-great-skills` warns against, and is how the original rule stayed weak enough to miss this in the first place.

It runs periodically, never per review — one occurrence is not a pattern. It runs in the SoVai repo, where the skills live, reading vaults from whichever projects you point it at: a cause appearing once in each of three projects is invisible from inside any one of them, and that is the pattern most worth catching. And it **proposes rather than applies**, because a skill change alters every future run.

### lint-references checks the plugin still holds together

`harden` amends the plugin from what reviews found. `lint-references` checks that what came out the other side still resolves.

This plugin's cross-references are almost entirely **bare names in backticks** — `review` naming its axes, `wrap-up` naming `to-tickets`, an ADR citing an agent — and nothing reads them back: not the filesystem, not Claude Code, not any other tool. A rename leaves the old name sitting in prose, reading exactly as live as the day it worked. A dead one raises no error. It silently does not happen, in a session belonging to someone who has no way to know the reference was ever meant to resolve, and who reasonably concludes the plugin does not work rather than that one name went stale.

Five checks: bare skill and agent names, the manifest's declared paths, the reverse direction (on disk but undeclared, which never loads), relative markdown links, and the hook wiring. It fails loud on a plugin root with no skills under it and on a run that checked zero references, because a linter that scans nothing must never print clean. Names that were never ours to resolve — a skill the environment supplies, an alternative an ADR rejected — sit in an allowlist with the reason each is exempt.

It runs after any rename in the plugin tree, and as step 2 of cutting a release, which is the last moment a dead reference is cheap to catch ([ADR-0017](docs/adr/0017-release-discipline.md)). Each release, and the reasoning that made it worth cutting, is in [CHANGELOG.md](CHANGELOG.md).

### Troubleshooting notes

When a bug fix merges, `wrap-up` writes the note — not `diagnose`, which stops at the ticket before anyone knows how the bug was actually fixed.

It carries the symptom, the root cause, the fix, the reproduction command, and what would have prevented it. Written **in the words of the symptom**, not the diagnosis: its whole value is being found again by someone hitting the same behaviour later, and the name of the root cause is precisely what that person does not yet have to search on.

---

## Per-project configuration

Three facts cannot be discovered from a repo.

**Where its tickets go.** In `sovai.config.json`, under a `"tracker"` key: which tracker, whatever fields that tracker needs to name a destination, and whether phases become parent issues. It used to be split across `docs/agents/issue-tracker.md` and the target repo's `CLAUDE.md` while the config file that already sits at the project root held neither — a fact with three possible homes gets written in a fourth and found in none ([ADR-0004](docs/adr/0004-planning-documents-live-in-the-repo-tickets-in-the-tracker.md)). `docs/agents/issue-tracker.md` survives for house conventions in prose, refining the config rather than competing with it.

**There is no default tracker.** Guessing one means publishing into somebody's wrong project or failing against a service that was never connected, and both read as the plugin being broken rather than as one missing line of config. Absent the key, `to-tickets` asks once and offers to write the answer; with nobody to ask, it falls to local markdown — one file per ticket — and says so plainly. That floor always works, and the cost of staying on it is that `wrap-up` has no Done to move a ticket to, which it now states rather than glossing. Per-tracker mechanics live in `TRACKERS.md` beside the skill; adding a tracker is a section there, never a branch in the skill.

**What makes a fresh checkout runnable.** A git worktree materializes tracked files and nothing else, so the `.env`, the `node_modules` and the build cache a project keeps out of git are all missing the moment a ticket's worktree is created — and an implementer dispatched into one would fail on a missing dependency and report a broken project. Only the project knows what to put back, so it lists those commands under `worktreeSetup` in the same file, and `delegate` runs them after creating the worktree and before dispatching in ([ADR-0020](docs/adr/0020-work-lands-on-a-phase-branch-through-worktrees.md)). Declaring nothing gets a bare checkout, which is correct for a project that needs nothing.

**What a file is.** Which paths hold production logic, which hold UI, which hold tests. This is the fact the hooks run on, and it lives in a `sovai.config.json` at the project root, found by walking up from the edited file ([ADR-0013](docs/adr/0013-per-project-config-resolved-by-walking-up.md)):

```json
{
  "productionLogic": ["src/**", "lib/**"],
  "ui":              ["src/components/**", "src/screens/**", "src/app/**"],
  "tests":           ["*.test.*", "*.spec.*", "test/**", "tests/**", "*__tests__*"],
  "tracker":         { "kind": "local", "team": "", "project": "", "phasesAsParents": false },
  "worktreeSetup":   ["cp ../../.env .env", "cp -c -R ../../node_modules node_modules"]
}
```

Three lists of shell globs, not a stack enum. A stack name would only add a mapping that breaks on the first monorepo, and what the gates need is the classification itself: `src/components` is UI in one project and a component library dense with logic in the next, and the only party that knows is the project. Precedence runs tests, then ui, then productionLogic, so a UI path nested under a production path wins and nobody writes exclusions.

The `"tracker"` and `"worktreeSetup"` keys are the parts of this file read by skills rather than by the hooks; they live here because a project should have one place that answers "what is this project", not three.

Onboarding is therefore a one-file drop — copy `sovai.config.example.json` to the project root, rename it, edit the three lists, the tracker and whatever a fresh worktree needs to run — never a change to this plugin. Because the file sits at the root and is found by ancestry, worktrees and clones inherit it for free.

**Everything fails open, and the consequence is worth stating plainly: a project with no `sovai.config.json` is not gated.** No config, or a malformed one, classifies nothing — no reminders, and a Stop gate that never fires. A reader who skips this section gets a plugin that appears to do nothing. The direction is chosen rather than incidental: under-gating costs a missed reminder, while over-gating costs a developer who cannot finish a session, and a hook that breaks work over its own configuration gets uninstalled, taking every rule it was carrying with it.

---

## Status

Every block implemented, and the rules that carry the most weight now fire on their own instead of waiting to be reached for. The current version is the one in [`plugin.json`](.claude-plugin/plugin.json); what each release changed, and why it was worth changing, is in [CHANGELOG.md](CHANGELOG.md).

**Enforcement is not validation.** A hook makes a stated rule deterministic; it says nothing about whether the rule was right. **None of this has been run against a real project yet.** The design is reasoned but unvalidated, and the first real use is expected to change it. That is the plan, not an accident.
