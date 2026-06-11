{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
}:

stdenvNoCC.mkDerivation {
  pname = "jhentai";
  version = "8.0.13";

  src = fetchurl {
    url = "https://github.com/jiangtian616/JHenTai/releases/download/v8.0.13%2B312/JHenTai-8.0.13+312.dmg";
    hash = "sha256-pVmhjUW+I23bHVU49m7MWqcnvHjgRQjhSv8lFPom+FY=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -R jhentai.app $out/Applications/jhentai.app
  '';

  meta = {
    description = "A manga reader for E-Hentai/EXHentai";
    homepage = "https://github.com/jiangtian616/JHenTai";
    platforms = lib.platforms.darwin;
  };
}
