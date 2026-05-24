{pkgs, ...}: {
  imports = [
    ./tools.nix
    ./infra.nix
  ];

  system.stateVersion = "25.11";

  users.users.hexzii = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish; # set up user shell
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "zh_CN.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"]; # enable experimental features
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.fish.enable = true; # use system shell
  programs.nix-ld = {
    enable = true;
    # currently no packages used
  };
  services.vnstat.enable = true;

  environment.systemPackages = with pkgs; [
    # sudo with proxy
    (writeShellScriptBin "sudo-proxy" (builtins.readFile ../../scripts/sudo-proxy.sh))
  ];
}
