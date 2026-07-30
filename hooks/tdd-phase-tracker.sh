#!/usr/bin/env bash
# PreToolUse hook for SoVai (matcher: Skill).
# Marks the session as being in an active TDD cycle the moment the `tdd` skill
# is invoked, by touching a session-keyed sentinel:
#
#   /tmp/sovai-tdd-active-<session>
#
# Two hooks consume it. sovai-pre-edit-gate.sh reads it to switch production
# edits into GREEN-minimal mode, which turns the green-vs-refactor timing from a
# caveat buried in a message into deterministic state. tdd-stop-gate.sh reads it
# as the evidence that TDD was entered at all.
#
# The skill name arrives namespaced when the plugin is installed
# (`sovai:tdd`) and bare when the skill is invoked from the repo, so both match.
#
# Because hook input carries the same session_id inside a subagent, an
# `implementer` that invokes `tdd` records it for the main session's Stop gate.
#
# Never blocks. Always exits 0.

set -u

# shellcheck source=lib/sovai-config.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/sovai-config.sh"

input=$(cat)
skill=$(printf '%s' "$input" | jq -r '.tool_input.skill // empty' 2>/dev/null)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)

if printf '%s' "$skill" | grep -qE "(^|:)tdd$"; then
  session=$(sovai_session_slug "$session_id")
  touch "/tmp/sovai-tdd-active-${session}" 2>/dev/null || true
fi

exit 0
