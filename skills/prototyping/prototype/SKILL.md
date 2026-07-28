---
name: prototype
description: Build a throwaway prototype to answer a design question — several UI variations to react to, or an interactive model to drive by hand. Use when the user wants to validate that an idea, a layout, or a state model actually works before committing to it, or when another skill needs a decision settled by something concrete.
---

# Prototype

A prototype is **throwaway code that answers a question**. The question decides the shape.

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## Pick a branch

Identify which question is being answered — from the user's prompt, the surrounding code, or by asking if the user is around:

- **"What should this look like, and does it work?"** → [UI.md](UI.md). Several radically different interface variations the user can flip between.
- **"Does this logic or state model feel right?"** → [LOGIC.md](LOGIC.md). A small interactive app that pushes the state model through cases that are hard to reason about on paper.

The branches produce very different artifacts, and picking wrong wastes the whole prototype. If the question is genuinely ambiguous and the user is not reachable, default to whichever fits the surrounding work — an interface or a flow leans UI, a backend module or a data model leans logic — and state the assumption at the top of the prototype.

## Rules that apply to both

1. **Throwaway from day one, and marked as such.** Where it lives depends on whether there is a codebase yet. Inside an existing project, put it next to the thing it prototypes so the context is obvious, follow the project's existing conventions, and name it so a casual reader sees immediately that it is a prototype. With no codebase yet — a project still being planned — it stands alone, and nothing about it needs to survive.

2. **One step to run.** A command through the project's existing task runner, or a link if it is a published artifact. The user must be able to open it without thinking.

3. **No persistence by default.** State lives in memory. Persistence is usually the thing being checked, not something to depend on. If the question genuinely involves storage, point at a scratch store named so nobody mistakes it for real.

4. **Skip the polish.** No tests, no abstractions, no error handling beyond what keeps it runnable. Best practices exist to make code survivable, and this code is not meant to survive — applying them spends the time the prototype was supposed to save.

5. **Surface the state.** After every action, show the full relevant state, so the user can see what changed rather than infer it.

6. **Capture it when done.** Record the answer — the verdict and the question it settled — where the work is tracked. Fold the validated decision into the real code, and keep the prototype itself as a primary source on a throwaway branch, out of main. What main keeps is the decision, never the prototype.

## Carry it forward

Once a direction is validated and the user is satisfied, the visual design is the next question. Run the `frontend-design` skill to take the validated structure to a finished design.

Then continue to the `to-tickets` skill for the work the prototype just settled.
