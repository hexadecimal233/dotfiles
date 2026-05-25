# 编排入口 — 系统只需导入此模块 + 配置选项即可，
# 无需手动逐个导入 base / desktop-infra / apps / home。
{lib, ...}: {
  imports = [
    ../base
    ../desktop/infra
    ../desktop/apps
    ../home
  ];

  options.hexzii.profile = {
    desktopInfra = lib.mkEnableOption "desktop infrastructure (audio, fonts, graphics, etc.)";

    desktopApps = lib.mkEnableOption "desktop applications";

    home = lib.mkEnableOption "home-manager user environment";
  };
}
