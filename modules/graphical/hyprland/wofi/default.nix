{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = { osConfig, ... }: {
      home.packages = with pkgs; [
        wofi
      ];

      xdg.configFile."wofi/style.css" = {
        text = ''
          window {
              border:  0px;
              border-radius: 5px;
              font-family: ${osConfig.aspects.base.fonts.regular.family};
              font-size: ${toString osConfig.aspects.base.fonts.regular.size}pt;
          }

          #input {
            padding: 5px;
            margin: 0px;
          }
        '';
      };
    };
  };
}
