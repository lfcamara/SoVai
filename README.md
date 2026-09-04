# SoVai

**An engineering workflow for Claude Code — from a half-formed idea to merged code, with the decisions still yours.**

Coding agents are fast at writing code and careless about knowing *what* to write. Ask for a feature and you get a thousand lines and no shared understanding — nothing that says what problem this solved, why the approach was chosen, or what was deliberately left out.

SoVai is the missing process around the agent. It turns a vague idea into a PRD, a spec, wireframes, a phased roadmap, and tickets — then implements them one at a time under TDD, reviews each change five different ways, and merges only when *you* say so.

```
/plugin marketplace add lfcamara/SoVai
```

```
/plugin install sovai@sovai
```

Then, per project: copy [`sovai.config.example.json`](sovai.config.example.json) to the project root as `sovai.config.json`, and point its three lists at that project's production logic, UI, and tests. The hooks classify files by that file and nothing else, so a project without one gets no reminders — which looks a lot like a plugin that isn't doing anything.

---

## How it works

```
IDEA
 │
 ├─ brainstorm ────► shape it until the understanding is shared
 ├─ to-prd ────────► the problem, in plain language
 ├─ to-wireframes ─► every screen, then a brief you take to a design tool
 ├─ to-roadmap ────► phases that each ship something usable alone
 │
 └─ per phase, when that phase starts:
      to-spec ──────► this phase's technical decisions and test seams
      to-tickets
       │
       └─ per ticket, in parallel:
            implement → open-pr → review → wrap-up
```

Everything above `to-roadmap` runs **once**. Everything below runs **when that work actually starts** — because detail planned against a codebase that will have moved is detail you throw away.

You don't invoke any of it by name, and you don't have to start at the top. An open-ended idea enters at `brainstorm`, a feature you've already thought through enters at `to-prd`, and a change that fits in one ticket goes straight to `to-tickets` — a copy tweak shouldn't cost you a PRD.

Two things sit beside the pipeline rather than inside it. `prototype` is offered when a spec still names a question only running code can settle, never run on schedule. And `to-wireframes` ends by handing you a **design brief** — a prompt you take to Claude Design, or whatever you use — instead of drawing the screens itself; you come back with a canvas and it reconciles the record against what you actually drew. It's the one stage that stops and waits for you.

One name above isn't ours: `frontend-design` is an ambient skill the pipeline hands off to, deliberately not reimplemented here.

---

## Why this one

**It's a process, not a menu.** Most skill collections are a drawer you rummage through. Here each stage hands to the next in the same conversation, so nothing depends on you remembering what comes after what.

**The process arrives already loaded.** Every session opens with the pipeline and the delegation mandate in context, the first edit to production logic names the skill that should already be running, and editing a `SKILL.md` names the standard for writing one. Those are reminders, not locks — a hook only ever talks to the agent, so what actually holds a change to the rules is the review block, where `test-review` reads the tests against the diff and `wrap-up` won't merge past what it found. Reminders fail open: no config, no reminders, because a hook that breaks your session gets uninstalled and takes its rules with it. And the one thing no hook can see — whether a sentence claiming *done* has a real check behind it — stays a rule the agent holds while it writes: `verify-before-claiming`.

**It stops and asks you.** Facts get looked up; *decisions* get put to you, one question at a time with a recommended answer. Merging needs your explicit approval of that specific PR — reviews passing and CI green are signals you weigh, never permission the agent grants itself.

**Reviewers can't quietly fix things.** Five independent axes — code, spec, tests, security, migrations — run in parallel as read-only agents. A reviewer that patches what it finds destroys the evidence and hands you a verdict you can't audit. Findings come back ranked; critical and high are always fixed, the rest wait for your call.

**Every phase ships.** A phase that ends with work merged but nothing a user can do isn't a phase, it's a checkpoint someone drew on a plan. Each one has to survive the question: *if everything after this were cancelled tomorrow, is the user better off?*

**It gets better at your project.** Every review finding records not just what broke, but **why it wasn't prevented**. When the same cause shows up again, `harden` turns it into a rule in the skill that should have caught it. The harness learns from its own misses.

---

## What's in it

Ten blocks, 27 skills, 3 agents.

| Block | What it does |
|---|---|
| **Planning** | `brainstorm` · `to-prd` · `to-wireframes` · `to-roadmap` · `to-spec` · `to-tickets` |
| **Prototyping** | `prototype` — throwaway code answering one question, on request rather than on schedule |
| **Development** | `tdd` · `implement` · `ui-testing` · `open-pr` — red → green, one ticket at a time |
| **Review** | `review` + five axes — parallel, read-only, ranked by severity |
| **Wrap-up** | `wrap-up` — merge on your approval, then reconcile the docs against what actually shipped |
| **Debug** | `diagnose` — evidence, a reproduction loop, ranked hypotheses, a bug ticket |
| **Knowledge** | `harden` · `lint-references` — recurring review findings become skill rules, and a name that went stale stops reading live |
| **Engineering** | `verify-before-claiming` · `domain-modeling` · `grill-with-docs` — evidence before any claim of done, the vocabulary the documents are written in, and a design interview that leaves its trace (that last one you type by hand) |
| **Orchestration** | `delegate` — the six-part brief every handoff to a subagent carries |
| **Productivity** | `grilling` · `writing-great-skills` — the interview underneath `brainstorm`, and the standard every skill here is held to |

**You can ask to see the test list before any code is written.** Ask on the ticket you want it for and the implementer returns the behaviours it intends to verify — one line each — and waits. You approve the contract, not a wall of test bodies, and the loop still runs one test at a time. Every other ticket goes straight into the loop.

**TDD is mandatory for backend logic**, and refactoring deliberately isn't part of the loop — it moves to review, where the tests are already green. UI is the exception: tested after it's built, because a screen whose shape is still moving produces tests that break on every layout change without catching a real bug.

Each ticket is built in its own git worktree, on a branch off the phase's branch, so tickets on the frontier really do run in parallel and `main` takes one merge per phase.

---

## Your docs become a graph

Everything a project produces — PRDs, specs, wireframes, reviews, troubleshooting notes — lands in the repo's `docs/` folder, which doubles as an **Obsidian vault**. Notes link each other, so opening the vault shows you how a ticket traces back to the decision that caused it.

Nothing leaves the repo. It's all versioned with the code it describes.

---

## You orchestrate, agents execute

Your main session holds the decisions and the context. The actual work goes to subagents:

- **`implementer`** — writes code and verifies it
- **`reviewer`** — reads only, so findings stay findings
- **`screen-verifier`** — drives a browser against the running app, so a screen working is observed rather than inferred

Subagents start cold and can't ask questions, so every handoff carries a complete brief: the outcome, the skill to run, absolute paths, checkable done criteria, what not to touch, and what to report back. When something in the brief is ambiguous, the agent **stops and asks rather than guessing** — a plausible wrong answer arrives looking finished, and nobody re-examines it.

The test for whether to delegate: *if you can't write the brief, you don't understand the task well enough to hand it off.*

---

## Learn more

- **[engineering-workflow.md](engineering-workflow.md)** — the full process, stage by stage
- **[engineering-workflow.html](engineering-workflow.html)** — a condensed interactive view of it; the `.md` above stays the source of truth
- **[docs/adr/](docs/adr/)** — why each decision was made the way it was
- **[CHANGELOG.md](CHANGELOG.md)** — what changed in each release, and why it was worth changing

---

## Credits

Built on [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). `writing-great-skills`, `grilling`, `domain-modeling` and `tdd` are imported as-is; `prototype`, `to-tickets`, `to-spec`, `code-review` and `diagnose` are adapted. Original license in [`third_party/mattpocock-skills/LICENSE`](third_party/mattpocock-skills/LICENSE).

MIT — see [LICENSE](LICENSE).
