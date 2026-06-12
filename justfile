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

# Format files with alejandra
fmt:
    alejandra .

# Trim the FS (for WS: mainly)
fstrim:
    sudo fstrim -v /

# Show flake status/diff
status:
    nix flake show
    nix store diff-closures /run/current-system ./result

# Print hex option tree for a host
audit host:
    nix eval ".#nixosConfigurations.{{host}}.config.hex" --apply 'import ./scripts/audit.nix' --impure >/dev/null
