# Desktop GUI packages
{
  lib,
  config,
  pkgs,
  monique,
  ...
}: let
  cfg = config.hex.nixos.home.desktop.packages;
in {
  imports = [monique.nixosModules.default];

  options.hex.nixos.home.desktop.packages = {
    enable = lib.mkEnableOption "desktop GUI packages (ghostty, firefox, vesktop, ayugram)" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    programs.monique.enable = true; # supersedes nwg-displays
    home-manager.users.hexzii.home.packages = with pkgs; [
      ghostty
      firefox

      vesktop
      ayugram-desktop
      imhex
      zed-editor
      vscodium
      freetube
      mpv
      celluloid
      vlc
      nwg-look # GTK theme/cursor/icon settings GUI
      desktop-file-utils # update-desktop-database
      seahorse # GNOME Keyring GUI (passwords & keys)
      nautilus # GNOME file manager (bound to SUPER+E)
      nemo # may also try!
      # dolphin
      libreoffice-fresh
      obs-studio
      # reader / viewers
      foliate
      papers
      loupe
      # oculante is good, but is still in active refactoring (switch to that later)
      dosbox-x
      cheese
      gpu-screen-recorder
      # TODO: add SnapX/Satty/Flameshot image capturer
      emulsion-palette
      calligraphy
      fluffychat # also outdated, currently just want to try it out

      gparted
      networkmanagerapplet # advanced nm

      # network capturing
      wireshark
      # proxypin

      # bitwarden-desktop FIXME: outdated electron
      sourcegit # todo: watch 4 updates

      # hyprland-exclusiv! TODO: move to wm
      hyprshade

      fsearch

      # system / debugging
      sysprof
      # warp-terminal
      hotspot
      edb
      localsend
      # todo : try uniclipboard

      # TODO: migrate most of them to flatpak
      sniffnet
      tiny-rdm
      jetbrains-toolbox

      lrcget
      qalculate-gtk
      resources

      # lap
      # escrcpy

      # fixme: move to a "nixos/home section"
      wev
      evtest
      wayshot
      wl-screenrec
      wl-clipboard # TODO: maybe try clipvault??

      imv # image viewer
      # dunst
      inotify-tools
    ];
  };
}
