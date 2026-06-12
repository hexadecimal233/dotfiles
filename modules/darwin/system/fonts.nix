{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hex.darwin.system.fonts;
in {
  options.hex.darwin.system.fonts = {
    enable = lib.mkEnableOption "darwin font management (Maple Mono NF CN)";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      maple-mono.NF-CN-unhinted
    ];
  };
}
