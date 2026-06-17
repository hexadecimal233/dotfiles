# TEMP: hexadecimal233 fork with Hyprland 0.55+ V2 API migration.
# Upstream savonovv v0.3.1 crashed on 0.55.4 (uses V1 API, tested only on 0.54.2).
{
  lib,
  hyprlandPlugins,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hypr-kinetic-scroll";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hexadecimal233";
    repo = "hypr-kinetic-scroll";
    rev = "846407b85e0ed550a90cb70998a7fb4361c571d8";
    hash = "sha256-4jGMqt8PXTHFxCdhSCtg4oIBUlAA1IFXb+mKGDxO7hE=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp hypr-kinetic-scroll.so $out/lib/libhypr-kinetic-scroll.so
  '';

  meta = {
    homepage = "https://github.com/hexadecimal233/hypr-kinetic-scroll";
    description = "Kinetic (inertial) scrolling plugin for Hyprland touchpads (Hyprland 0.55+ V2 API)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
