{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.dev;
in {
  options.hex.shared.home.dev.enable = lib.mkEnableOption "dev environment (compilers, LSPs)";

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs; [
        alejandra
        nodejs_24
        uv
        # mise
        go

        # infra
        gcc
        pkg-config

        # nodejs
        pnpm
        bun

        # rust
        rustup

        # lsps
        nixd
        just-lsp
      ];

      home.sessionPath = lib.mkAfter ["$HOME/.bun/bin" "$HOME/go/bin"];
    };
  };
}
