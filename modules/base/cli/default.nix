{
  pkgs,
  config,
  ...
}:
let
  base = {
    home.packages = with pkgs; [
      cachix
    ];

    catppuccin = {
      bat.enable = false;
      fzf.enable = false;
      lsd.enable = true;
      atuin.enable = true;
    };
    programs = {
      bat = {
        enable = true;
      };
      fd.enable = true;
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
      ripgrep.enable = true;
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
      tealdeer = {
        enable = true;
      };
      jq.enable = true;
      atuin = {
        enable = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://atuin.tekila.ovh";
          keymap_mode = "auto";
          search_mode = "fuzzy";
          key_path = config.sops.secrets."atuin/key".path;
          sync = {
            records = true;
          };
          dotfiles = {
            enabled = false;
          };
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
    ".cache/tealdeer"
  ];
  home-manager.users.jocelyn = _: base;
  home-manager.users.root = _: base;
}
