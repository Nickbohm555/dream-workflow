#!/usr/bin/env bash
set -euo pipefail

PROMPT_FILE="PROMPT_build.md"
AGENTS_FILE="AGENTS.md"
MAX_ITERATIONS=0

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

ITERATION=0
while :; do
  ITERATION=$((ITERATION + 1))
  echo "=================================================="
  echo "Ralph loop iteration: $ITERATION"
  echo "Prompt: $PROMPT_FILE"
  echo "Agents: $AGENTS_FILE"
  [ "$MAX_ITERATIONS" -gt 0 ] && echo "Max iterations: $MAX_ITERATIONS"
  echo "=================================================="

  cat "$PROMPT_FILE" "$AGENTS_FILE" | eval "$AGENT_CMD"

  if [ "$MAX_ITERATIONS" -gt 0 ] && [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
    echo "Reached max iterations ($MAX_ITERATIONS)."
    break
  fi
done
