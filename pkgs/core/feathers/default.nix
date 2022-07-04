{ lib, fetchurl }:

let
  version = "4.29.0";
in
fetchurl {
  name = "feathers-${version}";

  url = "https://github.com/adi1090x/polybar-themes/raw/master/fonts/feather.ttf";

  sha256 = "sha256-hawzxRXGOIEVUDYqQ6j/Ca7cwcCB6AapQL+1HyRmfRA=";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    mkdir -p $out/share/fonts
    install -m444 -Dt $out/share/fonts/truetype $downloadedFile
  '';

  meta = with lib; {
    description = "Feathers icons font";
    homepage = "https://github.com/adi1090x/polybar-themes";
    license = licenses.ofl;
    maintainers = [ maintainers.jocelynthode ];
    platforms = platforms.all;
  };
}
