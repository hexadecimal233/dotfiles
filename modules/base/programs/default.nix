# programs 聚合 — 自动引入所有程序包
{...}: {
  imports = [
    ./development.nix
    ./monitoring.nix
    ./networking.nix
  ];
}
