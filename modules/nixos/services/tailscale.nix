{
  config,
  lib,
  ...
}: {
  options.hex.nixos.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale client daemon" // {default = false;};
  };

  config = lib.mkIf config.hex.nixos.services.tailscale.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
