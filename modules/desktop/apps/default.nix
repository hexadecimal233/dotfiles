# 桌面应用（待扩展：Hyprland、通知、状态栏等）
{
  lib,
  config,
  ...
}: {
  imports = [];

  config = lib.mkIf config.hexzii.profile.desktopApps {
    # TODO: Hyprland, notifications, status bar, etc.
  };
}
