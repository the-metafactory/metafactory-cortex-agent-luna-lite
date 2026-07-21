#!/usr/bin/env bash
# signal-cortex-reload.sh — luna-lite postinstall (step 1 of 1)
#
# Signals the running cortex daemon to reload its agents.d/ directory so it
# picks up the newly-installed luna.yaml fragment WITHOUT a full restart.
#
# ORDER: arc drops persona.md + agent.yaml FIRST (the `provides.files` step),
# THEN runs this script. Luna-Lite is an in-process agent sharing the stack's
# bus identity, so — like pier — it skips any creds-issue step entirely.
#
# Reload mechanism: prefer `cortex agents reload`; fall back to SIGHUP.
# Modeled on scripts/pier/signal-cortex-reload.sh in the cortex repo.

set -euo pipefail

RELOAD_TIMEOUT=10

# ── 1. Try `cortex agents reload` ─────────────────────────────────────────
if command -v cortex &>/dev/null; then
  echo "luna-lite postinstall: signalling cortex agents reload..."
  if timeout "$RELOAD_TIMEOUT" cortex agents reload 2>/dev/null; then
    echo "luna-lite postinstall: reload acknowledged — Luna is active on your stack."
    exit 0
  fi
  echo "luna-lite postinstall: 'cortex agents reload' timed out or failed; trying SIGHUP..." >&2
fi

# ── 2. Fall back to SIGHUP ────────────────────────────────────────────────
PID_FILE="${HOME}/.local/share/cortex/cortex.pid"
if [[ -f "$PID_FILE" ]]; then
  DAEMON_PID="$(cat "$PID_FILE")"
  if kill -0 "$DAEMON_PID" 2>/dev/null; then
    echo "luna-lite postinstall: sending SIGHUP to cortex daemon (pid ${DAEMON_PID})..."
    kill -HUP "$DAEMON_PID"
    echo "luna-lite postinstall: SIGHUP sent — daemon reloads agents.d/ on next poll."
    exit 0
  fi
fi

# ── 3. No running daemon — fragment is on disk, active on next start ──────
echo "luna-lite postinstall: cortex daemon not detected." >&2
echo "  The luna.yaml fragment is installed at ~/.config/cortex/agents.d/luna.yaml." >&2
echo "  Luna is active on the next 'cortex start' — or run 'cortex agents reload' now." >&2
exit 0
