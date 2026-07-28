---
name: code-review
description: Review how the code in a diff is written, against this repo's documented standards and a Fowler smell baseline. Use to check code quality, structure, or convention on a diff, when refactoring opportunities are wanted, or when the review skill dispatches its standards axis.
---

# Code Review

Reviews HOW the diff is written, not whether it does the right thing — that split is what `spec-review` is for. Given a diff (handed to you in a brief, or a fixed point you resolve yourself when run standalone), hold every hunk to this repo's documented standards first, then the smell baseline below.

## Repo standards first

Anything in the repo that documents how code should be written — `CODING_STANDARDS.md`, `CONTRIBUTING.md`, ADRs, linter configs that encode a house rule beyond formatting. Read what's there and cite it: a finding against a documented standard names the file and the rule.

Two rules bind everything below, including the baseline:

- **The repo overrides.** Where a documented standard endorses something the baseline would flag, the standard wins — suppress the smell.
- **Every finding is a judgement call.** Phrase smells as what they might be ("possible Feature Envy"), never as violations. A documented-standard breach can be stated as a hard breach; a baseline smell cannot.

Skip anything a linter or formatter already catches — restating tooling output is noise in a review a human has to read.

## Where refactoring lives

The `tdd` loop is deliberately red → green only; refactoring is not part of that cycle, it's relocated here. This is where the structural cleanup happens — not a step that got dropped, a step that got moved, so it runs with the tests already green and able to catch a regression immediately. Treat a smell you find here as work still owed, not as optional polish.

## The smell baseline

Fixed set of Fowler code smells (*Refactoring*, ch. 3) that applies even where the repo documents nothing. Match each against the diff — what it is, then how to fix it:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → Rename it; if no honest name comes, the design underneath is murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → Extract the shared shape, call it from both sites.
- **Feature Envy** — a method that reaches into another object's data more than its own. → Move the method onto the data it envies.
- **Data Clumps** — the same few fields or parameters keep travelling together — a type wanting to be born. → Bundle them into one type, pass that instead.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → Give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → Replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → Gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → Split it so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → Delete it; inline back until a real need shows up.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → Hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → Cut it, call the real target directly.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → Drop the inheritance, use composition.
