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
 ├─ to-spec ────────────────────────► <effort> — Spec.md
 ├─ to-wireframes ──────────────────► <effort> — Wireframes.md
 ├─ to-phases ──────────────────────► <effort> — Roadmap.md
 │
 └─ PER PHASE, when that phase begins:
      │
      ├─ prototype ──── validate the interface
      ├─ frontend-design ──── settle the visual design
      ├─ to-tickets ──── break the phase into tracer bullets
      │
      └─ PER TICKET, on the frontier, in parallel:
           │
           ├─ implement ──── red → green, push
           ├─ open-pr ────── draft PR
           ├─ review ─────── five axes, parallel
           └─ wrap-up ────── merge on YOUR approval, reconcile docs
```

Everything above `to-phases` runs **once**. Everything below runs **once per phase**, at the moment that phase starts — never in advance.

That single rule is the spine of the whole process, and the reasoning is always the same: detail planned against a codebase that will have moved by the time the work begins is detail that gets thrown away.

---

## Stage 1 — Planning

### brainstorm

An idea arrives **unshaped**: you know roughly what you want and why, but not the boundaries.

The test for unshaped is concrete. Can you already say, from what was said, who it is for, where it starts and stops, and what it deliberately leaves out? If yes, it is shaped — skip ahead. If no, this stage runs.

It delegates the interview to `grilling` (one question at a time, always with a recommended answer) and `domain-modeling` (captures terms in `CONTEXT.md` and decisions in `docs/adr/` as they crystallize). Facts get looked up in the environment; **decisions get put to you**.

It ends when no open questions remain and you confirm the shared understanding — then it continues straight into the PRD, because a shaped idea whose understanding evaporates with the transcript has wasted the interview.

### to-prd → to-spec

Two documents, no overlap, because they serve different readers and change at different rates.

| | PRD | Spec |
|---|---|---|
| Audience | anyone with the problem | whoever builds it |
| Owns | problem, solution, user stories, success, out of scope | implementation decisions, testing seams, risks, technical scope |
| Test | a non-programmer reads it end to end and recognizes their own problem | — |

The PRD names the **effort** — the kebab-case directory under `docs/planning/` that everything else lives in. Every later stage resolves the effort from the filesystem, which is what lets a phase resume weeks later in a clean session.

The spec's core work is finding the **seams**: where behaviour can be observed from outside, which is where tests attach. Prefer an existing seam to a new one, and the highest available seam to a lower one. The seam gets agreed with you before the spec is written, because moving one later is expensive.

### to-wireframes

Every screen and the flows between them, at deliberately low fidelity, published as an artifact and recorded in the effort's Wireframes note.

**Fidelity is a budget.** Spend it on visuals and you buy critique of visuals — give a reviewer colour and type and they discuss colour and type, while the flow missing a step goes unmentioned. So: boxes, labels, hierarchy, real content shape, greyscale.

It sits **before** phasing because a phase is defined by what it ships, and that stays abstract until the screens have names.

Completion is checkable: every user story in the PRD reaches a screen. A story with no screen is a gap; a screen no story reaches is scope nobody asked for.

### to-phases

Breaks the effort into phases that each **ship**.

Shipping is the whole discipline. A phase ending with work merged but nothing a user can do is not a phase — it is a checkpoint someone drew on a plan.

Two tests, both applied to every phase:

- **The cancellation test.** If everything after this phase were cancelled tomorrow, is the user better off than before it existed? A phase that fails strands the project mid-migration and should be merged into whichever phase completes its value.
- **Full coverage.** Every capability in the spec lands in exactly one phase. Work in no phase surfaces late; work in two means the boundary is in the wrong place.

---

## Stage 2 — Per phase

### prototype

Throwaway code that answers one question. Two branches: several radically different UI variations to react to, or an interactive model to drive by hand.

Variants must be **structurally** different — different layout, different hierarchy, different primary affordance. Three lightly-tweaked card grids is wallpaper, not a prototype.

The rule that matters most:

> Best practices exist to make code survivable, and this code is not meant to survive — applying them spends the time the prototype was supposed to save.

No tests, no abstractions, no error handling beyond what keeps it runnable. The most useful feedback is almost always *"the header from B with the sidebar from C"* — that recombination is the actual design.

When a direction wins, `frontend-design` takes it to a finished visual design.

### to-tickets

Breaks **one phase** into tickets — tracer bullets, each cutting a narrow but complete path through every layer, each declaring what blocks it.

A ticket is sized to a single fresh context window. That sizing is not incidental: it is exactly a subagent's budget, which is what makes the ticket the unit of delegation.

Wide refactors are the exception — a mechanical change whose blast radius fans across the codebase cannot land green as a vertical slice, so it runs **expand–contract** instead: add the new form beside the old, migrate call sites in batches, delete the old form once nothing references it.

---

## Stage 3 — Per ticket

Tickets on the **frontier** — those whose blockers have all closed — can run in parallel, in isolated worktrees when their files could overlap.

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

TDD is mandatory for backend and other non-UI logic. **UI is the deliberate exception**, tested after implementation, because a screen's shape moves while it is being built and a test written against a moving shape breaks on every layout change without ever catching a real defect.

The red test is the first commit and the first push — which is what lets a draft PR exist that already states, through its failing test, what the ticket must make true.

The **implementer** opens that draft PR, not the orchestrator. The orchestrator's only channel out of a subagent is its final report, which arrives after the run is over and the work is already green — by then a draft PR says nothing the finished diff doesn't. Ticket state stays the orchestrator's, and so does the merge; a stranded ticket needs something alive to reconcile it, while a stray draft PR is visible and harmless.

Lint, build, tests and coverage run **inside** the implementer. Their output is enormous, and the subagent boundary is already the isolation: it dies with the run. Only the verdict and the failing lines travel back.

### review

Five independent axes, dispatched as parallel read-only agents:

| Axis | The question it answers |
|---|---|
| `code-review` | Is it written well? Repo standards plus 12 Fowler smells. **Where refactoring lives.** |
| `spec-review` | Is it the right thing? Missing requirements, scope creep, wrong implementations. |
| `test-review` | Would the tests fail on a real regression? |
| `security-review` | What does it expose? A finding must name a concrete path to harm. |
| `migration-review` | Reversibility, destructive operations, backfills. Failure mode here is data loss. |

`code-review` and `test-review` always run; the rest fire on a checkable test against the diff.

Findings are reported **per axis, never merged or reranked** — a change can pass one axis and fail another, and a merged list lets a clean axis bury a failing one under minor style notes.

Reviewers are read-only by construction. A reviewer that fixes what it finds destroys the evidence and returns a verdict nobody can audit.

### wrap-up

**Merge is authorized only by your explicit approval of that specific PR.** Reviews passing and CI going green are signals you weigh when approving — they are not the approval. Approving one PR says nothing about the next.

Order is load-bearing: merge → confirm it landed → tracker → documents. A ticket moved to Done ahead of a merge that then fails is a tracker asserting something false, with nothing downstream able to catch it.

Then the documents get reconciled, under one rule:

> **A document follows a decision, not a diff.**

Code diverging from the spec because someone deliberately decided otherwise means the spec is stale — update it. Code diverging because the code is *wrong* is a defect belonging to `spec-review`; rewriting the spec to match would launder a bug into a requirement, which is worse than a stale spec because it destroys the record that would have caught it.

When the last ticket in a phase merges, the phase's exit criteria are **verified against the roadmap, not inferred** from tickets closing — then the next phase gets its own `to-tickets` run.

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

Two agents, split by execution mode rather than job title — there is no "frontend developer" agent, because a role label barely changes a capable model's behaviour, while tool grants and completion criteria change everything:

- **`implementer`** — writes and verifies.
- **`reviewer`** — reads only.

The standing rule both carry: **an unsettled decision goes back, it does not get resolved locally.** A plausible wrong answer arrives looking finished and nobody re-examines it, so one round trip is always cheaper.

And what comes back is a claim, not a fact. Read the diff, not just the report — a confident summary of a broken change reads exactly like a confident summary of a working one.

---

## The vault, and the loop that feeds itself

The project's `docs/` folder **is** an Obsidian vault — a vault is just a folder of markdown, so nothing needs scaffolding and nothing moves out of the repo. Documents link each other with wikilinks, and those links are what make it a graph rather than a pile.

Filenames carry the effort — `checkout-flow — Spec.md`, not `spec.md` — because the graph shows the note's name and nothing else. Fifteen efforts would otherwise render fifteen nodes labelled "spec", which costs something to draw and returns nothing.

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

### Troubleshooting notes

When a bug fix merges, `wrap-up` writes the note — not `diagnose`, which stops at the ticket before anyone knows how the bug was actually fixed.

It carries the symptom, the root cause, the fix, the reproduction command, and what would have prevented it. Written **in the words of the symptom**, not the diagnosis: its whole value is being found again by someone hitting the same behaviour later, and the name of the root cause is precisely what that person does not yet have to search on.

## Per-project configuration

One fact cannot be discovered from a repo: the **Linear team and project** its tickets belong to. It goes in the target repo's `CLAUDE.md`, which every session already loads.

There is deliberately no setup skill — [ADR-0006](docs/adr/0006-agents-split-by-execution-mode-not-by-job-title.md) and the README explain why. A project departing from the default writes `docs/agents/issue-tracker.md` by hand.

---

## Status

Version 1.0.0. Every block implemented; **none of it has been run against a real project yet.** The design is reasoned but unvalidated, and the first real use is expected to change it. That is the plan, not an accident.
