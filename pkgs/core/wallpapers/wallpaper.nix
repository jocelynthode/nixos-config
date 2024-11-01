{
  lib,
  stdenv,
  fetchurl,
  wallpaper,
}:
stdenv.mkDerivation rec {
  name = "wallpaper-${wallpaper.name}";
  src = fetchurl {
    inherit (wallpaper) sha256;
    url = "https://kdrive.infomaniak.com/2/app/323582/share/${wallpaper.id}/files/${wallpaper.file}/download";
  };
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm0644 $src $out
  '';

  meta = {
    description = "Wallpaper: ${wallpaper.name}";
    platforms = lib.platforms.all;
  };
}
