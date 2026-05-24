# 开发工具包
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    vim
    gh
    docker-compose
    nodejs_24
    alejandra
    nixd
    just-lsp
  ];
}
