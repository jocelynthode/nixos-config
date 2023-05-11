{
  config,
  pkgs,
  ...
}: let
  base = {
    home.packages = with pkgs; [
      cachix
      fd
      ripgrep
      delta
      rsync
      unzip
    ];

    programs = {
      bat = {
        enable = true;
        config.theme = "base16";
      };
      fzf = {
        enable = true;
      };
      lsd = {
        enable = true;
        settings = {
          symlink-arrow = "⇒";
          color = {
            theme = "base16";
          };
        };
      };
    };

    xdg.configFile."lsd/themes/base16.yaml" = {
      text = ''
        user: dark_yellow
        group: dark_yellow
        permission:
          read: dark_green
          write: dark_yellow
          exec: dark_red
          exec-sticky: dark_blue
          no-access: black
          octal: dark_blue
          acl: dark_cyan
          context: cyan
        date:
          hour-old: green
          day-old: green
          older: green
        size:
          none: magenta
          small: magenta
          medium: magenta
          large: magenta
        inode:
          valid: 13
          invalid: 245
        links:
          valid: dark_green
          invalid: dark_red
        tree-edge: 245
      '';
    };
  };
in {
  home-manager.users.jocelyn = _: base;
  home-manager.users.root = _: base;
}
