# nixos-config

My NixOS configuration.

## you know the rules and so do i

wip

currently reference to [AGENTS.md](./AGENTS.md)

## what im doing rn

- [x] multihost
- [ ] split dotfiles and nix cfg

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
nixos-install --root /mnt --flake '/mnt/etc/nixos#vmware'
```

## remote install

WIP

## install on darwin

WIP

unquarantine some apps: `unquarantine appname`

## post-install

use `nh os/darwin switch(boot on linux) . -H <hostname>` to switch generations.

### setup chezmoi

enter tty so desktop customization could apply smoothly

```bash
# From the repo root
set-chezmoi-dir
chezmoi apply
```
> this sets chezmoi's `sourceDir` to the current directory and applies all dotfiles
