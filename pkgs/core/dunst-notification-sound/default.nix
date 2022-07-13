{ pkgs, config }:

pkgs.writeShellApplication {
  name = "dunst-notification-sound";
  checkPhase = "";

  runtimeInputs = with pkgs; [ mpv ];

  text = ''
    blacklist=( "Spotify" )

    [[ ! " ''${blacklist[@]} " =~ " $1 " ]] && mpv ~/.config/dunst/sound.wav
  '';
}
