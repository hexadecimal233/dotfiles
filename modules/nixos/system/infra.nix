# dev infrastructure tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnumake
    nh
    just
    docker-compose
    python3
  ];
}
