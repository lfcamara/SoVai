#!/usr/bin/env bash
# SessionStart hook for SoVai. Injects three things into every session, and
# nothing else: the orchestration mandate, the mandatory-invocation contract,
# and a one-line-per-block skill index.
#
# The orchestration mandate lives HERE rather than in CLAUDE.md because plugins
# do not ship CLAUDE.md — a mandate in the SoVai repo's CLAUDE.md governs work
# on SoVai itself and never loads in a consuming project, which is exactly where
# the work happens. See ADR-0012.
#
# The invocation contract is the mechanism ADR-0001 assumes: the planning
# pipeline auto-continues only if the model reliably reaches for the next skill,
# and a description alone does not make that reliable.
#
# Kept deliberately short — every line here loads into every session, and this
# is the one file in the plugin where verbosity has a permanent cost.
# Never blocks. Always exits 0.

set -u

# Pipe the literal message straight into jq (-R raw, -s slurp -> whole stdin as
# one string) to build the JSON. Avoids the heredoc-inside-$() quoting quirk.
cat <<'EOF' | jq -Rsc '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}'
SoVai engineering workflow active.

ORCHESTRATION — this session orchestrates; it does not execute. Delegate execution via the `delegate` skill: `implementer` to build, `reviewer` to check (read-only, so findings stay findings), `screen-verifier` to see whether a screen actually renders, `Explore` to find. Decisions, design, and anything needing the user stay here. A subagent starts cold and cannot ask a question, so every brief carries outcome, skill, absolute input paths, checkable done criteria, a scope fence, and what to report back. Standing rule, stated in every brief: a subagent's unsettled decisions travel back here rather than being resolved locally.

SKILLS — before acting on a request, invoke the relevant Skill (via the Skill tool) when one applies. Skills encode required process, so invoking the matching one is mandatory, not optional. User instructions always outrank skills.

ENTRY — size the request before entering the pipeline: an idea whose boundaries are still open → `brainstorm`; a feature already shaped → `to-prd`; a change that fits one ticket → `to-tickets`, or `implement` where the ticket already exists. Not every request starts at the top.

The pipeline, in order:
- Planning — brainstorm (shape a raw idea, one question at a time) → to-prd → to-wireframes → to-roadmap, then PER PHASE, when that phase starts: to-spec → to-tickets. Each stage hands to the next in the same conversation; continuing needs no named invocation. to-wireframes is the one exception: it stops at a design brief the user takes to a design tool, and resumes when they come back with a canvas. `grilling` is the interview underneath it.
- Prototyping — prototype (throwaway code answering one design question). Offered when a phase spec's Risks and unknowns names something only running code settles; never run automatically.
- Development — implement (one ticket, cold) · tdd (the red → green loop, mandatory for backend and other non-UI logic) · ui-testing (UI is the deliberate exception, tested after it is built) · open-pr (draft PR on the first push)
- Review — review dispatches five independent axes as parallel read-only subagents: code-review · spec-review · test-review · security-review · migration-review. Critical and high findings are always fixed, and so is any code-review finding marked owed — the refactor tdd postpones to that axis.
- Wrap-up — wrap-up (merge only on the user's explicit approval of that PR, then reconcile the documents against what shipped)
- Debug — diagnose (a reproduction loop before any hypothesis; ends at a bug ticket, not a fix)
- Engineering — verify-before-claiming (always on, not a stage: no claim of done, fixed or passing without the output of the check that proves it — a subagent's report included) · domain-modeling (build the project's CONTEXT.md vocabulary)
- Knowledge — lint-references (check this plugin's own cross-references resolve)
EOF
exit 0
