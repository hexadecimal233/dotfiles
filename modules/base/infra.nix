# essential system stuff
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # composing
    gnumake
    just # make but better
    docker-compose

    # programming
    nodejs_24
    nixd
    just-lsp
  ];
}
