# Installation Guide

This repo uses [disko](https://github.com/nix-community/disko) for declarative disk partitioning. Every host with a `disko-config.nix` can be installed with one of the methods below.

## Prerequisites

- Boot from a NixOS minimal ISO (or any Linux with Nix installed for nixos-anywhere)
- Internet access
- Know which disk device to use (e.g. `/dev/sda`, `/dev/nvme0n1`)

> **Live-CD**: The NixOS installer ISO does **not** enable `flakes` or `nix-command` by default.
> If you see errors like `experimental feature 'nix-command' is disabled`,
> run this first:
> ```bash
> export NIX_CONFIG="experimental-features = nix-command flakes"
> ```

> **⚠️ `--dry-run` caveat**: `disko --dry-run` does NOT simulate or preview — it just prints the script path
> that would be executed, then exits. It does NOT show what partitions would change.
> See [disko#1205](https://github.com/nix-community/disko/issues/1205) for a real data-loss case.
> Always test in a VM first.

## Available Hosts

| Host | Platform | Disko | Hardware |
|------|----------|-------|----------|
| `thinkpad` | NixOS | ✅ `hosts/thinkpad/disko-config.nix` | Lenovo ThinkPad T14 (Intel) |
| `wsl` | NixOS (WSL) | ❌ (WSL doesn't need partitioning) | WSL2 |
| `vmware` | NixOS | ✅ `hosts/vmware/disko-config.nix` | VMware VM |
| `neo` | macOS (nix-darwin) | ❌ (macOS manages its own disk) | Apple Silicon Mac |

---

## Method 1: disko-install (recommended for first install)

**ENSURE YOU HAVE ENOUGH MEMORY TO DOWNLOAD THE PACKAGES INTO THE RAMDISK!!!**

[`disko-install`](https://github.com/nix-community/disko/blob/master/docs/disko-install.md) combines partitioning, formatting, mounting, and `nixos-install` into a single command.

### Options

- `--write-efi-boot-entries` — Write EFI boot entries to NVRAM (use if booting from this disk directly)
- `--dry-run` — Print what would be done without executing
- `--disk main /dev/sda` — Map the disko disk named `main` to device `/dev/sda`

### Local flake (if you cloned the repo)

```bash
# From the repo root
# Replace <host> with one of: thinkpad, vmware
# Replace /dev/sda with the actual disk device

sudo nix run github:nix-community/disko/latest#disko-install -- \
  --flake '.#<host>' \
  --disk main /dev/sda
```

---

## Method 2: disko + nixos-install (traditional two-step)

Use this if you want to inspect the result before installing, or if disko-install doesn't work for your case.

### Step 1: Partition and mount

```bash
# Dry-run first — see what disko would do
sudo nix run github:nix-community/disko/latest -- \
  --dry-run \
  --mode destroy,format,mount \
  hosts/vmware/disko-config.nix

# Then actually run it
sudo nix run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  hosts/vmware/disko-config.nix
```

> **--mode breakdown**:
> - `destroy` — wipe existing partition tables
> - `format` — create partitions and filesystems
> - `mount` — mount at `/mnt`
> - `destroy,format,mount` — all three (previously called `disko` mode)

### Step 2: Install NixOS

```bash
# Clone the repo to /mnt if needed
nix shell nixpkgs#git --command git clone https://codeberg.org/hexzii/nixos-config /mnt/etc/nixos

# Generate hardware config (optional — the disko module handles filesystems)
nixos-generate-config --root /mnt --no-filesystems

# Install
nixos-install --root /mnt --flake '/mnt/etc/nixos#vmware'
```

---

## Method 3: nixos-anywhere (remote install)

For installing to a remote machine via SSH. The target must be booted into a NixOS installer (or any Linux with kexec support).

```bash
# Replace root@<ip> with the target
nix run github:nix-community/nixos-anywhere -- \
  --flake '.#vmware' \
  --target-host root@192.168.1.100
```

Optionally generate hardware config:

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake '.#vmware' \
  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
  --target-host root@192.168.1.100
```

---

## Post-install

After rebooting into the new system, run the first switch:

```bash
sudo nh os switch . -H vmware
```

### Dotfiles (chezmoi)

If `hex.shared.home.packages.systemTools = true` (installs chezmoi), wire up chezmoi to manage dotfiles from this repo:

```bash
# From the repo root
set-chezmoi-dir
chezmoi apply
```

> This sets chezmoi's `sourceDir` to the current directory and applies all dotfiles (Hyprland config, vesktop themes, etc.).

### Input method (Chinese/Japanese)

If `hex.nixos.system.ime.enable = true` with `rimeSchema = "wanxiang"` (default), download the grammar model after first login:

```bash
rime-wanxiang-grammar
```

Then deploy Rime to apply: `fcitx5-configtool` → Addons → Rime → Deploy.

> `rimeSchema = "ice"` does not need this step.
