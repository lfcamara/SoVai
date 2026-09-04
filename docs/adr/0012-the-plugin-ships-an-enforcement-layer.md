# The plugin ships an enforcement layer, not only advice

SoVai ships hooks: a SessionStart bootstrap, a pre-edit gate on `Edit|Write|MultiEdit`, a phase tracker on `Skill`, and a Stop gate. Until they existed, every rule in the plugin was advisory — a skill the model could reach for, or not, with nothing downstream noticing the difference.

## Two decisions assumed a mechanism nobody built

[ADR-0001](0001-planning-pipeline-auto-continues-after-brainstorm.md) decides the planning pipeline auto-continues: a brainstorm recognises an idea and flows into PRD, spec, and tickets without being invoked by name at each step. That is the right shape, and it rested entirely on the model choosing the right skill at the right moment. A description is an invitation. The bootstrap converts it into a standing contract — the pipeline in order, and the explicit statement that invoking the matching skill is mandatory rather than optional — which is the mechanism ADR-0001 was written on the assumption of.

[ADR-0007](0007-development-block-shape.md) makes TDD mandatory for backend and other non-UI logic, with UI as the deliberate exception. Nothing checked it. A session could edit production logic straight through to green and never enter `tdd`, and the only cost was that no one found out. The pre-edit gate now names `tdd` on the first production edit, and the Stop gate refuses to end a session that edited production logic without ever entering it.

The Stop gate is honest about being a heuristic. It detects "TDD was never entered despite production edits", which is not proof of red before green — a session that invokes `tdd` after writing the code clears it exactly as a disciplined one does. It catches the failure that actually happens, which is TDD skipped entirely, and it carries three escape paths so the cases it gets wrong cost a line rather than a fight.

## Enforcement survives delegation, which is why it fits SoVai at all

Plugin hooks fire inside subagents, and the `session_id` in hook input is identical between the main session and every subagent it dispatches — subagents are distinguished by a separate `agent_id`. That single fact is what makes an enforcement layer compatible with the design in [ADR-0006](0006-agents-split-by-execution-mode-not-by-job-title.md), where nearly all execution leaves the session.

Because the id is shared, a session-keyed sentinel written by the pre-edit gate firing inside an `implementer` is the same file the main session's Stop gate reads when the run is over. The gate therefore sees production edits it never witnessed directly. Had the id been per-agent, the whole layer would have been decorative: the orchestrator writes almost no production code itself, so a gate that could only see the orchestrator's own edits would have gated nothing. Every sentinel is keyed on `session_id` deliberately, and the design depends on it.

## The orchestration mandate moved because CLAUDE.md does not ship

"This session orchestrates; it does not execute" is the most consequential rule in the plugin, and it was written in `CLAUDE.md`. A plugin does not ship its `CLAUDE.md`: that file governs sessions working on SoVai itself and never loads in a consuming project, which is the only place the rule has anything to govern. The mandate now lives in the SessionStart bootstrap — the delegation posture, which agent does what, and the standing rule that a subagent's unsettled decisions travel back rather than being resolved locally — so it arrives where the work happens.

The bootstrap stays short for a reason worth stating as a constraint rather than a preference: every line loads into every session, forever, and it is the one file in the plugin where verbosity has a permanent cost. It carries the mandate, the invocation contract, and one line per **block** of the pipeline. Nothing else earns a place there.

## Rejected alternatives

**Skill descriptions alone.** The cheapest option was to keep sharpening trigger phrasing and trust the model to reach for the right skill. Descriptions do real work and remain the primary route, but they are probabilistic where these two rules are not: ADR-0007 says TDD is mandatory, and a rule enforced most of the time is not the rule that was written. Nor can a description observe anything — it fires before the work and has no way to notice that the work then went the other way. A hook is the only thing in the system that can read what actually happened and refuse.

**Documentation.** The mandate could have stayed prose, in `CLAUDE.md` or `engineering-workflow.md`, on the theory that anyone using SoVai has read it. Consuming projects load neither. A rule in a document the session never opens is indistinguishable from no rule, and this is exactly how the mandate came to be unenforced in the first place.

## What was deliberately not built

No hook forces delegation. It would have been easy — count the edits the orchestrator makes and complain — and it would have been wrong. Whether to delegate is a judgement about context economy: a two-line fix costs more to brief than to make, and the test in the `delegate` skill is already the honest one, that being unable to write the **brief** means not understanding the task well enough to hand it off. Mandatory TDD is a property of the work; delegation is a property of the moment. Only the first kind belongs in a gate.

## The Stop gate is removed; the layer reminds rather than enforces

**Status: accepted, 2026-09-04.** Amends the Stop gate and the phase tracker out of this decision. The SessionStart bootstrap and the pre-edit reminder stand exactly as decided above.

The gate could not do the job it was named for, and the reason is structural rather than a defect in the script. **Every output channel a Stop hook has reaches the model and not the user** — the block `reason`, `systemMessage` (documented as "shown to Claude, not the user"), and stderr on exit 2 — and the model holds `Bash`. So any clearing condition expressed as filesystem state is writable by the party being gated. The gate's escape hatch was `touch /tmp/sovai-tdd-override-<session>`, and the only party positioned to run it was the session being stopped. A constraint the actor can lift is a request, which is precisely the reasoning [ADR-0006](0006-agents-split-by-execution-mode-not-by-job-title.md) used to make `reviewer` read-only by tool grant rather than by instruction.

Worse, it fired in the wrong place. In the designed flow a ticket reaches an `implementer` through a brief naming `implement`, and `implement` points at `tdd` — three explicit pointers, so nothing depends on the model spontaneously reaching for the skill. The gate therefore never mattered on the path the pipeline controls, and fired only on work that bypassed the pipeline: the one-line fix, the ad-hoc edit. That is exactly the population where "this did not need TDD" is most often the right answer, which is why the override existed. A gate whose exceptions are its normal case is a prompt to dismiss.

And it could not observe the thing TDD is about. Its own header admitted the limit: a session that invokes `tdd` after writing the code clears it exactly as a disciplined one does. It checked that a skill was invoked, never that a test came first.

**What actually holds a diff to [ADR-0007](0007-development-block-shape.md) was already in the plugin.** `test-review` reads the tests against the diff and asks whether they would fail on a real regression; `code-review` marks the postponed refactor **owed**; `wrap-up` refuses to merge past an unresolved critical, high or owed finding. Those run on evidence, by a party that is not the one being checked, and no `touch` clears them. They are the enforcement; the hooks were never it.

So the Stop gate and the phase tracker that fed it are gone, along with the override and the cross-hook sentinels. What survives is the pre-edit reminder, which arrives at the moment the edit is about to land — the cheapest moment to act on it — and costs one message and one fire-once marker. It is a reminder, and the hook now says so in its own header rather than claiming otherwise.

The cost, stated: a session that slid into implementation and never invoked `tdd` is no longer told so at the end. It is still told at the first edit, and the tests it did or did not write still meet `test-review`.

The claim in this ADR's opening — that the hooks convert advice into enforcement — holds for the bootstrap, which makes the pipeline's contract standing rather than optional. It does not hold for the TDD gate, and this amendment is what withdraws it.
