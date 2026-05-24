# Build the WSL NixOS configuration
build-wsl:
    nixos-rebuild build --flake .#wsl

# Switch to the WSL NixOS configuration (requires sudo)
switch-wsl:
    sudo nixos-rebuild switch --flake .#wsl

# Build the physical machine NixOS configuration
build-physical:
    nixos-rebuild build --flake .#physical

# Switch to the physical machine configuration (requires sudo)
switch-physical:
    sudo nixos-rebuild switch --flake .#physical

# Update the flake lockfile
update:
    nix flake update

# Check the flake for errors
check:
    nix flake check

# Garbage collect old Nix generations
gc:
    sudo nix-collect-garbage --delete-old
    nix-collect-garbage --delete-old
