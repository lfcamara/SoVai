#!/usr/bin/env bash
# Shared per-project config reader for the SoVai enforcement hooks.
#
# WHY WALK UP INSTEAD OF HARDCODING
# SoVai is a general-purpose plugin: it has no idea which projects it is
# installed into, what those projects are built with, or which directories they
# consider UI. So the hooks discover a project's shape by walking UP from the
# edited file to the nearest per-project config:
#
#     sovai.config.json   (at a project root)
#
# A project with no config is simply not gated. Onboarding is therefore a
# one-file drop, not a code edit. Because the config lives at the project root,
# git worktrees and clones inherit it automatically.
#
# THE SCHEMA — three keys, all optional, all lists of path patterns:
#
#     {
#       "productionLogic": ["src/**", "lib/**"],
#       "ui":              ["src/components/**", "src/app/**"],
#       "tests":           ["*.test.*", "*.spec.*", "test/**"]
#     }
#
#   productionLogic — paths subject to mandatory TDD (ADR-0007).
#   ui              — the deliberate TDD exception: tested after implementation.
#   tests           — test files, gated by nothing.
#
# No stack enum, no fixed module names: a project declares what its own shape
# is. Only the project knows which of its directories are UI, and ADR-0007 makes
# that distinction load-bearing, so no plugin-side default can stand in for it.
#
# PRECEDENCE — tests, then ui, then productionLogic. UI paths are normally a
# subset of production paths ("src/components/**" lives under "src/**"), so ui
# must win or it would never be reached; that ordering is what saves a project
# from writing exclusions into productionLogic. A path matching nothing is
# classified as neither and gates nothing.
#
# PATTERNS are matched with shell `case` globbing against the path RELATIVE to
# the project root. `*` crosses `/`, so "src/**" and "src/*" both match
# "src/a/b.ts", and "*.test.*" matches a test file at any depth. Deliberately
# forgiving: a pattern that matches slightly too much costs a reminder, while a
# regex dialect nobody remembers costs the config being written wrong.
#
# FAIL OPEN, ALWAYS. No config found means no gating. A malformed or unreadable
# config means no gating. Every reader below returns empty rather than failing.
# A hook must never break a session over its own configuration — the cost of
# under-gating is a missed reminder, and the cost of over-gating is a developer
# who cannot work.
#
# This file is sourced, never executed directly. It defines functions only and
# must not emit output or change shell options in the caller.

# Walk up from a file path to the nearest sovai.config.json.
# Echoes the absolute project root (the dir holding the config) on success.
# Returns 0 if found, 1 otherwise.
sovai_find_project_config() {
  local path="$1"
  [ -z "$path" ] && return 1
  local dir
  dir="$(dirname "$path")"
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    if [ -f "$dir/sovai.config.json" ]; then
      printf '%s\n' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  [ -f "/sovai.config.json" ] && { printf '/\n'; return 0; }
  return 1
}

# Echo the value of a jq expression against a project's config.
# Tolerates a missing, unreadable, or malformed config by echoing nothing.
sovai_config_value() {
  local project_root="$1" filter="$2"
  local cfg="$project_root/sovai.config.json"
  [ -f "$cfg" ] || return 0
  jq -r "$filter" "$cfg" 2>/dev/null || true
}

# Echo the newline-separated path patterns held under one config key.
# An absent key, a non-list value, or a malformed config all echo nothing.
sovai_config_patterns() {
  local project_root="$1" key="$2"
  sovai_config_value "$project_root" \
    "(.[\"$key\"] // []) | if type == \"array\" then .[] else empty end | select(type == \"string\")"
}

# Return 0 if a project-relative path matches any of the newline-separated
# glob patterns given as the second argument, 1 otherwise.
sovai_path_matches() {
  local rel="$1" patterns="$2"
  [ -z "$patterns" ] && return 1
  local pattern
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    # Unquoted on purpose: this is where the pattern does its globbing.
    # shellcheck disable=SC2254
    case "$rel" in
      $pattern) return 0 ;;
    esac
  done <<SOVAI_PATTERNS
$patterns
SOVAI_PATTERNS
  return 1
}

# Classify an absolute file path against a project's config.
# Echoes exactly one of: production | ui | test | (nothing, meaning neither).
# Always returns 0 — the classification is the answer, not the exit status.
sovai_classify_path() {
  local project_root="$1" file_path="$2"
  local rel="${file_path#"$project_root"/}"

  if sovai_path_matches "$rel" "$(sovai_config_patterns "$project_root" tests)"; then
    printf 'test\n'
    return 0
  fi
  if sovai_path_matches "$rel" "$(sovai_config_patterns "$project_root" ui)"; then
    printf 'ui\n'
    return 0
  fi
  if sovai_path_matches "$rel" "$(sovai_config_patterns "$project_root" productionLogic)"; then
    printf 'production\n'
    return 0
  fi
  return 0
}

# Echo a session id reduced to filename-safe characters, for use in a sentinel
# path. The id arrives from hook input, so it is never trusted verbatim.
sovai_session_slug() {
  local session_id="$1"
  [ -z "$session_id" ] && { printf 'nosession\n'; return 0; }
  printf '%s' "$session_id" | tr -c 'A-Za-z0-9_.-' '_'
  printf '\n'
}
