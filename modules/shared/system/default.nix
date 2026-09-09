# cross-platform system tools
{lib, ...}: {
  imports = [
    ./nix.nix
  ];

  options.hex.shared.system = {
    enable = lib.mkEnableOption "core system (nix settings, environment)";
  };
}
