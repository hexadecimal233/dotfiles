{
  config,
  lib,
  pkgs,
  wsl,
  ...
}: {
  imports = [
    wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "hexzii";
}
