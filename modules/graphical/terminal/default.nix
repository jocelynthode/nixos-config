{
  config,
  lib,
  ...
}: {
  options.aspects.graphical.terminal.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.terminal.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      home.sessionVariables = {
        TERMINAL = "kitty";
      };

      programs.kitty = {
        enable = true;
        font.name = osConfig.aspects.base.fonts.monospace.family;
        font.size = osConfig.aspects.base.fonts.monospace.size;
        settings = {
          allow_remote_control = "yes";

          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_separator = "";
          tab_title_template = " {index} {title} ";
          tab_bar_edge = "top";
          tab_bar_margin_height = "0.0 0.0";
          active_tab_font_style = "bold-italic";
          inactive_tab_font_style = "normal";
          tab_bar_min_tabs = "2";

          window_padding_width = 10;
          foreground = "#${config.colorScheme.palette.foreground}";
          background = "#${config.colorScheme.palette.background}";
          selection_background = "#${config.colorScheme.palette.foreground02}";
          selection_foreground = "#${config.colorScheme.palette.background}";
          url_color = "#${config.colorScheme.palette.foreground02}";
          cursor = "#${config.colorScheme.palette.foreground02}";
          cursor_text_color = "#${config.colorScheme.palette.background}";
          active_border_color = "#${config.colorScheme.palette.foreground03}";
          inactive_border_color = "#${config.colorScheme.palette.background01}";
          active_tab_background = "#${config.colorScheme.palette.accent}";
          active_tab_foreground = "#${config.colorScheme.palette.background}";
          inactive_tab_background = "#${config.colorScheme.palette.background}";
          inactive_tab_foreground = "#${config.colorScheme.palette.foreground}";
          tab_bar_background = "#${config.colorScheme.palette.background}";
          bell_border_color = "#${config.colorScheme.palette.yellow}";
          mark1_foreground = "#${config.colorScheme.palette.background}";
          mark1_background = "#${config.colorScheme.palette.foreground03}";
          mark2_foreground = "#${config.colorScheme.palette.background}";
          mark2_background = "#${config.colorScheme.palette.purple}";

          color0 = "#5C5F77";
          color8 = "#6C6F85";

          color1 = "#${config.colorScheme.palette.red}";
          color9 = "#${config.colorScheme.palette.red}";

          color2 = "#${config.colorScheme.palette.green}";
          color10 = "#${config.colorScheme.palette.green}";

          color3 = "#${config.colorScheme.palette.yellow}";
          color11 = "#${config.colorScheme.palette.yellow}";

          color4 = "#${config.colorScheme.palette.blue}";
          color12 = "#${config.colorScheme.palette.blue}";

          color5 = "#${config.colorScheme.palette.accent}";
          color13 = "#${config.colorScheme.palette.accent}";

          color6 = "#${config.colorScheme.palette.teal}";
          color14 = "#${config.colorScheme.palette.teal}";

          color7 = "#${config.colorScheme.palette.foreground01}";
          color15 = "#${config.colorScheme.palette.background03}";
        };
      };
    };
  };
}
