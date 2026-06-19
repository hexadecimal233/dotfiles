# sandwichfarm/hyprexpo — maintained expose-style workspace overview for Hyprland
# https://github.com/sandwichfarm/hyprexpo
{
  lib,
  cmake,
  pkg-config,
  lua,
  hyprlandPlugins,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hyprexpo";
  version = "0.55.2+2";

  src = fetchFromGitHub {
    owner = "sandwichfarm";
    repo = "hyprexpo";
    # master (includes PR #58 fix for gesture crash)
    rev = "dca8c159d0710a4101e38cb8f978a127e1801fde";
    hash = "sha256-DHTBaaNH2tNjCrRJnKE3o7oq+2GeV4L5hwHsBqXL0oY=";
  };

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [lua];

  meta = {
    homepage = "https://github.com/sandwichfarm/hyprexpo";
    description = "Maintained expose-style workspace overview plugin for Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
