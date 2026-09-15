#!/bin/bash
set -uo pipefail

# Only relevant on Claude Code on the web: each remote session starts from a
# fresh, ephemeral container, so user-scoped MCP servers don't persist across
# sessions and need to be re-added on every startup. A local install (laptop)
# is not ephemeral, so skip there.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

add_mcp_server() {
  local name="$1"
  shift
  if claude mcp add "$name" -s user -- "$@" >/dev/null 2>&1; then
    echo "Added MCP server: $name"
  else
    echo "MCP server $name already configured or add failed (non-fatal), skipping"
  fi
}

add_mcp_server context7 npx -y @upstash/context7-mcp
add_mcp_server chrome-devtools npx chrome-devtools-mcp@latest
add_mcp_server playwright npx @playwright/mcp@latest

exit 0
