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
          foreground = "#${config.colorScheme.colors.foreground}";
          background = "#${config.colorScheme.colors.background}";
          selection_background = "#${config.colorScheme.colors.foreground02}";
          selection_foreground = "#${config.colorScheme.colors.background}";
          url_color = "#${config.colorScheme.colors.foreground02}";
          cursor = "#${config.colorScheme.colors.foreground02}";
          cursor_text_color = "#${config.colorScheme.colors.background}";
          active_border_color = "#${config.colorScheme.colors.foreground03}";
          inactive_border_color = "#${config.colorScheme.colors.background01}";
          active_tab_background = "#${config.colorScheme.colors.accent}";
          active_tab_foreground = "#${config.colorScheme.colors.background}";
          inactive_tab_background = "#${config.colorScheme.colors.background}";
          inactive_tab_foreground = "#${config.colorScheme.colors.foreground}";
          tab_bar_background = "#${config.colorScheme.colors.background}";
          bell_border_color = "#${config.colorScheme.colors.yellow}";
          mark1_foreground = "#${config.colorScheme.colors.background}";
          mark1_background = "#${config.colorScheme.colors.foreground03}";
          mark2_foreground = "#${config.colorScheme.colors.background}";
          mark2_background = "#${config.colorScheme.colors.purple}";

          color0 = "#5C5F77";
          color8 = "#6C6F85";

          color1 = "#${config.colorScheme.colors.red}";
          color9 = "#${config.colorScheme.colors.red}";

          color2 = "#${config.colorScheme.colors.green}";
          color10 = "#${config.colorScheme.colors.green}";

          color3 = "#${config.colorScheme.colors.yellow}";
          color11 = "#${config.colorScheme.colors.yellow}";

          color4 = "#${config.colorScheme.colors.blue}";
          color12 = "#${config.colorScheme.colors.blue}";

          color5 = "#${config.colorScheme.colors.accent}";
          color13 = "#${config.colorScheme.colors.accent}";

          color6 = "#${config.colorScheme.colors.teal}";
          color14 = "#${config.colorScheme.colors.teal}";

          color7 = "#${config.colorScheme.colors.foreground01}";
          color15 = "#${config.colorScheme.colors.background03}";
        };
      };
    };
  };
}
