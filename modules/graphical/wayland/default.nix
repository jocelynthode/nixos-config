{lib, ...}: {
  imports = [
    ./kanshi
    ./waybar
    ./wofi
  ];

  options.aspects.graphical.wayland = {
    enable = lib.mkEnableOption "wayland";
  };
}
