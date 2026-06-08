{
  pkgs,
  lib,
  ...
}: {
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
}
