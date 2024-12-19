{
  stdenv,
  lib,
  bash,
  rofi,
  xclip,
  wl-clipboard,
  libnotify,
  fetchFromGitHub,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "rofi-ykman";
  version = "2024-12-17";
  src = fetchFromGitHub {
    owner = "nukeop";
    repo = "rofi-ykman";
    rev = "9666a4a5291d3045b614d9861241193d1368aea2";
    sha256 = "sha256-58Z+BJUN81zi6IoZIaVgA6H3yN682/u7iCPGrjQ5nCI=";
  };
  buildInputs = [bash rofi xclip wl-clipboard libnotify];
  nativeBuildInputs = [makeWrapper];
  installPhase = ''
    mkdir -p $out/bin
    cp rofi-ykman $out/bin/rofi-ykman
    wrapProgram $out/bin/rofi-ykman \
      --prefix PATH : ${lib.makeBinPath [bash rofi xclip wl-clipboard libnotify]}
  '';
}
