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
    ./boot.nix
    ./fingerprint.nix
    ./networking.nix
    ./wireless.nix
    ./power.nix
    ./graphics.nix
    ./security.nix
    ./time.nix
    ./ime.nix
    ./ios.nix
  ];

  options.hex.nixos.system = {
    enable = lib.mkEnableOption "NixOS system (users, locale, nix settings)";
    tools = {
      enable = lib.mkEnableOption "linux-only system tools (lshw, pciutils, etc.)";
      monitoring = lib.mkEnableOption "monitoring tools (psmisc, atop, iotop)" // {default = false;};
      hardware = lib.mkEnableOption "hardware tools (lshw, pciutils, usbutils, etc.)" // {default = false;};
      network = lib.mkEnableOption "extra network tools (rustnet)" // {default = false;};
    };
  };

  config = lib.mkIf cfg.enable {
    hex.nixos.system.tools.enable = lib.mkDefault false;
    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # root access
        "networkmanager" # wired/wireless mgmt
        "audio" # audio mgmt
        "jackaudio"
        "dialout" # external bus
        "docker" # docker mgmt
      ];
      shell = pkgs.fish;
      initialPassword = "123456";
    };

    console.font = "Uni3-Terminus16"; # tty cn font support

    i18n.defaultLocale = "zh_CN.UTF-8"; # TODO: split form this file

    # NixOS-specific GC schedule (systemd calendar format)
    nix.gc.dates = "weekly";

    programs.fish.enable = true;
    # FIXME: nix-ld enabled but no packages used yet
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sudo-proxy" (builtins.readFile (self + "/scripts/sudo-proxy.sh")))
      (writeShellScriptBin "escape" (builtins.readFile (self + "/scripts/escape.sh")))
      (writeShellScriptBin "set-chezmoi-dir" (builtins.readFile (self + "/scripts/set-chezmoi-dir.sh")))
    ];
  };
}
