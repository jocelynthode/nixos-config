{lib, ...}: {
  imports = [
    ./kanshi
    ./swayidle
    ./waybar
    ./wofi
  ];

  options.aspects.graphical.wayland = {
    enable = lib.mkEnableOption "wayland";
  };
}
