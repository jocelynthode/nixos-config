{ pkgs, ... }: {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-0 
    '';
  };
}
