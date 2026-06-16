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
    systemTools = lib.mkEnableOption "system tools (age, sops, gnupg, chezmoi)" // {default = false;};
    dataProcessing = lib.mkEnableOption "data processing tools (pv, bc, jq, yq)" // {default = false;};
    fileTools = lib.mkEnableOption "file tools (ouch, p7zip, yazi, eza, bat, etc.)" // {default = false;};
    mediaUtils = lib.mkEnableOption "media utilities (ffmpeg, mediainfo, yt-dlp)" // {default = false;};
    network = lib.mkEnableOption "network tools (whois, iperf3, asn, dnsutils)" // {default = false;};
    beautify = lib.mkEnableOption "beautify tools (fastfetch, hyfetch)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs;
        (
          # system tools
          lib.optionals cfg.systemTools [
            age
            sops
            gnupg
            chezmoi
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
            ouch # all in one zip / unzip tool
            p7zip
            yazi
            hexyl
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
              if pkgs.stdenv.hostPlatform.isDarwin
              then pkgs.sox_ng.override {enableLadspa = false;}
              else pkgs.sox_ng
            )
            mediainfo
            exiftool
            yt-dlp
          ]
        )
        ++ (
          # network
          lib.optionals cfg.network [
            whois
            iperf3
            asn
            dnsutils
            netcat
          ]
        )
        ++ (
          # beautify
          lib.optionals cfg.beautify [
            # hollywood
            asciinema
            fastfetch
            hyfetch
          ]
        );
    };
  };
}
