{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn =
      {
        osConfig,
        ...
      }:
      let
        inherit (osConfig.lib.stylix) colors;
      in
      {
        home.packages = with pkgs; [
          wofi
        ];

        xdg.configFile."wofi/style.css" = {
          text = ''
            @define-color accent ${colors.withHashtag.base0E};
            @define-color txt ${colors.withHashtag.base05};
            @define-color bg-solid ${colors.withHashtag.base00};
            @define-color bg rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 0.9);
            @define-color bg2 rgba(${colors.base03-rgb-r}, ${colors.base03-rgb-g}, ${colors.base03-rgb-b}, 0.9);

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
