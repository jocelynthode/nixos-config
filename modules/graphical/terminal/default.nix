{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.terminal.enable = lib.mkEnableOption "terminal";

  config = lib.mkIf config.aspects.graphical.terminal.enable {
    home-manager.users.jocelyn =
      { osConfig, ... }:
      {
        home.sessionVariables = {
          TERMINAL = "kitty";
        };

        programs.kitty = {
          enable = true;
          font.name = osConfig.aspects.base.fonts.monospace.family;
          font.size = lib.mkDefault osConfig.aspects.base.fonts.monospace.size;
          actionAliases = {
            "kitty_scrollback_nvim" =
              "kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
          };
          keybindings = {
            "alt+tab" = "select_tab";
            "alt+1" = "goto_tab 1";
            "alt+2" = "goto_tab 2";
            "alt+3" = "goto_tab 3";
            "alt+4" = "goto_tab 4";
            "alt+5" = "goto_tab 5";
            "alt+6" = "goto_tab 6";
            "alt+7" = "goto_tab 7";
            "alt+8" = "goto_tab 8";
            "alt+9" = "goto_tab 9";
            "alt+0" = "goto_tab 10";
            "kitty_mod+h" = "kitty_scrollback_nvim";
            "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
          };
          settings = {
            allow_remote_control = "socket-only";
            listen_on = "unix:/tmp/kitty";
            shell_integration = "enabled";
            scrollback_pager = "kitty_scrollback_nvim";

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
          };
        };
      };
  };
}
