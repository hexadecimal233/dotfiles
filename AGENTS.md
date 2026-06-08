# AGENTS.md

## Build & Test
- Build: `just build wsl` or `just build thinkpad`
- Switch: `just switch wsl` or `just switch thinkpad` (requires sudo)
- Format: `just fmt`
- Check: `just check`

## Conventions
- Formatter: alejandra
- Shell: fish
- Editor: helix
- All comments in English
- Namespace: `hex.*` for all custom options

## Module Structure
```
modules/
├── profile/           # Orchestration, imports home-manager + all modules
├── shared/home/       # Cross-platform home-manager modules (shell, git, editor, dev, packages, gpg)
├── nixos/system/      # NixOS system-level (users, locale, nix settings, tools)
├── nixos/desktop/     # NixOS desktop (GPU, audio, fonts, hyprland)
└── darwin/            # macOS (future)
```

## Option Toggles
Each host declares which features to enable via `hex.*` options:
- `hex.system.enable` — core system
- `hex.desktop.enable` — desktop environment (sub: audio, fonts, hyprland)
- `hex.shell.enable` — fish, starship, zoxide, direnv
- `hex.git.enable` — git, gh, lazygit, delta
- `hex.editor.enable` — helix
- `hex.dev.enable` — compilers, LSPs
- `hex.packages.enable` — CLI tools
- `hex.gpg.enable` — gpg-agent
