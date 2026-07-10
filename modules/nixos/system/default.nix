{lib, ...}: {
  imports = [
    ./tools.nix
    ./boot.nix
    ./networking.nix
    ./wireless.nix
    ./kernel.nix
    ./power.nix
    ./graphics.nix
    ./security.nix
    ./time.nix
    ./ime.nix
    ./mobile.nix
    ./base.nix
  ];

  options.hex.nixos.system = {
    enable = lib.mkEnableOption "NixOS system (users, locale, nix settings)";
  };
}
