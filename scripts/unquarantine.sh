#!/bin/bash
# unquarantine - Remove macOS quarantine attribute from apps
# Usage: unquarantine <app-name>
# Example: unquarantine Firefox

set -e

if [ $# -eq 0 ]; then
    echo "Usage: unquarantine <app-name>"
    echo "Example: unquarantine Firefox"
    echo ""
    echo "Installed apps:"
    ls -1 /Applications/*.app 2>/dev/null | sed 's|/Applications/||;s|\.app||' | sort
    exit 1
fi

APP_NAME="$1"
APP_PATH="/Applications/${APP_NAME}.app"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: ${APP_NAME}.app not found in /Applications/"
    echo ""
    echo "Did you mean one of these?"
    ls -1 /Applications/*.app 2>/dev/null | sed 's|/Applications/||;s|\.app||' | grep -i "$APP_NAME" || echo "(no matches)"
    exit 1
fi

echo "Removing quarantine from ${APP_NAME}.app..."
xattr -cr "$APP_PATH"
echo "Done! ${APP_NAME}.app is now unquarantined."
