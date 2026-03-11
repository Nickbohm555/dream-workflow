#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./loop.sh
#   ./loop.sh 10
#   ./loop.sh plan
#   ./loop.sh plan 5
#   ./loop.sh plan-work "user auth"
#   ./loop.sh plan-work "user auth" 5

MODE="build"
PROMPT_FILE="PROMPT_build.md"
MAX_ITERATIONS=0
WORK_SCOPE="${WORK_SCOPE:-}"

if [ "${1:-}" = "plan" ]; then
  MODE="plan"
  PROMPT_FILE="PROMPT_plan.md"
  MAX_ITERATIONS="${2:-0}"
elif [ "${1:-}" = "plan-work" ]; then
  MODE="plan-work"
  PROMPT_FILE="PROMPT_plan_work.md"
  WORK_SCOPE="${WORK_SCOPE:-${2:-}}"
  if [ -z "$WORK_SCOPE" ]; then
    echo "Error: plan-work requires a work description."
    echo "Usage: ./loop.sh plan-work \"description of work\" [max_iterations]"
    exit 1
  fi
  MAX_ITERATIONS="${3:-5}"
elif [[ "${1:-}" =~ ^[0-9]+$ ]]; then
  MAX_ITERATIONS="$1"
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Error: max iterations must be a non-negative integer."
  exit 1
fi

if [ -z "${AGENT_CMD:-}" ]; then
  while :; do
    read -r -p "Which agent are you using? (claude/codex): " AGENT_CHOICE
    AGENT_CHOICE="$(echo "$AGENT_CHOICE" | tr '[:upper:]' '[:lower:]')"
    case "$AGENT_CHOICE" in
      claude)
        AGENT_CMD="claude -p"
        break
        ;;
      codex)
        AGENT_CMD="codex exec --sandbox danger-full-access -"
        break
        ;;
      cursor)
        echo "Cursor is not wired into this script yet. Choose claude or codex."
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

ITERATION=0
while :; do
  ITERATION=$((ITERATION + 1))
  echo "=================================================="
  echo "Mode: $MODE | Iteration: $ITERATION | Prompt: $PROMPT_FILE"
  [ "$MAX_ITERATIONS" -gt 0 ] && echo "Max iterations: $MAX_ITERATIONS"
  [ "$MODE" = "plan-work" ] && echo "Work scope: $WORK_SCOPE"
  echo "=================================================="

  if [ "$MODE" = "plan-work" ]; then
    {
      awk -v scope="$WORK_SCOPE" '{gsub(/\$\{WORK_SCOPE\}/, scope); print}' "$PROMPT_FILE"
      printf "\n"
      cat AGENTS.md
    } | eval "$AGENT_CMD"
  else
    cat "$PROMPT_FILE" AGENTS.md | eval "$AGENT_CMD"
  fi

  if [ -n "$(git status --porcelain 2>/dev/null || true)" ]; then
    LOOP_MSG=".loop-commit-msg"
    LOOP_FULL=".loop-commit-msg.full"
    if [ -f "$LOOP_MSG" ]; then
      SUMMARY=$(head -1 "$LOOP_MSG" | tr -d '\n\r')
    else
      SUMMARY="(no summary)"
    fi
    printf 'dream loop %s (%s): %s\n' "$ITERATION" "$MODE" "$SUMMARY" > "$LOOP_FULL"
    git add -A || true
    git commit -F "$LOOP_FULL" || true
    rm -f "$LOOP_MSG" "$LOOP_FULL"
    git push -u origin "$(git branch --show-current)" || true
  fi

  if [ "$MAX_ITERATIONS" -gt 0 ] && [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
    echo "Reached max iterations ($MAX_ITERATIONS). Stopping."
    break
  fi
done

echo "Loop finished."
