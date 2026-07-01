{
  self,
  config,
  pkgs,
  nasdots,
  ...
}: {
  imports = [
    self.nixosModules.nixos
    (nasdots + "/modules/fan-control.nix") # ugreen nas fan control
    ./hardware-configuration.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    time.timeZone = "Asia/Shanghai";

    networking.hostName = "nixnas";
    networking.useDHCP = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [22]; # TODO: limit access to local network (ipv6+v4 entry blocked)
      allowedUDPPorts = [];
      interfaces."enp2s0".allowedTCPPorts = [22]; # LAN 1
    };

    # hex options
    # TODO: unify
    hex.nixos.services.ssh.enable = true;
    hex.nixos.services.fail2ban.enable = true;
    hex.nixos.services.virtualization.enable = true;

    # TODO: WIP TODO: add tailscale & stiff
    hex.nixos.services.ddns-go = {
      enable = true;
      # interval = 300;
      # listen = ":9876";
    };

    # TODO: use global user settings
    # TODO: changeable username
    users.users.hexzii = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      initialPassword = "changeme";
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

    /*
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/data" ];
    };
    */

    environment.variables.TERM = "xterm-256color"; # terminal colors

    systemd.tmpfiles.rules = [
    ];

    system.stateVersion = "26.05";
  };
}
