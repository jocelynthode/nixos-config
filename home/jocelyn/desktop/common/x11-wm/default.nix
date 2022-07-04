{ pkgs, ... }:
{
  imports = [
    ./dunst
    ./rofi
    ./autorandr.nix
    ./picom.nix
    ./polybar.nix
    ./screen-locker.nix
    ./xresources.nix
  ];

  home.packages = with pkgs; [
    xdotool
    xsel
  ];
}
