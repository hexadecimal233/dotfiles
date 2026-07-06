{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.shared.home.packages;
in {
  options.hex.shared.home.packages = {
    enable = lib.mkEnableOption "CLI tools and utilities";
    systemTools = lib.mkEnableOption "system tools" // {default = false;};
    dataProcessing = lib.mkEnableOption "data processing tools" // {default = false;};
    fileTools = lib.mkEnableOption "file tools" // {default = false;};
    mediaUtils = lib.mkEnableOption "media utilities" // {default = false;};
    network = lib.mkEnableOption "network tools" // {default = false;};
    beautify = lib.mkEnableOption "beautify tools" // {default = false;};
    hosting = lib.mkEnableOption "temp-hosted service tools" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs;
        (
          # system tools
          lib.optionals cfg.systemTools [
            age
            sops
            chezmoi

            # benchmarking / profiling
            inferno
            hyperfine
            hashcat # on macos try to use -d 1 to force metal
            clinfo # TODO: move to separate

            # android devices
            android-tools
            scrcpy

            asciinema
            fastfetch
            stress-ng
          ]
        )
        ++ (
          # data processing
          lib.optionals cfg.dataProcessing [
            pv
            progress
            bc
            jq
            yq
          ]
        )
        ++ (
          # file tools
          lib.optionals cfg.fileTools [
            unrar
            ouch-rar # all in one zip / unzip tool
            dos2unix # crlf -> lf
            qpdf # pdf toolkit
            _7zip-zstd-rar
            yazi
            hexyl
            hexedit
            lnav
            file
            eza
            bat

            # file finding tools
            ncdu
            ripgrep
            fd
            fzf
          ]
        )
        ++ (
          # media utils
          lib.optionals cfg.mediaUtils [
            ffmpeg-full
            (
              if pkgs.stdenv.hostPlatform.isDarwin # TODO: remove this line after upstream has merged the pr
              then pkgs.sox_ng.override {enableLadspa = false;}
              else pkgs.sox_ng
            )
            mediainfo
            exiftool
            yt-dlp
            # compression
            pngquant # lossy png
            oxipng # lossless png
            mozjpeg
          ]
        )
        ++ (
          # network
          lib.optionals cfg.network [
            whois
            iperf3
            asn
            dnsutils
            doggo
            netcat
            nmap
            k6
          ]
        )
        ++ (
          # beautify & fun
          lib.optionals cfg.beautify [
            # hollywood broken
            hyfetch
            cowsay
            lolcat
            figlet
            terminal-parrot
          ]
        )
        ++ (
          # hosting
          lib.optionals cfg.hosting [
            copyparty # file server. openlist better as service and hfs is too old
            frp # fast reverse proxy client (as package)
          ]
        );
    };
  };
}
