{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    rofi-power-menu
    rofi-rbw
  ];

  programs.rofi = {
    enable = true;
    font = "${config.fontProfiles.monospace.family} 11";
    terminal = "${pkgs.kitty}/bin/kitty";
    location = "center";
  };

  xdg.configFile."rofi/colors.rasi" = {
    text = ''
      * {
        al:   #00000000;
        bg:   #${config.colorScheme.colors.base00}cc;
        bga:  #${config.colorScheme.colors.base01}cc;
        fg:   #${config.colorScheme.colors.base07}ff;
        ac:   #${config.colorScheme.colors.base08}ff;
        se:   #${config.colorScheme.colors.base0C}ff;
      }
    '';
  };

  xdg.configFile."rofi" = {
    source = ./themes;
    recursive = true;
  };

}
