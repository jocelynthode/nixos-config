{
  pkgs,
  config,
  ...
}:
let
  base = {
    home.packages = with pkgs; [
      cachix
      fd
      ripgrep
      rsync
      unzip
    ];

    catppuccin = {
      bat.enable = true;
      fzf.enable = true;
      lsd.enable = true;
      atuin.enable = true;
    };
    programs = {
      bat = {
        enable = true;
      };
      fzf = {
        enable = true;
      };
      lsd = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          symlink-arrow = "⇒";
        };
      };
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
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
  };
in
{
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
