# AGENTS.md

## Build & Test
- Switch (NixOS): `nh os switch . -H <hostname>`
- Switch (macOS): `nh darwin switch . -H <hostname>`
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
  - `hex.nixos.system.tools.enable` — linux-only system tools (lshw, pciutils, etc.)
    - `hex.nixos.system.tools.monitoring` — monitoring tools (psmisc, powertop, atop, iotop)
    - `hex.nixos.system.tools.hardware` — hardware tools (lshw, pciutils, usbutils, etc.)
    - `hex.nixos.system.tools.network` — network tools (rustnet, wavemon, vnstat, etc.)
    - `hex.nixos.system.tools.graphics` — graphics tools (vulkan-tools, clinfo, mesa-demos)
- `hex.darwin.system.enable` — Darwin system (nix daemon, fish shell)
  - `hex.darwin.system.fonts.enable` — Darwin font management (Maple Mono NF CN)

**Home-level (`*.home.*`)**
- `hex.shared.home.shell.enable` — fish, starship, zoxide, direnv
- `hex.shared.home.git.enable` — git, gh, lazygit, delta
- `hex.shared.home.editor.enable` — helix
- `hex.shared.home.dev.enable` — compilers, LSPs
- `hex.shared.home.packages.enable` — CLI tools
  - `hex.shared.home.packages.systemTools` — system tools (age, sops, gnupg, chezmoi)
  - `hex.shared.home.packages.dataProcessing` — data processing (pv, bc, jq, yq)
  - `hex.shared.home.packages.fileTools` — file tools (ouch, p7zip, yazi, eza, bat, etc.)
  - `hex.shared.home.packages.mediaUtils` — media utilities (ffmpeg, mediainfo, yt-dlp)
  - `hex.shared.home.packages.network` — network tools (whois, iperf3, asn, dnsutils)
  - `hex.shared.home.packages.beautify` — beautify tools (fastfetch, hyfetch)
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
- **Desktop GUI apps with built-in settings editors should NOT use home-manager for config management** — Let their internal settings editor be the source of truth. Use chezmoi or plain file install instead. Applies to apps like vesktop, vscodium, and desktop shells with GUI settings panels.

## Dotfiles Management

### Architecture
- **Config source of truth**: `dotfiles/dot_config/` — all real configuration files live here
- **Symlink templates**: `dotfiles/Library/Application Support/` — only symlink targets, never actual code

### Pattern: Cross-platform App Config

**For single-file configs (e.g. hyfetch):**
```
dotfiles/
├── dot_config/
│   └── hyfetch.json              # Real config
└── Library/
    └── Application Support/
        └── symlink_hyfetch.json.tmpl   # Content: {{ .chezmoi.sourceDir }}/dot_config/hyfetch.json
```

**For directory-based configs (e.g. vesktop):**
```
dotfiles/
├── .chezmoiignore                      # Platform-specific ignore rules
├── dot_config/
│   └── vesktop/
│       ├── settings.json               # Symlinkable (single file)
│       ├── settings/                   # Managed by chezmoi directly
│       └── themes/                     # Managed by chezmoi directly
├── Library/Application Support/        # macOS only
│   └── vesktop/
│       ├── symlink_settings.json.tmpl
│       ├── settings/
│       └── themes/
└── AppData/Roaming/                    # Windows only
    └── vesktop/
        ├── symlink_settings.json.tmpl
        ├── settings/
        └── themes/
```

**Note:** Use regular directory (not `exact_`) for apps like vesktop that write runtime files (session.bin, cache, etc.) into the config directory.

**Symlink template format:**
- File: `symlink_<filename>.json.tmpl`
- Content: `{{ .chezmoi.sourceDir }}/dot_config/<app>/<path>`

**Important:** Chezmoi does NOT support directory-level symlinks. Directories must be managed directly by chezmoi (`chezmoi add --exact --recursive`).

### Directory Sync with `exact_` Prefix

For directories that need strict synchronization (where removed files should be cleaned up), use the `exact_` prefix:

```
dotfiles/dot_config/exact_vesktop/
├── settings.json
├── settings/
└── themes/
```

**Behavior:**
- Without `exact_`: Chezmoi adds managed files but leaves extra files untouched (additive)
- With `exact_`: Chezmoi makes target an exact mirror, removing unmanaged files (synchronized)

**Use `exact_` when:**
- Directory contains only managed files (no runtime/cache files)
- You want removed source files to be cleaned up on target
- Example: theme directories, script collections

**Avoid `exact_` when:**
- App writes runtime files into the same directory
- Directory contains session data, caches, or logs
- Example: most app config directories (vesktop has session.bin, etc.)

**For apps with runtime files (e.g. vesktop):**
- Use regular directory (no `exact_`)
- Only symlink individual config files
- Let runtime files exist naturally in target directory

### Rules
- **NEVER** put actual config code in `Library/Application Support/` — only symlink templates
- **ALWAYS** edit config files in `dotfiles/dot_config/<app>/`
- **Symlink template naming**: `symlink_<filename>.json.tmpl` for JSON configs
- **Relative path**: macOS uses `../../.config/` to go up from `Library/Application Support/`

### Adding New App Config

1. Create config directory: `dotfiles/dot_config/<app>/`
2. Add config files to that directory
3. Create symlink template at `dotfiles/Library/Application Support/<app>/symlink_<filename>.json.tmpl`
4. Template content: conditional path based on OS (see pattern above)

## Scripts
- `sudo-proxy` — Run commands with proxy (cross-platform)
- `unquarantine` — Remove macOS quarantine attribute from apps (macOS-only)
- `set-chezmoi-dir` - Sets chezmoi working repository for to self diectory
