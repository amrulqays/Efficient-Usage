# Headroom

Headroom (https://github.com/headroomlabs-ai/headroom) is the default context-compression layer for Claude Code on the owner's machine. It runs as a background service on `127.0.0.1:8787` and Claude Code is routed through it via `ANTHROPIC_BASE_URL`.

- Set up, check, or remove it with `scripts/headroom.sh install|status|remove`.
- If API calls fail with connection errors to `127.0.0.1:8787`, the service is down: run `headroom install start`, or `scripts/headroom.sh status` to diagnose.
- Don't commit `ANTHROPIC_BASE_URL` to `.claude/settings.json`; routing lives in the user-level `~/.claude/settings.json`.
