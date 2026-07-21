#!/usr/bin/env bash
# check-cortex-version.sh — luna-light preinstall gate
#
# Verifies a cortex stack is present and new enough to host an in-process,
# surface-neutral agent fragment:
#   1. `cortex` is on PATH
#   2. cortex >= 6.9.0
#
# Luna-Light is SURFACE-NEUTRAL, so — unlike pier — this gate requires NO
# surface token. You bind Luna to a surface (web/Discord) in your stack's
# surfaces.yaml after install; nothing here needs a secret.
#
# arc install luna-light runs this BEFORE dropping any files. On failure the
# install aborts cleanly with nothing written.
#
# Modeled on scripts/pier/check-cortex-version.sh in the cortex repo.

set -euo pipefail

REQUIRED_MAJOR=6
REQUIRED_MINOR=9

# ── 1. cortex on PATH ──────────────────────────────────────────────────────
if ! command -v cortex &>/dev/null; then
  echo "luna-light preinstall ERROR: 'cortex' binary not found on PATH." >&2
  echo "  Install cortex and stand up a stack first:" >&2
  echo "    arc install cortex" >&2
  echo "    cortex stack create <slug> --apply" >&2
  exit 1
fi

# ── 2. cortex version ──────────────────────────────────────────────────────
CORTEX_VERSION="$(cortex --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [[ -z "$CORTEX_VERSION" ]]; then
  echo "luna-light preinstall ERROR: could not determine cortex version." >&2
  exit 1
fi

MAJOR="$(echo "$CORTEX_VERSION" | cut -d. -f1)"
MINOR="$(echo "$CORTEX_VERSION" | cut -d. -f2)"

if (( MAJOR < REQUIRED_MAJOR || (MAJOR == REQUIRED_MAJOR && MINOR < REQUIRED_MINOR) )); then
  echo "luna-light preinstall ERROR: cortex ${CORTEX_VERSION} found; >= ${REQUIRED_MAJOR}.${REQUIRED_MINOR}.0 required." >&2
  echo "  Upgrade:  arc upgrade cortex" >&2
  exit 1
fi

echo "luna-light preinstall: cortex ${CORTEX_VERSION} OK — installing the Luna fragment."
echo "  After install, bind Luna to your stack's surface in surfaces/surfaces.yaml,"
echo "  or dispatch to @luna over the bus directly."
exit 0
