# development stuff
{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    alejandra
    nodejs_24
  
    uv # added
    # mise

    go

    # infra
    gcc
    pkg-config

    # nodejs
    nodejs_24
    pnpm
    bun

    # rust
    # have done rustup component add rust-analyzer
    rustup # global rust manager

    # lsps
    nixd
    just-lsp
  ];

  # nodejs path
  home.sessionPath = lib.mkAfter ["$HOME/.bun/bin" "$HOME/go/bin"];
}
