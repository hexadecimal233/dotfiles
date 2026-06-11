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
    systemTools = lib.mkEnableOption "system tools (age, sops, gnupg, chezmoi)" // {default = true;};
    dataProcessing = lib.mkEnableOption "data processing tools (pv, bc, jq, yq)" // {default = true;};
    fileTools = lib.mkEnableOption "file tools (ouch, p7zip, yazi, eza, bat, etc.)" // {default = true;};
    mediaUtils = lib.mkEnableOption "media utilities (ffmpeg, mediainfo, yt-dlp)" // {default = true;};
    network = lib.mkEnableOption "network tools (whois, iperf3, asn, dnsutils)" // {default = true;};
    beautify = lib.mkEnableOption "beautify tools (fastfetch, hyfetch)" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; (
        # system tools
        lib.optionals cfg.systemTools [
          age
          sops
          gnupg
          chezmoi
        ]
      ) ++ (
        # data processing
        lib.optionals cfg.dataProcessing [
          pv
          bc
          jq
          yq
        ]
      ) ++ (
        # file tools
        lib.optionals cfg.fileTools [
          ouch
          p7zip
          yazi
          hexyl
          lnav
          ncdu
          file
          eza
          bat
          ripgrep
          fd
          fzf
        ]
      ) ++ (
        # media utils
        lib.optionals cfg.mediaUtils [
          ffmpeg-full
          mediainfo
          yt-dlp
        ]
      ) ++ (
        # network
        lib.optionals cfg.network [
          whois
          iperf3
          asn
          dnsutils
        ]
      ) ++ (
        # beautify
        lib.optionals cfg.beautify [
          # hollywood
          fastfetch
          hyfetch
        ]
      );
    };
  };
}
