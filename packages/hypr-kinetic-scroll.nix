# TEMP: metalgrid fork with Hyprland 0.55+ V2 API migration.
# Switch back to upstream (savonovv/hypr-kinetic-scroll) once it merges or releases a compatible version.
{
  lib,
  hyprlandPlugins,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hypr-kinetic-scroll";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "metalgrid";
    repo = "hypr-kinetic-scroll";
    rev = "d05fd0bded00da20e5e97bf47122a32963268a21";
    hash = "sha256-hR+rSVU9YeUoUub0GNPNeS1RypJWbXX+Bdu5vm7+aDM=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp hypr-kinetic-scroll.so $out/lib/libhypr-kinetic-scroll.so
  '';

  meta = {
    homepage = "https://github.com/metalmadz/hypr-kinetic-scroll";
    description = "Kinetic (inertial) scrolling plugin for Hyprland touchpads (Hyprland 0.55+ V2 API)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
