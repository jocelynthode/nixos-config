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
          background_opacity = "0.85";
          allow_remote_control = "yes";

          tab_bar_style = "custom";
          tab_separator = "\" ▎\"";
          tab_fade = "0 0 0 0";
          tab_title_template = "\"{fmt.fg._415c6d}{fmt.bg.default} ○ {index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title}{' []' if layout_name == 'stack' else ''} \"";
          active_tab_title_template = "\"{fmt.fg._83b6af}{fmt.bg.default} 綠{index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title}{' []' if layout_name == 'stack' else ''} \"";
          tab_activity_symbol = "none";
          tab_bar_edge = "top";
          tab_bar_margin_height = "0.0 0.0";
          active_tab_font_style = "bold-italic";
          inactive_tab_font_style = "normal";
          tab_bar_min_tabs = "2";

          window_padding_width = 15;
          foreground = "#${config.colorScheme.colors.base05}";
          background = "#${config.colorScheme.colors.base00}";
          selection_background = "#${config.colorScheme.colors.base06}";
          selection_foreground = "#${config.colorScheme.colors.base00}";
          url_color = "#${config.colorScheme.colors.base06}";
          cursor = "#${config.colorScheme.colors.base06}";
          cursor_text_color = "#${config.colorScheme.colors.base00}";
          active_border_color = "#${config.colorScheme.colors.base07}";
          inactive_border_color = "#${config.colorScheme.colors.base01}";
          active_tab_background = "#${config.colorScheme.colors.base0E}";
          active_tab_foreground = "#${config.colorScheme.colors.base00}";
          inactive_tab_background = "#${config.colorScheme.colors.base01}";
          inactive_tab_foreground = "#${config.colorScheme.colors.base05}";
          tab_bar_background = "#${config.colorScheme.colors.base03}";
          bell_border_color = "#${config.colorScheme.colors.base0A}";
          mark1_foreground = "#${config.colorScheme.colors.base00}";
          mark1_background = "#${config.colorScheme.colors.base07}";
          mark2_foreground = "#${config.colorScheme.colors.base00}";
          mark2_background = "#${config.colorScheme.colors.base0E}";

          color0 = "#5C5F77";
          color8 = "#6C6F85";

          color1 = "#${config.colorScheme.colors.base08}";
          color9 = "#${config.colorScheme.colors.base08}";

          color2 = "#${config.colorScheme.colors.base0B}";
          color10 = "#${config.colorScheme.colors.base0B}";

          color3 = "#${config.colorScheme.colors.base0A}";
          color11 = "#${config.colorScheme.colors.base0A}";

          color4 = "#${config.colorScheme.colors.base0D}";
          color12 = "#${config.colorScheme.colors.base0D}";

          color5 = "#EA76CB";
          color13 = "#EA76CB";

          color6 = "#${config.colorScheme.colors.base0C}";
          color14 = "#${config.colorScheme.colors.base0C}";

          color7 = "#${config.colorScheme.colors.base04}";
          color15 = "#${config.colorScheme.colors.base03}";
        };
      };

      xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
    };
  };
}
