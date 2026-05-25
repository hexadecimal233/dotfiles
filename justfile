# Build but don't switch to a configuration
build config:
    nixos-rebuild build --flake .#{{ config }}

# Use a specific system configuration and
# build and switch to that configuration
use config:
    nixos-rebuild switch --flake .#{{ config }}

# Test configuration in a VM
test config:
    nixos-rebuild build-vm --flake .#{{ config }}

# Update the flake lockfile
update:
    nix flake update

# Analyze current system tree
tree:
    nix run nixpkgs#nix-tree /run/current-system

# Update and rebuild in one command
refresh config:
    nix flake update
    nixos-rebuild switch --flake .#{{ config }}

# Check the flake for errors
check:
    nix flake check

# Clean boot entries
clean-boot:
    sudo nix-collect-garbage --delete-older-than 30d
    sudo /run/current-system/bin/switch-to-configuration boot

# Show current generation metadata
info:
    nixos-rebuild list-generations
    nix flake metadata

# Garbage collect old Nix generations
gc:
    sudo nix-collect-garbage --delete-old
    nix-collect-garbage --delete-old

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

# Rollback to previous generation
rollback:
    sudo nixos-rebuild switch --rollback

# Search for a package (usage: search firefox)
search query:
    nix search nixpkgs#{{ query }}

# Upgrade all unstable packages
upgrade:
    nix flake lock --update-input nixpkgs
    nixos-rebuild switch --flake .#
