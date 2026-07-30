#!/usr/bin/env bash
# lint-references — verify the SoVai plugin has no dead cross-references.
#
# The plugin is self-referential: skills name skills, skills name agents, ADRs
# cite both, and plugin.json declares every skill path. Those references are
# written as BARE NAMES in backticks (`to-tickets`, `reviewer`), not as paths,
# so nothing about them is checked by the filesystem, by Claude Code, or by any
# other tool. A rename leaves the old name sitting in prose, still reading live.
#
# The plugin tree is located via $CLAUDE_PLUGIN_ROOT, or (for a manual run where
# that is unset) by walking up from this script:
#   <plugin>/skills/knowledge/lint-references/lint.sh -> <plugin>
#
# Checks:
#   1. bare skill/agent names in backticks resolve to a real skill or agent
#   2. every plugin.json "skills" entry is a directory holding a SKILL.md
#   3. every SKILL.md on disk is declared in plugin.json (undeclared never loads)
#   4. relative markdown links resolve on disk
#   5. hooks/hooks.json script paths resolve (optional — skipped when absent)
#
# Exit 0 = clean. Exit 1 = dead references found. Exit 2 = misresolved root.

set -u

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../../.." && pwd)}"

# Refuse to run against a misresolved root — a linter that scans nothing must
# fail loud, never print CLEAN.
if [ ! -d "$PLUGIN_ROOT/skills" ]; then
  echo "lint-references: ERROR — no skills/ under plugin root $PLUGIN_ROOT; cannot lint." >&2
  exit 2
fi

tmp=$(mktemp -d) || exit 2
trap 'rm -rf "$tmp"' EXIT
: > "$tmp/findings"

# --- Tokens shaped like a skill or agent name that are not one ---------------
# Every entry is a token the name check would otherwise report. Grouped by why
# it is exempt, so a later reader can tell an exemption from a bug.
cat > "$tmp/allow" <<'ALLOW'
# Skills this plugin deliberately does not own — supplied by the environment.
# ADR-0005 states that for the first; the second is a Claude Code ambient skill.
frontend-design
artifact-design
# Upstream mattpocock/skills names, cited as provenance rather than invoked.
diagnosing-bugs
handoff
wayfinder
# Another plugin, named in ADR-0006.
feature-dev
# Roads not taken. An ADR names the alternative it rejected, and the rejected
# name reads exactly like a live reference. Add an entry here, with the ADR that
# rejected it, when a new ADR does the same.
goal-reviewer   # ADR-0015 rejects it in favour of dispatching to `reviewer`
# Claude Code built-in agents and tools — a closed set Claude Code defines, for
# which this repo holds no file.
Explore
Plan
Agent
Task
Skill
Read
Write
Edit
Glob
Grep
Bash
TodoWrite
WebFetch
WebSearch
# Skill and agent frontmatter keys.
name
description
disable-model-invocation
tools
model
color
# Shell commands quoted in prose.
gh
grep
jq
# The plugin's own name.
SoVai
ALLOW

# --- The names that do resolve ----------------------------------------------
{
  # A skill's name is the leaf directory holding its SKILL.md, whatever block
  # it sits under.
  find "$PLUGIN_ROOT/skills" -name 'SKILL.md' 2>/dev/null \
    | while IFS= read -r p; do basename "$(dirname "$p")"; done
  # An agent's name is the basename of agents/<name>.md.
  if [ -d "$PLUGIN_ROOT/agents" ]; then
    find "$PLUGIN_ROOT/agents" -maxdepth 1 -name '*.md' 2>/dev/null \
      | while IFS= read -r p; do basename "$p" .md; done
  fi
  sed -E 's/[[:space:]]*#.*$//' "$tmp/allow" | grep -v '^[[:space:]]*$'
} | sort -u > "$tmp/known"

missing=0
checked=0

report() { # what  why
  printf '  MISSING: %s   (%s)\n' "$1" "$2" >> "$tmp/findings"
  missing=$((missing + 1))
}

# --- Files that carry cross-references --------------------------------------
scan_files() {
  find "$PLUGIN_ROOT/skills" -name '*.md' 2>/dev/null
  [ -d "$PLUGIN_ROOT/agents" ]   && find "$PLUGIN_ROOT/agents"   -maxdepth 1 -name '*.md' 2>/dev/null
  [ -d "$PLUGIN_ROOT/docs/adr" ] && find "$PLUGIN_ROOT/docs/adr" -maxdepth 1 -name '*.md' 2>/dev/null
  for f in CLAUDE.md CONTEXT.md README.md engineering-workflow.md; do
    [ -f "$PLUGIN_ROOT/$f" ] && printf '%s\n' "$PLUGIN_ROOT/$f"
  done
  return 0
}

# extract <file> -> "<kind>\t<line>\t<value>" records, deduplicated.
#   T = single-backtick token, prefixed "cue:" or "raw:" (see name_candidate)
#   L = markdown link target
# Fenced code blocks are dropped whole: they hold commands and sample code, not
# references. Obsidian [[wikilinks]] are dropped too — they address notes in a
# consuming project's vault, which does not exist from here.
extract() {
  awk '
    /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    {
      line = $0
      gsub(/\[\[[^]]*\]\]/, "", line)
      cue = (tolower(line) ~ /skill|agent/) ? "cue:" : "raw:"
      rest = line
      while (match(rest, /`[^`]+`/)) {
        print "T\t" NR "\t" cue substr(rest, RSTART + 1, RLENGTH - 2)
        rest = substr(rest, RSTART + RLENGTH)
      }
      rest = line
      while (match(rest, /\]\([^)]+\)/)) {
        print "L\t" NR "\t" substr(rest, RSTART + 2, RLENGTH - 3)
        rest = substr(rest, RSTART + RLENGTH)
      }
    }
  ' "$1" | sort -u
}

# name_candidate <token> <cue|raw>
#   A token is a name candidate when it is shaped like a name — starts with a
#   letter, kebab-case, no dot, slash, space or underscore — and is
#   distinguishable from ordinary prose: a hyphen makes it skill-shaped on its
#   own, while a single word counts only when its line also says "skill" or
#   "agent". Without that second condition every backticked English word
#   ("main", "switch", "grep") reports as a dead skill.
name_candidate() {
  case "$1" in
    [A-Za-z]*) ;;
    *) return 1 ;;
  esac
  case "$1" in
    *[!A-Za-z0-9-]* | *-) return 1 ;;
  esac
  case "$1" in
    ?)   return 1 ;;
    *-*) return 0 ;;
    *)   [ "$2" = cue ] ;;
  esac
}

echo "lint-references: plugin=$PLUGIN_ROOT"

# --- 1 + 4: bare names and relative links -----------------------------------
while IFS= read -r f; do
  src="${f#"$PLUGIN_ROOT"/}"
  dir=$(dirname "$f")
  while IFS=$'\t' read -r kind lineno value; do
    case "$kind" in
      T)
        cue="${value%%:*}"; tok="${value#*:}"
        name_candidate "$tok" "$cue" || continue
        checked=$((checked + 1))
        grep -Fxq -- "$tok" "$tmp/known" \
          || report "$tok" "bare name in $src:$lineno — no skill or agent by that name"
        ;;
      L)
        target="$value"
        case "$target" in
          *://* | mailto:* | '#'* | '') continue ;;   # external, or in-page anchor
        esac
        target="${target%%#*}"; target="${target%%\?*}"
        [ -n "$target" ] || continue
        case "$target" in
          /*) abs="$PLUGIN_ROOT$target" ;;
          *)  abs="$dir/$target" ;;
        esac
        checked=$((checked + 1))
        [ -e "$abs" ] || report "$target" "markdown link in $src:$lineno — no such file"
        ;;
    esac
  done < <(extract "$f")
done < <(scan_files)

# --- 2 + 3: plugin.json skill declarations ----------------------------------
manifest="$PLUGIN_ROOT/.claude-plugin/plugin.json"
if [ ! -f "$manifest" ]; then
  checked=$((checked + 1))
  report ".claude-plugin/plugin.json" "plugin manifest absent — no skill is declared"
else
  jq -r '.skills[]? | sub("^\\./"; "")' "$manifest" | sort -u > "$tmp/declared"
  find "$PLUGIN_ROOT/skills" -name 'SKILL.md' 2>/dev/null \
    | while IFS= read -r p; do d=$(dirname "$p"); printf '%s\n' "${d#"$PLUGIN_ROOT"/}"; done \
    | sort -u > "$tmp/ondisk"

  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    checked=$((checked + 1))
    [ -f "$PLUGIN_ROOT/$rel/SKILL.md" ] \
      || report "$rel" "declared in plugin.json — no SKILL.md there"
  done < "$tmp/declared"

  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    checked=$((checked + 1))
    grep -Fxq -- "$rel" "$tmp/declared" \
      || report "$rel/SKILL.md" "on disk but absent from plugin.json — it will never load"
  done < "$tmp/ondisk"
fi

# --- 5: hook wiring (optional) ----------------------------------------------
hooks_json="$PLUGIN_ROOT/hooks/hooks.json"
if [ -f "$hooks_json" ]; then
  # Read the command strings through jq so JSON escaping is already undone, then
  # keep only what is anchored to the plugin root — an absolute system path in a
  # command is not this plugin's file to account for.
  {
    jq -r '.. | objects | select(has("command")) | .command' "$hooks_json" 2>/dev/null \
      | tr -d '"' \
      | grep -oE '\$\{?CLAUDE_PLUGIN_ROOT\}?/[A-Za-z0-9._/-]+' \
      | sed -E 's#^\$\{?CLAUDE_PLUGIN_ROOT\}?/##'
    jq -r '.. | objects | select(has("command")) | .command' "$hooks_json" 2>/dev/null \
      | grep -oE '(^|[^A-Za-z0-9._/${-])hooks/[A-Za-z0-9._/-]+\.(sh|bash|py|js|mjs|ts)' \
      | grep -oE 'hooks/[A-Za-z0-9._/-]+\.(sh|bash|py|js|mjs|ts)'
  } | sort -u > "$tmp/hookpaths"
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    checked=$((checked + 1))
    [ -e "$PLUGIN_ROOT/$rel" ] \
      || report "$rel" "referenced in hooks/hooks.json — no such file"
  done < "$tmp/hookpaths"
else
  echo "lint-references: hooks/hooks.json absent — hook check skipped."
fi

sort -u "$tmp/findings"
echo "---"
if [ "$checked" -eq 0 ]; then
  echo "lint-references: ERROR — 0 references checked; misconfigured, not clean." >&2
  exit 2
fi
echo "lint-references: $checked references checked, $missing missing."
if [ "$missing" -eq 0 ]; then echo "CLEAN"; exit 0; else echo "DEAD REFERENCES FOUND"; exit 1; fi
