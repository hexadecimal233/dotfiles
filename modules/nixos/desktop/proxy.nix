# Desktop proxy: Clash Verge (mihomo kernel)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.proxy.verge;
in {
  options.hex.nixos.desktop.proxy.verge = {
    enable =
      lib.mkEnableOption "Clash Verge proxy (mihomo kernel, tray app)"
      // {default = false;};
  };

  config = lib.mkIf (config.hex.nixos.desktop.enable && cfg.enable) {
    # Clash Verge — GUI proxy client with mihomo kernel
    # programs.clash-verge = {
    #   enable = true;
    #   serviceMode = true;
    #   tunMode = true;
    #   autoStart = true;
    # };

    # Allow mihomo TUN traffic through firewall
    # networking.firewall = {
    #   trustedInterfaces = ["Mihomo"];
    #   extraReversePathFilterRules = ''
    #     iifname { "Mihomo" } accept comment "trusted interface"
    #   '';
    # };
  };
}
