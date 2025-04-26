{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}: {
  options.aspects.programs.spotify.enable = lib.mkEnableOption "spotify";

  config = lib.mkIf config.aspects.programs.spotify.enable {
    aspects.base.persistence.homePaths = [
      ".config/spotify"
    ];

    home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
    home-manager.users.jocelyn = _: {
      home.packages = [pkgs.playerctl];
      services.playerctld = {
        enable = true;
      };
      programs.spicetify = {
        enable = true;
        theme = spicetify-nix.legacyPackages.${pkgs.system}.themes.catppuccin;
        colorScheme = "mocha";
      };
    };
  };
}
