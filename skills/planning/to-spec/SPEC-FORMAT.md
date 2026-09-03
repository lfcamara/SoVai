# Spec Format

One spec per phase, beside the PRD and roadmap it serves, at `docs/planning/<effort>/<effort> — Phase <N> Spec.md`.

## Template

```md
# <Effort name> — Phase <N> Spec

PRD: [[<effort> — PRD]] · Phase: [[<effort> — Roadmap#Phase <N> — <name>]]

## Implementation decisions

The decisions that shape the build: modules built or changed, the interfaces that move, schema changes, API contracts, architectural choices, and the constraints behind them.

## Testing decisions

The seams the tests attach to, what gets tested through each, and prior art in the codebase to follow. Good tests describe external behaviour, so state the behaviour each seam is meant to expose.

## Risks and unknowns

What could invalidate this plan, and what is still unverified.

## Out of scope

Technical work deliberately excluded — the boundaries of this spec, distinct from the product scope the PRD sets.
```

## Rules

- **Every section, in this order.** `spec-review` holds a diff to this document and `implement` reads it cold; both find what they need by heading.
- **Scope is the phase, not the effort.** Work the roadmap gave to a later phase goes under Out of scope, named, rather than being specified early.
- **Both wikilinks are load-bearing.** The PRD edge is the only pointer from the how back to the why; the phase edge is what ties this spec to the thing it is scoped by.
- **State a decision, not a survey.** A spec that lists options without picking one hands the choice to whoever implements it, which is the one reader who has the least context to make it.
