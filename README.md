# nixos-config

My NixOS configuration.

## you know the rules and so do i

wip

currently reference to [AGENTS.md](./AGENTS.md)

## what im doing rn

- [x] multihost
- [ ] split dotfiles and nix cfg

## git commit hooks

we use `prek` for git hooks, install via:

```bash
prek install
```

## linux install guide

what is necessary before installation:

- set trusted user for proper cache download (run as root solves)
- installing via Live-CD does **not** enable experimental features by default
- a proper net
- a decent amout of ram to prevent ram blast (~24G packages for now on my thinkpad, your final warning)
- maybe more...

first we set experimental variables

```bash
# set experimental values
export NIX_CONFIG="experimental-features = nix-command flakes pipe-operators"
```

the following steps may wipe all data.

may test partitioning in a vm.

### PATH A - disko-install

clone the repo and `cd` to my directory.

```bash
# Replace <host> with the host
# Replace /dev/sda with the actual disk device
# PS: will still download packages, but do it **FIRST**
sudo nix run github:nix-community/disko/latest#disko-install -- \
  --flake '.#<host>' \
  --disk main /dev/nvme0n1 \
  --dry-run
```

### PATH B - nixos-install + disko

this is for minimal system boot and low ram pcs

#### step 1 : partitioning & mounting to /mnt

```bash
# Dry-run first — see what disko would do
sudo nix run github:nix-community/disko/latest -- \
  --dry-run \
  --mode destroy,format,mount \
  hosts/<host>/disko-config.nix

# Then actually run it
sudo nix run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  hosts/<host>/disko-config.nix
```

#### step 2: install!!

```bash
# Clone the repo
nix shell nixpkgs#git --command git clone https://codeberg.org/hexzii/nixos-config /mnt/home/hexzii/projects/nixos-config

# Generate hardware config (optional — the disko module handles filesystems)
nixos-generate-config --root /mnt --no-filesystems

# Install
nixos-install --root /mnt --flake '/mnt/etc/nixos#your-os'
```

## ugreen nas install

similar to normal nixos install, partition your disk, run nixos-install.

---

reference to [nasdots](https://github.com/daskladas/nasdots), there are some different behaviors:

1. you do not have to actually replace the systemd-boot, the efi boot entries can still be written and set to the first boot priority in ugreen bios.
2. make sure to disable bios watchdog (currently didnt figure out how to feed the watchdog gracefully)
3. back up your boot disk (often named `/dev/mmcblk0p1`), but the factory partition flag of the esp seemed to be `linux-filesystem`, this may break installation, make sure to set it as `EF00` (efi system partition) before installing.

---

if you have trouble booting up / stuck, either:

- use live cd to troubleshoot (via `nixos-enter` or re-install), always use `nixos-switch boot` on live cds.
- use boot parameters: `rd.systemd.break=pre-mount rd.systemd.debug_shell systemd.debug_shell`

## remote install

WIP

## post-install

use `nh os switch(boot on linux) . -H <hostname>` to switch generations.

### setup chezmoi

enter tty so desktop customization could apply smoothly

```bash
# From the repo root
set-chezmoi-dir
chezmoi apply
```

> this sets chezmoi's `sourceDir` to the current directory and applies all dotfiles
