#!/usr/bin/env zsh
# pomo.sh: 50/10 pomodoro timer with a compact countdown
#
# Usage:
#   ./pomo.sh              # runs work=50min, break=10min, loops forever
#   ./pomo.sh 25 5          # custom work/break minutes
#   Ctrl+C to stop anytime
#
# Install: chmod +x pomo.sh, then run it (or symlink into your dotfiles bin dir)

WORK_MIN=${1:-50}
BREAK_MIN=${2:-10}

notify() {
  local title="$1" msg="$2"
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$msg\" with title \"$title\"" 2>/dev/null
  fi
  if command -v afplay >/dev/null 2>&1; then
    # &! = background + disown, so zsh doesn't print "[N] done afplay ..." over the timer
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &!
  fi
}

# shows a single-line countdown for `total_seconds`, labeled with `label`
run_timer() {
  local total_seconds=$1 label=$2 color=$3
  local start=$(date +%s)

  while true; do
    local now=$(date +%s)
    local elapsed=$(( now - start ))
    local remaining=$(( total_seconds - elapsed ))
    (( remaining < 0 )) && remaining=0

    local mins=$(( remaining / 60 ))
    local secs=$(( remaining % 60 ))

    # \033[K clears the rest of the line so nothing stale is left behind
    printf "\r\033[%sm%s\033[0m %02d:%02d\033[K" \
      "$color" "$label" "$mins" "$secs"

    if (( elapsed >= total_seconds )); then
      echo ""
      break
    fi
    sleep 1
  done
}

trap 'echo "\n\n👋 Stopped."; exit 0' INT

echo "🍅 Pomodoro started: ${WORK_MIN}min work / ${BREAK_MIN}min break. Ctrl+C to stop.\n"

session=1
while true; do
  echo "── Session $session: Focus ──"
  notify "Pomodoro" "Focus session started — ${WORK_MIN} min"
  run_timer $(( WORK_MIN * 60 )) "🍅 WORK " "31"
  notify "Pomodoro" "Work session done — take a break!"

  echo "── Session $session: Break ──"
  notify "Pomodoro" "Break started — ${BREAK_MIN} min"
  run_timer $(( BREAK_MIN * 60 )) "☕ BREAK" "32"
  notify "Pomodoro" "Break's over — back to work!"

  echo ""
  session=$(( session + 1 ))
done
