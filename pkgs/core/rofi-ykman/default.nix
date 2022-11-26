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
  version = "2022-09-01";
  src = fetchFromGitHub {
    owner = "nukeop";
    repo = "rofi-ykman";
    rev = "5275382d6378c9aa34066a29b5c7969d22937cd4";
    sha256 = "sha256-RjwVJl0X9Q7OLMtIN/tHySctFsDIEkCDO+zn4Gms8B8=";
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
