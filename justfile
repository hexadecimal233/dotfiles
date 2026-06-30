# NOTE: some of the functionalities are being replaced by nh!!
#       build, switch, refresh, gc have been removed.

# --- mirror args (auto-detect proxy env) ---
_mirror_args := if env("HTTP_PROXY", "") + env("HTTPS_PROXY", "") + env_var_or_default("http_proxy", "") + env_var_or_default("https_proxy", "") + env_var_or_default("ALL_PROXY", "") + env_var_or_default("all_proxy", "") != "" {
  "--option substituters https://mirrors.ustc.edu.cn/nix-channels/store"
} else {
  ""
}

# Differentiate the package updates
diff:
    nix run nixpkgs#nvd -- diff /run/current-system ./result

# Update the flake lockfile
update:
    nix flake update

# Analyze current system tree
tree:
    nix run nixpkgs#nix-tree /run/current-system

# Check the flake for errors
check:
    nix flake check

# Show current generation metadata
info:
    nixos-rebuild list-generations
    nix flake metadata


# Trim the FS (for WS: mainly)
fstrim:
    sudo fstrim -v /

# Show flake status/diff
status:
    nix flake show
    nix store diff-closures /run/current-system ./result

# Print hex option tree for a host
audit os host:
    nix eval ".#{{os}}Configurations.{{host}}.config.hex" \
      --apply 'import ./scripts/audit.nix' --impure >/dev/null


# --- Evaluation Profiling + Flamegraph ---

# Time Nix evaluation AND generate a flamegraph in a single eval pass.
# Shows total eval time + Nix function-level flamegraph (file:line:col:function).
#
# Works cross-platform (Linux + macOS) — no perf/dtrace needed.
# Requires Nix >= 2.30 (--eval-profiler flag).
#
# Usage:
#   just flamegraph nixos thinkpad
#   just flamegraph darwin neo
flamegraph os host:
    #!/usr/bin/env bash
    set -euo pipefail

    OS="{{os}}"; HOST="{{host}}"

    case "$OS" in
        nixos) prefix="nixosConfigurations";  suffix="config.system.build.toplevel" ;;
        darwin) prefix="darwinConfigurations"; suffix="system" ;;
        *)
            echo "Usage: just flamegraph <nixos|darwin> <host>"
            exit 1
            ;;
    esac

    expr=".#$prefix.$HOST.$suffix"
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    PROFILE="/tmp/flamegraph-$HOST-$TIMESTAMP.txt"
    SVG="/tmp/flamegraph-$HOST-$TIMESTAMP.svg"

    echo "=== $HOST (eval + profile) ==="
    echo -n "  eval ... "
    start=$(date +%s%N 2>/dev/null || python3 -c 'import time; print(time.time_ns())')
    nix eval --eval-profiler flamegraph \
      --eval-profile-file "$PROFILE" \
      --no-eval-cache \
      "$expr" --impure </dev/null >/dev/null 2>&1
    end=$(date +%s%N 2>/dev/null || python3 -c 'import time; print(time.time_ns())')
    elapsed_ms=$(( (end - start) / 1000000 ))
    echo "${elapsed_ms}ms"

    echo "  flamegraph ... "
    inferno-flamegraph --title "$HOST-eval" < "$PROFILE" > "$SVG"
    rm -f "$PROFILE"

    echo ""
    echo "=> $SVG"
    if command -v xdg-open &>/dev/null; then
        xdg-open "$SVG" 2>/dev/null || true
    elif command -v open &>/dev/null; then
        open "$SVG" 2>/dev/null || true
    fi
