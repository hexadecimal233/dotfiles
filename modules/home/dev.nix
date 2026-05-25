# development stuff
{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    alejandra
    nodejs_24
    uv # added
    # mise

    # lsps
    nixd
    just-lsp
  ];
}
