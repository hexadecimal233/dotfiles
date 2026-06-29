{
  config,
  pkgs,
  nasdots,
  ...
}: {
  imports = [
    (nasdots + "/modules/fan-control.nix") # ugreen nas fan control
    ./hardware-configuration.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.gc.automatic = true;

    time.timeZone = "UTC";

    networking.hostName = "nixnas";
    networking.useDHCP = true;

    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "changeme";
    };

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "no";
    };

    environment.systemPackages = with pkgs; [
      vim
      htop
      mdadm
      nvme-cli
      smartmontools
      parted
      git
    ];

    system.stateVersion = "26.05";
  };
}
