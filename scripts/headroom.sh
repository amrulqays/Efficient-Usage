#!/usr/bin/env bash
# Make Headroom the always-on default for Claude Code on THIS machine.
#
#   scripts/headroom.sh install   install headroom-ai, start the background service, route Claude Code through it
#   scripts/headroom.sh status    show service status and run `headroom doctor`
#   scripts/headroom.sh remove    stop the service and revert the Claude Code routing
#
# Run this on your own machine, not inside a cloud Claude Code session.
set -euo pipefail

if [ -n "${CCR_AGENT_PROXY_ENABLED:-}" ]; then
  echo "This looks like a cloud Claude Code container. Routing Claude Code through a local proxy here could break the session. Run this on your own machine." >&2
  exit 1
fi

case "${1:-}" in
  install)
    if ! command -v headroom >/dev/null 2>&1; then
      command -v uv >/dev/null 2>&1 || { echo "uv is required: https://docs.astral.sh/uv/" >&2; exit 1; }
      uv tool install --python 3.13 "headroom-ai[all]"
    fi
    # Background service keeps the proxy on 127.0.0.1:8787; provider scope writes env into ~/.claude/settings.json
    headroom install apply --preset persistent-service --providers manual --target claude
    headroom install status
    headroom doctor
    ;;
  status)
    headroom install status
    headroom doctor
    ;;
  remove)
    headroom install remove
    ;;
  *)
    echo "usage: $0 {install|status|remove}" >&2
    exit 2
    ;;
esac
