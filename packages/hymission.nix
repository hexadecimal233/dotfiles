{
  lib,
  cmake,
  pkg-config,
  lua,
  hyprlandPlugins,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hymission";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hymission";
    rev = "20afc79357b7b5f1a82718dc71d9171a8a282d21";
    hash = "sha256-91nwy36nk3Pqp12URNfw0mB8peut7QmVSkuWWpO7/Yw=";
  };

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [lua];

  meta = {
    homepage = "https://github.com/gfhdhytghd/hymission";
    description = "Mission Control-style workspace & windows overview plugin for Hyprland";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
