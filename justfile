# Build and switch to the WSL configuration
switch-wsl:
    nixos-rebuild switch --flake .#wsl

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

# Format files
fmt:
    alejandra .