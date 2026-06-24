# docker + colima for macOS
{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hex.darwin.system.virtualization.enable {
    environment.systemPackages = with pkgs; [
      colima
      docker
    ];
  };
}
