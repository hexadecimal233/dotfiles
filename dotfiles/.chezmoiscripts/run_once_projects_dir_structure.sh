#!/usr/bin/env bash

set -euo pipefail

BASE="$HOME/projects"

CATEGORIES=(
    "archived" # (permanently) archived code
    "me-related" # my website / profile / blogs
    "contributions" # code forks / contributions
    "contributions/_archive" # archived / stale contribs
    "hardware" # embedded development
    "languages" # language-specific projects
    # nixos-config: clone this repo into the directory
    "general" # multilingual / large projects
    "docs" # documentational projects
)

echo "ensuring project folder structure under $BASE ..."

mkdir -p "$BASE"
for cat in "${CATEGORIES[@]}"; do
    target="$BASE/$cat"
    if [[ ! -d "$target" ]]; then
        mkdir -p "$target"
        echo "- created: $target"
    else
        echo "- exists:  $target"
    fi
done

echo "Ciallo～(∠・ω< )⌒★"