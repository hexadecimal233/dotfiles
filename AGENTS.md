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
.
├── flake.nix               # Entry point + flake inputs
├── AGENTS.md               # This file
├── INSTALL.md              # Global installation guide
├── justfile                # Task runner
├── modules/
│   ├── shared/             # Cross-platform modules
│   │   ├── home/           # HM: shell, git, editor, dev, packages, gpg
│   │   ├── system/         # Cross-platform system tools
│   │   └── nix.nix         # Nix package manager settings
│   ├── nixos/              # NixOS-specific modules
│   │   ├── system/         # NixOS system (users, locale, boot, networking, etc.)
│   │   │   ├── default.nix     # Core system option
│   │   │   ├── tools.nix       # CLI tools (monitoring, hardware, network)
│   │   │   ├── boot.nix        # GRUB bootloader
│   │   │   ├── fingerprint.nix # fprintd + PAM
│   │   │   ├── networking.nix  # NetworkManager, vnstat, ethtool
│   │   │   ├── wireless.nix    # Bluetooth, bluez
│   │   │   ├── power.nix       # UPower, power-profiles-daemon (not TLP)
│   │   │   ├── graphics.nix    # hardware.graphics, Vulkan, Mesa, ddcutil
│   │   │   ├── security.nix    # polkit
│   │   │   ├── time.nix        # timezone (auto or static)
│   │   │   ├── ime.nix         # fcitx5 + Rime + Mozc
│   │   │   └── ios.nix         # libimobiledevice + usbmuxd
│   │   └── desktop/        # NixOS desktop (audio, fonts, wm)
│   │       ├── default.nix     # desktop.enable + imports
│   │       ├── audio.nix       # PipeWire / PulseAudio
│   │       ├── fonts.nix       # Fonts + fontconfig
│   │   ├── wm.nix          # Hyprland compositor (config via chezmoi)
│   │   ├── proxy.nix       # Clash Verge proxy (mihomo kernel)
│   │   └── home/           # NixOS-exclusive HM desktop modules
│   │           ├── default.nix     # hex.nixos.home.desktop
│   │           ├── noctalia.nix    # Noctalia v5 desktop shell
│   │           ├── packages.nix    # Desktop GUI packages (ghostty, firefox, ...)
│   │           └── theme.nix       # Desktop theming (Papirus icons, Bibata cursor)
│   └── darwin/             # macOS-specific
│       ├── default.nix         # Darwin orchestration
│       ├── home.nix            # HM integration (darwin variant)
│       ├── system.nix          # nix daemon, fish
│       └── system/
│           └── fonts.nix       # macOS font management
├── hosts/                 # Host configurations (was systems/)
│   ├── thinkpad/
│   ├── wsl/
│   ├── vmware/
│   └── darwin/
├── dotfiles/              # Chezmoi-managed dotfiles
│   ├── .chezmoiroot
│   ├── .chezmoiignore
│   └── dot_config/
├── scripts/               # Standalone Nix scripts
│   ├── audit.nix          # Hex config tree printer
│   ├── sudo-proxy.sh
│   ├── set-chezmoi-dir.sh
│   └── unquarantine.sh
└── systems/               # (renamed to hosts/)
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
- `hex.nixos.system.enable` — NixOS system (users, locale, nix settings)
  - `hex.nixos.system.tools.enable` — linux-only system tools
    - `hex.nixos.system.tools.monitoring` — psmisc, atop, iotop
    - `hex.nixos.system.tools.hardware` — lshw, pciutils, usbutils, dmidecode, etc.
    - `hex.nixos.system.tools.network` — rustnet, wavemon
  - `hex.nixos.system.boot.enable` — GRUB bootloader (UEFI)
  - `hex.nixos.system.fingerprint.enable` — fprintd with PAM sudo/login
  - `hex.nixos.system.networking.enable` — NetworkManager, vnstat, ethtool, iproute2
  - `hex.nixos.system.wireless.enable` — Bluetooth, bluez
  - `hex.nixos.system.power.enable` — UPower, power-profiles-daemon, powertop
  - `hex.nixos.system.graphics.enable` — hardware.graphics, vulkan-tools, clinfo, mesa-demos, ddcutil, brightnessctl
  - `hex.nixos.system.security.enable` — polkit
  - `hex.nixos.system.time.auto` — automatic timezone via geoclue2 (automatic-timezoned)
  - `hex.nixos.system.time.timezone` — static timezone string (e.g. "Asia/Shanghai")
  - `hex.nixos.system.ime.enable` — fcitx5 input method (Rime Chinese + Mozc Japanese)
    - `hex.nixos.system.ime.rimeSchema` — Rime schema: "wanxiang" (万象拼音) or "ice" (雾凇拼音)
  - `hex.nixos.system.ios.enable` — iOS device support (libimobiledevice, usbmuxd, ifuse, idevicerestore)
- `hex.darwin.system.enable` — Darwin system (nix daemon, fish shell)
  - `hex.darwin.system.fonts.enable` — Darwin font management (Maple Mono NF CN)

**Home-level (`*.home.*`)**
- `hex.shared.home.shell.enable` — fish, starship, zoxide, direnv
- `hex.shared.home.git.enable` — git, gh, lazygit, delta
- `hex.shared.home.editor.enable` — helix
- `hex.shared.home.dev.enable` — compilers, LSPs
- `hex.shared.home.java.enable` — Java ecosystem (JDK, build tools, LSP)
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
  - `hex.nixos.desktop.hyprland.enable` — Hyprland compositor (config via chezmoi)
  - `hex.nixos.desktop.audio.enable` — audio stack
  - `hex.nixos.desktop.fonts.enable` — fonts
  - `hex.nixos.desktop.proxy.verge.enable` — Clash Verge proxy (mihomo kernel)

**NixOS-exclusive home-manager desktop**
- `hex.nixos.home.desktop.noctalia.enable` — Noctalia v5 Wayland desktop shell
- `hex.nixos.home.desktop.packages.enable` — Desktop GUI packages (ghostty, firefox, vesktop, ...)
- `hex.nixos.home.desktop.theme.enable` — Desktop theming (Papirus icons, Bibata/AOSP cursor)

## Important Rules
- **Architecture changes must update AGENTS.md** — When modifying module structure, options, or adding/removing modules, update this file first
- Shared modules must be cross-platform (no Linux-only or macOS-only packages)
- Platform-specific modules go in `nixos/` or `darwin/` directories
- Naming must follow `hex.<platform>.<scope>.<module>.enable` pattern
- **Desktop GUI apps with built-in settings editors should NOT use home-manager for config management** — Let their internal settings editor be the source of truth. Use chezmoi or plain file install instead. Applies to apps like vesktop, vscodium, and desktop shells with GUI settings panels.
- **Run `just audit <host>` after enabling any new hex.* option** — The module system doesn't warn you if you forgot to enable a parent option or missed a sub-option. Always verify with audit that the intended options are actually enabled on the target host.

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
- `audit.nix` — Standalone hex config tree printer: `just audit <host>`
- `sudo-proxy` — Run commands with proxy (cross-platform)
- `unquarantine` — Remove macOS quarantine attribute from apps (macOS-only)
- `set-chezmoi-dir` - Sets chezmoi working repository for to self diectory

### Just Commands
- `just fmt` — Format with alejandra
- `just check` — Nix flake check
- `just diff` — Compare current/result system
- `just update` — Update flake lockfile
- `just tree` — Nix-tree analysis
- `just info` — List generations + flake metadata
- `just audit <host>` — Print hex option tree for a host
