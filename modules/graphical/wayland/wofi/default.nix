{
  pkgs,
  lib,
  config,
  nix-colors,
  ...
}: let
  toRGB = nix-colors.lib.conversions.hexToRGBString ",";
in {
  config = lib.mkIf config.aspects.graphical.wayland.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      home.packages = with pkgs; [
        wofi
      ];

      xdg.configFile."wofi/style.css" = {
        text = ''
          @define-color accent #${config.colorScheme.colors.accent};
          @define-color txt #${config.colorScheme.colors.foreground};
          @define-color bg rgba(${toRGB config.colorScheme.colors.background},0.9);
          @define-color bg-solid #${config.colorScheme.colors.background};
          @define-color bg2 rgba(${toRGB config.colorScheme.colors.background03},0.9);

          * {
              font-family: ${osConfig.aspects.base.fonts.regular.family};
              font-size: ${toString osConfig.aspects.base.fonts.regular.size}pt;
          }

           /* Window */
           window {
              margin: 0px;
              padding: 10px;
              border: 3px solid @accent;
              border-radius: 7px;
              background: transparent;
              animation: slideIn 0.2s ease-in-out both;
           }

           /* Slide In */
           @keyframes slideIn {
              0% {
                 opacity: 0;
              }

              100% {
                 opacity: 1;
              }
           }

           /* Inner Box */
           #inner-box {
              margin: 5px;
              padding: 10px;
              border: none;
              background: transparent;
              animation: fadeIn 0.2s ease-in-out both;
           }

           /* Fade In */
           @keyframes fadeIn {
              0% {
                 opacity: 0;
              }

              100% {
                 opacity: 1;
              }
           }

           /* Outer Box */
           #outer-box {
              margin: 5px;
              padding: 10px;
              border: none;
              background-color: @bg;
           }

           /* Scroll */
           #scroll {
              margin: 0px;
              padding: 10px;
              border: none;
           }

           /* Input */
           #input {
              margin: 5px;
              padding: 10px;
              border: none;
              color: @txt;
              background-color: @bg2;
              animation: fadeIn 0.2s ease-in-out both;
           }

           /* Text */
           #text {
              margin: 5px;
              padding: 10px;
              border: none;
              color: @txt;
              animation: fadeIn 0.2s ease-in-out both;
           }

           /* Selected Entry */
           #entry:selected {
             background-color: @accent;
           }

           #entry:selected #text {
              color: @bg-solid;
           }
        '';
      };
    };
  };
}
