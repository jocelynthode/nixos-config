{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.thunderbird.enable = lib.mkEnableOption "thunderbird";

  config = lib.mkIf config.aspects.programs.thunderbird.enable {
    aspects.base.persistence.homePaths = [
      ".thunderbird"
      ".cache/thunderbird"
      ".config/protonmail"
      ".cache/protonmail"
      ".local/share/protonmail"
    ];

    home-manager.users.jocelyn =
      { pkgs, ... }:
      {
        catppuccin.thunderbird = {
          enable = true;
          profile = "jocelyn";
        };
        programs.thunderbird = {
          enable = true;
          profiles = {
            jocelyn = {
              isDefault = true;
            };
          };
        };
        services.protonmail-bridge = {
          enable = true;
          extraPackages = with pkgs; [
            gnome-keyring
          ];
        };
      };
  };
}
