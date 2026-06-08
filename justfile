# Build but don't switch
build config:
    nixos-rebuild build --flake .#{{ config }}

# Build and switch
switch config:
    sudo nixos-rebuild switch --flake .#{{ config }}

# Update flake and switch
refresh config:
    nix flake update
    sudo nixos-rebuild switch --flake .#{{ config }}

# Check flake for errors
check:
    nix flake check

# Format with alejandra
fmt:
    alejandra .

# Update flake lockfile
update:
    nix flake update

# Garbage collect
gc:
    sudo nix-collect-garbage --delete-old
    nix-collect-garbage --delete-old

# Clean boot entries
clean-boot:
    sudo nix-collect-garbage --delete-older-than 30d
    sudo /run/current-system/bin/switch-to-configuration boot
