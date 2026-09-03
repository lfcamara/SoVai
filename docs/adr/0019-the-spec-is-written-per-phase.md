# The spec is written per phase, after the roadmap

`to-spec` runs once per phase, at the start of that phase, and writes `docs/planning/<effort>/<effort> — Phase <N> Spec.md`. It used to run once per effort, before phasing.

## The pipeline contradicted its own spine

The rule the rest of the process runs on is that detail planned against a codebase that will have moved by the time the work begins is detail that gets thrown away. It is why `to-tickets` runs per phase (ADR-0003), why `prototype` was taken out of the automatic chain (ADR-0005), and why the roadmap plans phase boundaries and stops.

The spec broke it, and broke it at the worst point. It is the most detail-dense document the pipeline produces — seams, interfaces, schema changes, API contracts — and it was written earliest, covering the widest scope, at the moment least was known. A phase starting four months after its spec was written inherited implementation decisions made against a codebase that no longer existed, which is exactly the waste every other cadence rule was written to avoid.

## The roadmap does not need a spec to draw phases

The obvious objection is that phase boundaries need to be technically informed. They are, but not by a spec. A phase is defined by what it **ships**, and the cancellation test is a product judgement applied to a user-visible capability. Coverage now walks the PRD's user stories and the wireframes' screens, which is where a phase's scope was actually coming from all along — the old "every capability in the spec's scope" was one indirection away from the same list.

What the roadmap genuinely needed from the spec was the handful of technical **forks** the sequencing depends on: build or buy, one service or two, synchronous or event-driven, migrate in place or alongside. Those are now settled in `to-roadmap` itself, before any phase is drawn, because a roadmap laid over an unmade decision reorders itself the moment the decision lands.

## The effort's architecture is ADRs, not a document

Where a fork passes the three tests in `domain-modeling`'s ADR format — hard to reverse, surprising without context, the result of a real trade-off — it becomes an ADR. That is the whole of an effort's architecture record, deliberately.

A second effort-wide technical document was the alternative and was rejected. It would have reintroduced the thing ADR-0002 spent its whole argument avoiding: two documents with overlapping ownership and a sync cost. ADRs already are the right unit — they are durable, they outlive the effort that produced them, they are shared across efforts, and they have a supersession model. An architectural decision outlives every phase it touches; implementation detail belongs to the phase that is starting. Splitting them by lifetime rather than by document is what makes both stay true.

The cost, stated plainly: an effort whose forks were never surfaced as ADRs has no architecture record at all, and nothing forces the ADR to be written. `to-roadmap` names the trigger and applies the three tests, which is as far as a skill can go — this is a judgement, and a judgement cannot be gated.

## Phase number in the filename, not in a directory

`docs/planning/<effort>/phases/01 — <name>/Spec.md` was the first sketch and is wrong. ADR-0010 makes `docs/` an Obsidian vault and is explicit that the graph shows a note's name and nothing else, so filenames carry the effort. A project with three efforts of three phases would draw nine nodes labelled "Spec", and wikilinks — which resolve by filename — would be ambiguous across all of them.

Flat and unique instead: `<effort> — Phase 2 Spec.md`. Tickets stay where they were, under the effort's own `tickets/`, since nothing about this change required moving them and their phase is already carried in a link to the roadmap heading.

## The order that results

PRD → wireframes → roadmap → **per phase:** spec → (prototype, on request) → tickets.

Everything above the roadmap runs once. Everything below runs when that phase actually starts.
