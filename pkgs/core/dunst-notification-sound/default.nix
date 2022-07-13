{ pkgs, config }:

pkgs.writeShellApplication {
  name = "dunst-notification-sound";
  checkPhase = "";

  runtimeInputs = with pkgs; [ mpv ];

  text = ''
    mpv ~/.config/dunst/sound.wav 
  '';
}
