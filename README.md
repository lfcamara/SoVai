# SoVai

**An engineering workflow for Claude Code — from a half-formed idea to merged code, with the decisions still yours.**

Coding agents are fast at writing code and careless about knowing *what* to write. Ask for a feature and you get a thousand lines and no shared understanding — nothing that says what problem this solved, why the approach was chosen, or what was deliberately left out.

SoVai is the missing process around the agent. It turns a vague idea into a PRD, a spec, wireframes, a phased roadmap, and tickets — then implements them one at a time under TDD, reviews each change six different ways, and merges only when *you* say so.

```
/plugin marketplace add lfcamara/SoVai
```

```
/plugin install sovai@sovai
```

Then, per project: copy [`sovai.config.example.json`](sovai.config.example.json) to the project root as `sovai.config.json`, and point its three lists at that project's production logic, UI, and tests. The hooks classify files by that file and nothing else, so a project without one runs ungated — which looks a lot like a plugin that isn't doing anything.

---

## How it works

```
IDEA
 │
 ├─ brainstorm ────► shape it until the understanding is shared
 ├─ to-prd ────────► the problem, in plain language
 ├─ to-spec ───────► the technical decisions and where tests attach
 ├─ to-wireframes ─► every screen and the flows between them
 ├─ to-phases ─────► phases that each ship something usable alone
 │
 └─ per phase, when that phase starts:
      prototype → frontend-design → to-tickets
       │
       └─ per ticket, in parallel:
            implement → open-pr → review → wrap-up
```

Everything above `to-phases` runs **once**. Everything below runs **when that work actually starts** — because detail planned against a codebase that will have moved is detail you throw away.

You don't invoke any of it by name. Describe an idea and the pipeline picks it up.

One name above isn't ours: `frontend-design` is an ambient skill the pipeline hands off to, deliberately not reimplemented here.

---

## Why this one

**It's a process, not a menu.** Most skill collections are a drawer you rummage through. Here each stage hands to the next in the same conversation, so nothing depends on you remembering what comes after what.

**The rules fire on their own.** Hooks make the process deterministic rather than advisory: every session opens with the pipeline and the delegation mandate already loaded, the first edit to production logic names the skill that should already be running, and a session that changed production logic without ever entering `tdd` can't quietly end. Gates fail open — no config, no gating — because a gate that breaks your session gets uninstalled and takes its rules with it. What a hook can't see is whether a sentence claiming *done* has a real check behind it, so that one stays a rule the agent holds while it writes: `verify-before-claiming`.

**It stops and asks you.** Facts get looked up; *decisions* get put to you, one question at a time with a recommended answer. Merging needs your explicit approval of that specific PR — reviews passing and CI green are signals you weigh, never permission the agent grants itself.

**Reviewers can't quietly fix things.** Six independent axes — code, spec, tests, security, migrations, and whether the goal actually holds once it ships — run in parallel as read-only agents. A reviewer that patches what it finds destroys the evidence and hands you a verdict you can't audit. Findings come back ranked; critical and high are always fixed, the rest wait for your call.

**Every phase ships.** A phase that ends with work merged but nothing a user can do isn't a phase, it's a checkpoint someone drew on a plan. Each one has to survive the question: *if everything after this were cancelled tomorrow, is the user better off?*

**It gets better at your project.** Every review finding records not just what broke, but **why it wasn't prevented**. When the same cause shows up again, `harden` turns it into a rule in the skill that should have caught it. The harness learns from its own misses.

---

## What's in it

Ten blocks, 28 skills, 3 agents.

| Block | What it does |
|---|---|
| **Planning** | `brainstorm` · `to-prd` · `to-spec` · `to-phases` · `to-tickets` |
| **Prototyping** | `to-wireframes` · `prototype` — low-fidelity first, throwaway code second |
| **Development** | `tdd` · `implement` · `ui-testing` · `open-pr` — red → green, one ticket at a time |
| **Review** | `review` + six axes — parallel, read-only, ranked by severity |
| **Wrap-up** | `wrap-up` — merge on your approval, then reconcile the docs against what actually shipped |
| **Debug** | `diagnose` — evidence, a reproduction loop, ranked hypotheses, a bug ticket |
| **Knowledge** | `harden` · `lint-references` — recurring review findings become skill rules, and a name that went stale stops reading live |
| **Engineering** | `verify-before-claiming` · `domain-modeling` · `grill-with-docs` — evidence before any claim of done, and the vocabulary the documents are written in |
| **Orchestration** | `delegate` — the six-part brief every handoff to a subagent carries |
| **Productivity** | `grilling` · `writing-great-skills` — the interview underneath `brainstorm`, and the standard every skill here is held to |

**You can approve the test list before any code is written.** Switch it on and the implementer returns the behaviours it intends to verify — one line each — and waits. You approve the contract, not a wall of test bodies, and the loop still runs one test at a time.

**TDD is mandatory for backend logic**, and refactoring deliberately isn't part of the loop — it moves to review, where the tests are already green. UI is the exception: tested after it's built, because a screen whose shape is still moving produces tests that break on every layout change without catching a real bug.

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

## Honest status

**v1.1.0 is still unproven.** Every block is implemented and internally consistent — cross-references now checked by a linter rather than by eye, and the rules that matter enforced by hooks rather than left to the agent's discretion. But none of it has been run against a real project yet, and enforcement is not validation: a gate that fires every time still only fires on a process nobody has tested. The design is reasoned, not validated, and first contact will change it.

That's deliberate rather than careless: the feedback loop above exists precisely to absorb what real use teaches.

---

## Learn more

- **[engineering-workflow.md](engineering-workflow.md)** — the full process, stage by stage
- **[engineering-workflow.html](engineering-workflow.html)** — the same thing, interactive
- **[docs/adr/](docs/adr/)** — why each decision was made the way it was
- **[CHANGELOG.md](CHANGELOG.md)** — what changed in each release, and why it was worth changing

---

## Credits

Built on [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). `writing-great-skills`, `grilling`, `domain-modeling` and `tdd` are imported as-is; `prototype`, `to-tickets`, `to-spec`, `code-review` and `diagnose` are adapted. Original license in [`third_party/mattpocock-skills/LICENSE`](third_party/mattpocock-skills/LICENSE).

MIT — see [LICENSE](LICENSE).
