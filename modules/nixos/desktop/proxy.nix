# Desktop proxy: Clash Verge (mihomo kernel, GUI)
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.nixos.desktop.proxy.clash;
in {
  options.hex.nixos.desktop.proxy.clash = {
    enable =
      lib.mkEnableOption "Clash Verge proxy (mihomo kernel, tray app)"
      // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    # Clash Verge — GUI proxy client with mihomo kernel
    programs.clash-verge = {
      enable = true;
      serviceMode = true;
      tunMode = true;
      autoStart = true;
    };

    # --- pure mihomo (headless, no GUI) ---
    /*
    services.mihomo = {
      enable = true;
      tunMode = true;
      # TODO: add a config
    };
    */
  };
}
