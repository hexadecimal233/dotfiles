{
  lib,
  hyprlandPlugins,
  fetchFromGitHub,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hyprglass";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "22acd5db6ef73fa34cad2d5ce8b76cf37e9acaa5";
    hash = "sha256-coVoTJyRhn6eKZ8oJXus93p/G1gblgqcQNhNXBhx+G4=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
  '';

  meta = {
    homepage = "https://github.com/hyprnux/hyprglass";
    description = "Liquid Glass effect plugin for Hyprland – frosted blur, refraction, chromatic aberration";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
