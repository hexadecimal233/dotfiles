{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hex.shared.home.dev;
in {
  options.hex.shared.home.dev = {
    enable = lib.mkEnableOption "dev environment (compilers, LSPs)";
    nodejs = {
      enable = lib.mkEnableOption "Node.js ecosystem (nodejs, pnpm, bun)" // {default = false;};
    };
    ai = {
      enable = lib.mkEnableOption "AI / Vibe coding / AIGC stuff" // {default = false;};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.hexzii = {
      home.packages = with pkgs;
        [
          # nix
          alejandra
          nixd
          tokei

          # justfile
          just-lsp

          # lua
          lua-language-server
          # emmylua-ls
          #

          minicom
          tio

          # stuff
          uv
          betterleaks
          # godot.v
        ]
        ++ lib.optionals cfg.nodejs.enable [
          # nodejs (global: npx/bunx)
          nodejs_26
          pnpm
          bun
        ]
        ++ lib.optionals cfg.ai.enable [
          rtk # token optimizer
        ];
    };
  };
}
