#!/usr/bin/env bash
# Add RTK (https://github.com/rtk-ai/rtk) to Claude Code on THIS machine.
# RTK filters Bash tool output (git, tests, linters, docker, ...) before the model reads it.
#
#   scripts/rtk.sh install   install the rtk binary and the Claude Code hook (~/.claude/settings.json)
#   scripts/rtk.sh status    show hook status and token savings
#   scripts/rtk.sh remove    remove the Claude Code hook
#
# Run this on your own machine, not inside a cloud Claude Code session.
# Telemetry is off by default; this script never enables it.
set -euo pipefail

if [ -n "${CCR_AGENT_PROXY_ENABLED:-}" ]; then
  echo "This looks like a cloud Claude Code container. RTK's hook edits ~/.claude/settings.json. Run this on your own machine." >&2
  exit 1
fi

case "${1:-}" in
  install)
    if ! command -v rtk >/dev/null 2>&1; then
      if command -v brew >/dev/null 2>&1; then
        brew install rtk
      else
        curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
      fi
    fi
    command -v rtk >/dev/null 2>&1 || { echo "rtk not on PATH; add ~/.local/bin to PATH and re-run." >&2; exit 1; }
    rtk init -g
    rtk init --show
    echo "Restart Claude Code for the hook to take effect."
    ;;
  status)
    rtk init --show
    rtk gain
    ;;
  remove)
    rtk init -g --uninstall
    ;;
  *)
    echo "usage: $0 {install|status|remove}" >&2
    exit 2
    ;;
esac
