{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "dunst-notification-sound";
  checkPhase = "";

  runtimeInputs = with pkgs; [ mpv ];

  text = ''
    blacklist=( "Spotify" "NetworkManager" )

    [[ ! " ''${blacklist[@]} " =~ " $1 " ]] && mpv ~/.config/dunst/sound.wav
  '';
}
