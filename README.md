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

---

## Why this one

**It's a process, not a menu.** Most skill collections are a drawer you rummage through. Here each stage hands to the next in the same conversation, so nothing depends on you remembering what comes after what.

**It stops and asks you.** Facts get looked up; *decisions* get put to you, one question at a time with a recommended answer. Merging needs your explicit approval of that specific PR — reviews passing and CI green are signals you weigh, never permission the agent grants itself.

**Reviewers can't quietly fix things.** Five independent axes — code, spec, tests, security, migrations — run in parallel as read-only agents. A reviewer that patches what it finds destroys the evidence and hands you a verdict you can't audit. Findings come back ranked; critical and high are always fixed, the rest wait for your call.

**Every phase ships.** A phase that ends with work merged but nothing a user can do isn't a phase, it's a checkpoint someone drew on a plan. Each one has to survive the question: *if everything after this were cancelled tomorrow, is the user better off?*

**It gets better at your project.** Every review finding records not just what broke, but **why it wasn't prevented**. When the same cause shows up again, `harden` turns it into a rule in the skill that should have caught it. The harness learns from its own misses.

---

## What's in it

Six blocks, 26 skills, 2 agents.

| Block | What it does |
|---|---|
| **Planning** | `brainstorm` · `to-prd` · `to-spec` · `to-phases` · `to-tickets` |
| **Prototyping** | `to-wireframes` · `prototype` — low-fidelity first, throwaway code second |
| **Development** | `tdd` · `implement` · `ui-testing` · `open-pr` — red → green, one ticket at a time |
| **Review** | `review` + five axes — parallel, read-only, ranked by severity |
| **Wrap-up** | `wrap-up` — merge on your approval, then reconcile the docs against what actually shipped |
| **Debug** | `diagnose` — evidence, a reproduction loop, ranked hypotheses, a bug ticket |
| **Knowledge** | `harden` — recurring review findings become skill rules |

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

Subagents start cold and can't ask questions, so every handoff carries a complete brief: the outcome, the skill to run, absolute paths, checkable done criteria, what not to touch, and what to report back. When something in the brief is ambiguous, the agent **stops and asks rather than guessing** — a plausible wrong answer arrives looking finished, and nobody re-examines it.

The test for whether to delegate: *if you can't write the brief, you don't understand the task well enough to hand it off.*

---

## Honest status

**v1.0.0 is unproven.** Every block is implemented and internally consistent — reference-checked, reviewed against its own standards — but none of it has been run against a real project yet. The design is reasoned, not validated, and first contact will change it.

That's deliberate rather than careless: the feedback loop above exists precisely to absorb what real use teaches.

---

## Learn more

- **[engineering-workflow.md](engineering-workflow.md)** — the full process, stage by stage
- **[engineering-workflow.html](engineering-workflow.html)** — the same thing, interactive
- **[docs/adr/](docs/adr/)** — why each decision was made the way it was

---

## Credits

Built on [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). `writing-great-skills`, `grilling`, `domain-modeling` and `tdd` are imported as-is; `prototype`, `to-tickets`, `to-spec`, `code-review` and `diagnose` are adapted. Original license in [`third_party/mattpocock-skills/LICENSE`](third_party/mattpocock-skills/LICENSE).

MIT — see [LICENSE](LICENSE).
