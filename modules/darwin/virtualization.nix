# docker + colima for macOS
{
  lib,
  config,
  pkgs,
  ...
}: {
  options.hex.darwin.system.virtualization = {
    enable = lib.mkEnableOption "darwin virtualization (docker + colima)" // {default = false;};
  };

  config = lib.mkIf config.hex.darwin.system.virtualization.enable {
    environment.systemPackages = with pkgs; [
      colima
      docker
    ];
  };
}
