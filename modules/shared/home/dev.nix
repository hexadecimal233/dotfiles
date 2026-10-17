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
      home.packages = with pkgs; [
        # am not sure gpg agent can run or not
        nixd
        nh
        bc
        _7zip-zstd-rar
        file
        whois
        dnsutils
        # hyprpicker
        # unrar
        # dos2unix # crlf -> lf
        # copyparty # file server (openlist/hfs alternatives)
        # zip
        # unzip
      ];
    };
  };
}
