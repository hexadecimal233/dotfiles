#!/usr/bin/env bash
#
# brew-install.sh — Homebrew equivalent of the active packages in
# modules/shared/home/dev.nix (nixpkgs -> homebrew mapping, de-nixdarwin pass).
#
# Usage:  bash brew-install.sh        # installs formulae + casks
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew not found" >&2
  exit 1
fi

# ---- formulae (nixpkgs -> brew) ---------------------------------------------
FORMULAE=(
  alejandra            # alejandra
  tokei                # tokei
  tio                  # tio
  node                 # nodejs_26
  pnpm                 # pnpm
  uv                   # uv
  betterleaks          # betterleaks
  sequoia-chameleon-gnupg # sequoia-chameleon-gnupg
  sequoia-sq           # sequoia-sq
  fish                 # fish
  starship             # starship
  carapace             # carapace
  zoxide               # zoxide
  direnv               # direnv
  mise                 # mise
  tmux                 # tmux
  zellij               # zellij
  nushell              # nushell
  helix                # helix
  difftastic           # difftastic
  git-lfs              # git-lfs
  git                  # git
  gh                   # gh
  prek                 # prek
  jj                   # jujutsu
  git-delta            # delta
  age                  # age
  sops                 # sops
  chezmoi              # chezmoi
  hyperfine            # hyperfine
  fastfetch            # fastfetch
  stress-ng            # stress-ng
  pv                   # pv
  progress             # progress
  bc                   # bc
  jq                   # jq
  yq                   # yq
  ouch                 # ouch-rar  (brew 版默认不含 rar——无 rar 就忍了; rar 场景留 nix)
  # _7zip-zstd-rar: no brew equivalent (brew lacks a zstd-enabled 7z) -> kept on nix, see tail
  yazi                 # yazi
  hexedit              # hexedit
  lnav                 # lnav
  file                 # file
  eza                  # eza
  bat                  # bat
  ncdu                 # ncdu
  ripgrep              # ripgrep
  fd                   # fd
  fzf                  # fzf
  ffmpeg               # ffmpeg-full
  # sox_ng: no brew fork (brew only has the unmaintained original `sox`) -> kept on nix, see tail
  exiftool             # exiftool
  yt-dlp               # yt-dlp
  whois                # whois
  iperf3               # iperf3
  asn                  # asn
  doggo                # doggo
  netcat               # netcat
  nmap                 # nmap
  k6                   # k6
  hyfetch              # hyfetch
  wget                 # wget
  curl                 # curl
  htop                 # htop
  btop                 # btop
  lsof                 # lsof
  rsync                # rsync
  rclone               # rclone
  just                 # just
  python               # python3
)

# ---- casks ------------------------------------------------------------------
CASK_FORMULAE=(
  android-platform-tools # android-tools
)

echo "==> Installing formulae: ${FORMULAE[*]}"
brew install "${FORMULAE[@]}"

echo "==> Installing casks: ${CASK_FORMULAE[*]}"
brew install --cask "${CASK_FORMULAE[@]}"

echo "==> Done."

# ─────────────────────────────────────────────────────────────────────────────
# 注：以下 nixpkgs 包在 Homebrew 中无匹配（未安装，仍靠 nixpkgs/nix 提供）：
#   nixd            Nix language server，brew 无 formula
#   nix-direnv      direnv 的 nix flake 缓存插件（配合 direnv 使用，非独立包）
#   inferno         无对应 formula（brew 只有无关的 infra）
#   nh              nix 生态 helper，brew 无 formula
#   dnsutils        macOS 自带 dig / nslookup（系统 bind），一般无需再装
#   minicom         已从 dev.nix 删除（不在激活集内）
#   _7zip-zstd-rar  需要 zstd + rar 的 7z 构建；brew 只有官方 sevenzip(无 zstd) 或旧版 p7zip，均不匹配 -> 留 nix
#   sox_ng          brew 无 sox_ng 分支，只有停更的原版 sox；需要维护中的 fork 则留 nix
# ─────────────────────────────────────────────────────────────────────────────
