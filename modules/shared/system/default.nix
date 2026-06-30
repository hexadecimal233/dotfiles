# cross-platform system tools
{lib, ...}: {
  imports = [
    ./tools.nix
    ./nix.nix
  ];

  options.hex.shared.system = {
    enable = lib.mkEnableOption "core system (nix settings, environment)";
  };
}
