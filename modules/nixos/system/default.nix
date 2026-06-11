{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  cfg = config.hex.nixos.system;
in {
  imports = [
    ./tools.nix
  ];

  options.hex.nixos.system = {
    enable = lib.mkEnableOption "NixOS system (users, locale, nix settings)";
    tools = {
      enable = lib.mkEnableOption "linux-only system tools (lshw, pciutils, etc.)";
      monitoring = lib.mkEnableOption "monitoring tools (psmisc, powertop, atop, iotop)" // {default = true;};
      hardware = lib.mkEnableOption "hardware tools (lshw, pciutils, usbutils, etc.)" // {default = true;};
      network = lib.mkEnableOption "network tools (rustnet, wavemon, vnstat, etc.)" // {default = true;};
      graphics = lib.mkEnableOption "graphics tools (vulkan-tools, clinfo, mesa-demos)" // {default = true;};
    };
  };

  config = lib.mkIf cfg.enable {
    hex.nixos.system.tools.enable = lib.mkDefault true;
    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.fish;
    };

    i18n.defaultLocale = "zh_CN.UTF-8";

    # NixOS-specific GC schedule (systemd calendar format)
    nix.gc.dates = "weekly";

    programs.fish.enable = true;
    # FIXME: nix-ld enabled but no packages used yet
    programs.nix-ld.enable = true;
    services.vnstat.enable = true;

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
      (writeShellScriptBin "set-chezmoi-dir" (builtins.readFile (self + "/scripts/set-chezmoi-dir.sh")))
    ];
  };
}
