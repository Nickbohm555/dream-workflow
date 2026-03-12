#!/usr/bin/env bash
set -euo pipefail

PROMPT_FILE="PROMPT_build.md"
AGENTS_FILE="AGENTS.md"
MAX_ITERATIONS=0
REQUIRE_COMMIT_PER_ITERATION="${REQUIRE_COMMIT_PER_ITERATION:-1}"

if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
  MAX_ITERATIONS="$1"
elif [ -n "${1:-}" ]; then
  echo "Usage: ./loop.sh [max_iterations]"
  exit 1
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Error: max iterations must be a non-negative integer."
  exit 1
fi

if [ -z "${AGENT_CMD:-}" ]; then
  while :; do
    read -r -p "Which agent are you using? (claude/codex): " AGENT_CHOICE
    case "${AGENT_CHOICE,,}" in
      claude)
        AGENT_CMD="claude -p"
        break
        ;;
      codex)
        AGENT_CMD="codex exec --sandbox workspace-write -"
        break
        ;;
      *)
        echo "Invalid option. Choose claude or codex."
        ;;
    esac
  done
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: prompt file not found: $PROMPT_FILE"
  exit 1
fi

if [ ! -f "$AGENTS_FILE" ]; then
  echo "Error: agents file not found: $AGENTS_FILE"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Ralph loop must run inside a git repository."
  exit 1
fi

if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  echo "Error: working tree is dirty before the loop starts."
  echo "Commit, stash, or discard changes before running Ralph."
  exit 1
fi

ITERATION=0
while :; do
  ITERATION=$((ITERATION + 1))
  START_HEAD="$(git rev-parse --verify HEAD 2>/dev/null || true)"
  echo "=================================================="
  echo "Ralph loop iteration: $ITERATION"
  echo "Prompt: $PROMPT_FILE"
  echo "Agents: $AGENTS_FILE"
  [ "$MAX_ITERATIONS" -gt 0 ] && echo "Max iterations: $MAX_ITERATIONS"
  echo "=================================================="

  cat "$PROMPT_FILE" "$AGENTS_FILE" | eval "$AGENT_CMD"

  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "Error: iteration $ITERATION ended with uncommitted changes."
    echo "Each section must finish with a commit using the required convention."
    exit 1
  fi

  END_HEAD="$(git rev-parse --verify HEAD 2>/dev/null || true)"
  if [ "$REQUIRE_COMMIT_PER_ITERATION" = "1" ] && [ "$START_HEAD" = "$END_HEAD" ]; then
    echo "Error: iteration $ITERATION did not create a commit."
    echo "Use one of:"
    echo "  {type}({phase}-{plan}): {task-name}"
    echo "  docs({phase}-{plan}): complete [plan-name] plan"
    echo "  docs({phase}): complete {phase-name} phase"
    exit 1
  fi

  LAST_SUBJECT="$(git log -1 --pretty=%s 2>/dev/null || true)"
  if [[ ! "$LAST_SUBJECT" =~ ^(feat|fix|test|refactor|perf|chore|docs|style)\([0-9]{2}(-[0-9]{2})?\):\ .+ ]]; then
    echo "Error: latest commit does not match the required history convention."
    echo "Latest commit: $LAST_SUBJECT"
    exit 1
  fi

  if [ "$MAX_ITERATIONS" -gt 0 ] && [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
    echo "Reached max iterations ($MAX_ITERATIONS)."
    break
  fi
done
