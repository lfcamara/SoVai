#!/usr/bin/env bash
# PreToolUse hook for SoVai (matcher: Edit|Write|MultiEdit).
# On the FIRST edit of each class per session, points at the skills that should
# already be in play before the edit lands.
#
# The edited path is classified by the per-project sovai.config.json, never by a
# hardcoded stack or directory name (see hooks/lib/sovai-config.sh and ADR-0013):
#
#   production logic -> `tdd` is mandatory (ADR-0007); refactoring is deferred
#                       to `code-review`, where the tests are already green.
#   ui               -> `ui-testing` after implementation. ADR-0007 makes UI the
#                       deliberate exception.
#   test / neither / no config -> exits 0 silently.
#
# SKILL AUTHORING is checked FIRST and independently of all of the above. A file
# named SKILL.md means a skill is being authored, in any project, and that needs
# no config to know — which matters, because SoVai's own repo has no
# sovai.config.json and would otherwise be the one project this hook never fires
# in. See ADR-0018.
#
# This hook REMINDS; it does not enforce. Every output channel a PreToolUse hook
# has reaches the model, never the user, and the model holds Bash — so nothing
# here can be a constraint on the session it fires in. The reminder earns its
# place anyway: it arrives at the moment the edit is about to land, which is
# when it is cheapest to act on, and it costs one message.
#
# What actually holds a diff to ADR-0007 is `test-review` reading the tests
# against the diff, `code-review`'s owed marker, and `wrap-up` refusing to merge
# past either. Those run on evidence, by a party that is not the one being
# checked. A Stop gate used to sit beside this hook claiming to do the same job;
# it was removed because it could not (ADR-0012, amended).
#
# One sentinel per class in /tmp, keyed by session_id, purely so each message
# fires once rather than on every edit. Nothing else reads them, and nothing
# depends on them surviving.
#
# Never blocks; emits additionalContext or exits 0.

set -u

# shellcheck source=lib/sovai-config.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/sovai-config.sh"

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"' 2>/dev/null)

[ -z "$file_path" ] && exit 0

session=$(sovai_session_slug "$session_id")

# --- Skill authoring: filename alone is the signal, so no config is consulted.
if [ "$(basename "$file_path")" = "SKILL.md" ]; then
  skill_sentinel="/tmp/sovai-skill-edit-${session}"
  if [ ! -f "$skill_sentinel" ]; then
    touch "$skill_sentinel" 2>/dev/null || true
    plugin_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
    standard="$plugin_root/skills/productivity/writing-great-skills/SKILL.md"
    parent=$(basename "$(dirname "$file_path")")
    msg="About to author a skill (\`${parent}/SKILL.md\`). Read \`${standard}\` IN FULL before this edit. It is user-invoked, so no \`Skill\` call reaches it and it has to be read — and read whole, because a targeted grep returns what you already suspected. It defines predictability, the information hierarchy, when to split, pruning, leading words, and the failure modes every skill here is held to. Skipping it yields skills that read well and behave worse: a branch whose trigger is missing from the description, so the branch is unreachable; a rule steered by prohibition, which makes the banned behaviour more available; reference duplicated across files, so the meaning drifts. User instructions always outrank this."
    jq -nc --arg msg "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse",additionalContext:$msg}}'
  fi
  exit 0
fi

# Which project does this file belong to, and what shape did that project declare?
project_root=$(sovai_find_project_config "$file_path") || exit 0   # not onboarded -> no gating
rel="${file_path#"$project_root"/}"

class=$(sovai_classify_path "$project_root" "$file_path")
[ -z "$class" ] && exit 0
[ "$class" = "test" ] && exit 0

case "$class" in
  production) sentinel="/tmp/sovai-prod-edit-${session}" ;;
  ui)         sentinel="/tmp/sovai-ui-edit-${session}" ;;
  *)          exit 0 ;;
esac

already_fired=0
[ -f "$sentinel" ] && already_fired=1
touch "$sentinel" 2>/dev/null || true
[ "$already_fired" = "1" ] && exit 0

msg=""
case "$class" in
  production)
    msg="About to edit production logic (\`${rel}\`). Invoke the \`tdd\` Skill (via the Skill tool) BEFORE this edit: TDD is mandatory for backend and other non-UI logic (ADR-0007), so the failing test comes first and then only enough code to pass it. Refactoring is not part of the loop — it happens later in \`code-review\`, against green tests. If this project treats this path as UI, say so in its \`sovai.config.json\` rather than working around the reminder. User instructions always outrank this."
    ;;
  ui)
    msg="About to edit UI (\`${rel}\`). UI is the deliberate exception to mandatory TDD (ADR-0007): build the screen first, then invoke the \`ui-testing\` Skill (via the Skill tool) to cover it, deriving the test list from the effort's wireframes. Tests written first against a screen whose shape is still moving break on every layout change without catching a real defect, and a suite nobody trusts gets disabled. Do not start this edit with a test."
    ;;
esac

[ -z "$msg" ] && exit 0

jq -nc --arg msg "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse",additionalContext:$msg}}'
exit 0
