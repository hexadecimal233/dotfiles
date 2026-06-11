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

## Module Structure
```
modules/
├── shared/            # Cross-platform modules
│   ├── home/          # Home-manager modules (shell, git, editor, dev, packages, gpg)
│   ├── system/        # Cross-platform system tools (wget, curl, htop, btop, etc.)
│   └── nix.nix        # Nix package manager settings (GC, flakes, etc.)
├── nixos/             # NixOS-specific modules
│   ├── system/        # NixOS system (users, locale, linux-only tools)
│   └── desktop/       # NixOS desktop (GPU, audio, fonts, hyprland)
├── darwin/            # macOS-specific modules
│   └── system.nix     # Darwin system (nix daemon, fish shell)
└── profile/           # NixOS orchestration (imports shared + nixos)
```

## Naming Convention

Pattern: `hex.<platform>.<scope>.<module>.enable`

### Platform (root)
- `hex.shared.*` — cross-platform, works on NixOS + macOS
- `hex.nixos.*` — NixOS-only
- `hex.darwin.*` — macOS-only

### Scope
- `*.system.*` — system-level (environment.systemPackages, services, etc.)
- `*.home.*` — home-manager level (home.packages, programs.*, etc.)

### Option Toggles

**System-level (`*.system.*`)**
- `hex.shared.nix.enable` — Nix package manager settings (GC, flakes, etc.)
- `hex.shared.system.enable` — cross-platform system tools (wget, curl, htop, btop)
- `hex.nixos.system.enable` — NixOS system (users, locale, linux-only tools)
- `hex.darwin.system.enable` — Darwin system (nix daemon, fish shell)

**Home-level (`*.home.*`)**
- `hex.shared.home.shell.enable` — fish, starship, zoxide, direnv
- `hex.shared.home.git.enable` — git, gh, lazygit, delta
- `hex.shared.home.editor.enable` — helix
- `hex.shared.home.dev.enable` — compilers, LSPs
- `hex.shared.home.packages.enable` — CLI tools
- `hex.shared.home.gpg.enable` — gpg-agent

**NixOS-only**
- `hex.nixos.desktop.enable` — desktop environment
  - `hex.nixos.desktop.hyprland.enable` — Hyprland compositor
  - `hex.nixos.desktop.audio.enable` — audio stack
  - `hex.nixos.desktop.fonts.enable` — fonts

## Important Rules
- **Architecture changes must update AGENTS.md** — When modifying module structure, options, or adding/removing modules, update this file first
- Shared modules must be cross-platform (no Linux-only or macOS-only packages)
- Platform-specific modules go in `nixos/` or `darwin/` directories
- Naming must follow `hex.<platform>.<scope>.<module>.enable` pattern

## Scripts
- `sudo-proxy` — Run commands with proxy (cross-platform)
- `unquarantine` — Remove macOS quarantine attribute from apps (macOS-only)
- `set-chezmoi-dir` - Sets chezmoi working repository for to self diectory
