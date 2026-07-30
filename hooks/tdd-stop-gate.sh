#!/usr/bin/env bash
# Stop hook for SoVai.
# Refuses to let a session finish when production logic was edited but the `tdd`
# skill was never invoked — the deterministic backstop for the session that slid
# straight into implementation. ADR-0007 makes TDD mandatory for backend and
# other non-UI logic; before this gate existed, nothing checked it.
#
# WHAT THIS IS: a heuristic — "TDD was never entered despite production edits".
# It is NOT proof of red-before-green ordering, and it cannot be. A session that
# invokes `tdd` after writing the code clears it just as a disciplined one does.
# It catches the failure mode that actually happens (TDD skipped entirely), and
# the override is the explicit escape hatch for everything it gets wrong.
#
# UI IS NEVER GATED HERE. ADR-0007 makes UI the deliberate exception, tested
# after implementation, so the gate reads ONLY the production sentinel. The
# ui-edit sentinel written by sovai-pre-edit-gate.sh is deliberately ignored,
# which is what lets a UI-only session end cleanly.
#
# PROJECT-SCOPED: the production sentinel is only ever written for a path a
# project's own sovai.config.json declares as production logic (see
# hooks/lib/sovai-config.sh). A project with no config never sets it and is never
# gated. No project names and no stacks are hardcoded — see ADR-0013.
#
# Signals, keyed by session and set by sibling hooks:
#   /tmp/sovai-prod-edit-<session>      production logic was edited  (sovai-pre-edit-gate.sh)
#   /tmp/sovai-tdd-active-<session>     the `tdd` skill was invoked  (tdd-phase-tracker.sh)
#   /tmp/sovai-tdd-override-<session>   a legitimate non-TDD change was recorded
#
# The session_id is identical in a subagent and its parent, so production edits
# made by an `implementer` are visible here. The gate survives delegation, which
# matters because SoVai delegates nearly all execution.

set -u

# shellcheck source=lib/sovai-config.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/sovai-config.sh"

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)
session=$(sovai_session_slug "$session_id")

prod_edit="/tmp/sovai-prod-edit-${session}"
tdd_active="/tmp/sovai-tdd-active-${session}"
override="/tmp/sovai-tdd-override-${session}"

# Nothing to gate if no production logic was edited. A UI-only session lands here.
[ -f "$prod_edit" ] || exit 0

# Clear if TDD was entered, or a legitimate-skip override was recorded.
if [ -f "$tdd_active" ] || [ -f "$override" ]; then
  exit 0
fi

reason="This session edited production logic but never invoked the \`tdd\` Skill. TDD is mandatory for backend and other non-UI logic (ADR-0007): the failing test comes first, then only enough code to pass it, and refactoring waits for \`code-review\`. UI is the deliberate exception and is not gated here. To clear this gate, do ONE of: (a) TDD genuinely happened this session — invoke the \`tdd\` Skill so it is recorded, then stop again; (b) it was skipped — go write the failing test first, watch it fail, then write the code that passes it; (c) this was legitimate non-TDD work (a typo, a pure refactor, a dependency bump, a spike) — record the override by running exactly this command, then stop again:  touch ${override}"

jq -nc --arg r "$reason" '{decision:"block", reason:$r}'
