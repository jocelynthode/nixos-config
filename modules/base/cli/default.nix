{
  pkgs,
  config,
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

    catppuccin.bat.enable = true;
    programs = {
      bat = {
        enable = true;
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
      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
      atuin = {
        enable = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://atuin.tekila.ovh";
          keymap_mode = "auto";
          search_mode = "fuzzy";
          key_path = config.sops.secrets."atuin/key".path;
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
  sops.secrets."atuin/key" = {
    sopsFile = ../../../secrets/common/secrets.yaml;
    owner = "jocelyn";
    group = "users";
  };
  aspects.base.persistence.homePaths = [
    ".local/share/atuin"
    ".local/share/zoxide"
  ];
  home-manager.users.jocelyn = _: base;
  home-manager.users.root = _: base;
}
