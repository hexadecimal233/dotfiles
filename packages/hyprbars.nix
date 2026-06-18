# hyprbars at "add font weight" commit — includes bar_text_weight config option.
# nixpkgs is pinned at v0.55.0 tag which lacks this feature.
{
  lib,
  cmake,
  hyprlandPlugins,
  fetchFromGitHub,
}: let
  version = "0.55.0-unstable-2025-12-11";
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    rev = "1cb37fad68dff5f5840010c314fed5809b4ee66f";
    hash = "sha256-asc7NpeB8vD66gvZeYcQkaWOs2X6Jgd29vBtP17vjxo=";
  };
in
  hyprlandPlugins.mkHyprlandPlugin {
    pluginName = "hyprbars";
    inherit version;

    src = "${src}/hyprbars";
    nativeBuildInputs = [cmake];

    meta = {
      homepage = "https://github.com/hyprwm/hyprland-plugins";
      description = "Hyprland window title plugin (latest with monitor refactor fixes)";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.linux;
    };
  }
