# Automatically allow specific unfree packages by name
{lib, ...}: {
  # Hardcoded allowlist — no enable toggle, always active
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "aseprite"
      "cavalry"
    ];
}
