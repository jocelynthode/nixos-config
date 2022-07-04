{ config, pkgs, ... }:

let
  inherit (config.colorscheme) colors;
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty "$@"
  '';
in
{
  home = {
    packages = with pkgs; [ kitty ];
    sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  programs.kitty = {
    enable = true;
    font.name = config.fontProfiles.monospace.family;
    settings = {
      background_opacity = "0.90";
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
      selection_background = "#${config.colorScheme.colors.base05}";
      selection_foreground = "#${config.colorScheme.colors.base00}";
      url_color = "#${config.colorScheme.colors.base04}";
      cursor = "#${config.colorScheme.colors.base05}";
      active_border_color = "#${config.colorScheme.colors.base03}";
      inactive_border_color = "#${config.colorScheme.colors.base01}";
      active_tab_background = "#${config.colorScheme.colors.base00}";
      active_tab_foreground = "#${config.colorScheme.colors.base05}";
      inactive_tab_background = "#${config.colorScheme.colors.base01}";
      inactive_tab_foreground = "#${config.colorScheme.colors.base04}";
      tab_bar_background = "#${config.colorScheme.colors.base00}";

      color0 = "#${config.colorScheme.colors.base01}";
      color1 = "#${config.colorScheme.colors.base08}";
      color2 = "#${config.colorScheme.colors.base0B}";
      color3 = "#${config.colorScheme.colors.base09}";
      color4 = "#${config.colorScheme.colors.base0D}";
      color5 = "#${config.colorScheme.colors.base0E}";
      color6 = "#${config.colorScheme.colors.base0C}";
      color7 = "#${config.colorScheme.colors.base06}";
      color8 = "#${config.colorScheme.colors.base02}";
      color9 = "#${config.colorScheme.colors.base08}";
      color10 = "#${config.colorScheme.colors.base0B}";
      color11 = "#${config.colorScheme.colors.base0A}";
      color12 = "#${config.colorScheme.colors.base0D}";
      color13 = "#${config.colorScheme.colors.base0E}";
      color14 = "#${config.colorScheme.colors.base0C}";
      color15 = "#${config.colorScheme.colors.base07}";
    };
  };

  xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
}
