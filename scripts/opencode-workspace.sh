#!/usr/bin/env bash
# Create an opencode project-level configuration file in the current directory
# with opencode-rtk plugin enabled.
#
# Usage: opencode-workspace [--force]
#   Creates opencode.jsonc in the current working directory.
#   --force  Overwrite existing opencode.jsonc if present.

set -euo pipefail

CONFIG_FILE="opencode.jsonc"

for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=1 ;;
    --help|-h)
      echo "Usage: opencode-workspace [--force|-f]"
      echo "  Creates opencode.jsonc in the current directory with workspace plugin."
      exit 0
      ;;
  esac
done

if [ -f "$CONFIG_FILE" ] && [ "${FORCE:-0}" -ne 1 ]; then
  echo >&2 "❌ $CONFIG_FILE already exists in $(pwd)"
  echo >&2 "   Use --force to overwrite, or delete it first."
  exit 1
fi

cat > "$CONFIG_FILE" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "opencode-rtk"
  ]
}
EOF

echo "✓ Created $CONFIG_FILE in $(pwd)"
