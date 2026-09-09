{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.dev;
in {
  options.hex.shared.home.dev = {
    enable = lib.mkEnableOption "dev environment (compilers, LSPs)";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      # openpgp agent (gpg signing + ssh via hardware key)
      # services.gpg-agent = {
      # enable = true;
      # enableSshSupport = true;
      # pinentry.package =
      #  if pkgs.stdenv.hostPlatform.isDarwin
      #  then pkgs.pinentry_mac
      #  else pkgs.pinentry-gnome3; # or pinentry-qt
      # TODO: add an option to use curses on demand (e.g. ssh)
      # };

      home.packages = with pkgs; [
        # am not sure gpg agent can run or not
        /*
        # ── nix tooling ──────────────────────────────────────────────
        alejandra
        nixd
        tokei

        # ── serial / embedded ────────────────────────────────────────
        tio

        # ── node.js (global: npx/bunx) ───────────────────────────────
        nodejs_26
        pnpm

        # ── python / misc ────────────────────────────────────────────
        uv
        betterleaks

        # ── openpgp (sequoia) ────────────────────────────────────────
        sequoia-chameleon-gnupg # will override gpg comma
        sequoia-sq # still does not support pq :(

        # ── shell (fish & friends) ───────────────────────────────────
        fish # we need to fix fish ssh auth sock set -gx GPG_TTY (tty)
        starship
        carapace
        zoxide
        direnv
        nix-direnv # will do this later
        mise
        tmux
        zellij
        nushell
        helix

        # ── git ──────────────────────────────────────────────────────
        difftastic
        git-lfs
        git # todo: linux lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.gitFull
        gh
        prek # a pre-commit alternative
        jujutsu
        delta

        # ── system tools ─────────────────────────────────────────────
        age
        sops
        chezmoi

        # benchmarking / profiling
        inferno
        hyperfine

        # android devices
        android-tools

        fastfetch
        stress-ng

        # ── data processing ──────────────────────────────────────────
        pv
        progress
        bc
        jq
        yq

        # ── file tools ───────────────────────────────────────────────
        ouch-rar # all-in-one zip / unzip tool
        _7zip-zstd-rar
        yazi
        hexedit
        lnav
        file
        eza
        bat

        # file finding
        ncdu
        ripgrep
        fd
        fzf

        # ── media ────────────────────────────────────────────────────
        ffmpeg-full
        (
          if pkgs.stdenv.hostPlatform.isDarwin # TODO: remove after upstream merged the pr
          then pkgs.sox_ng.override {enableLadspa = false;}
          else pkgs.sox_ng
        )
        exiftool
        yt-dlp

        # ── network ──────────────────────────────────────────────────
        whois
        iperf3
        asn
        dnsutils
        doggo
        netcat
        nmap
        k6

        # ── misc / fun ───────────────────────────────────────────────
        hyfetch

        # ── system files / monitoring (from old tools module) ────────
        wget
        curl
        htop
        btop
        lsof
        rsync
        rclone
        nh
        just
        python3 # latest stable
        */

        # ─────────────────────────────────────────────────────────────
        # Disabled / candidates (uncomment to enable):
        # ─────────────────────────────────────────────────────────────
        # just-lsp
        # lua-language-server
        # emmylua-ls
        # rtk # token optimizer
        # lazygit
        # hyprpicker
        # xmrig
        # hashcat # on macos try -d 1 to force metal
        # clinfo # TODO: move to separate
        # scrcpy
        # asciinema
        # unrar
        # dos2unix # crlf -> lf
        # qpdf # pdf toolkit
        # hexyl
        # mediainfo
        # pngquant # lossy png
        # oxipng # lossless png
        # mozjpeg
        # cowsay
        # lolcat
        # figlet
        # terminal-parrot
        # copyparty # file server (openlist/hfs alternatives)
        # frp # fast reverse proxy client (as package)
        # tree
        # zip
        # unzip
      ];
    };
  };
}
