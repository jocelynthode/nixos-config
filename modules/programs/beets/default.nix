{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.beets.enable = lib.mkEnableOption "beets";

  config = lib.mkIf config.aspects.programs.beets.enable {
    home-manager.users.jocelyn = _: {
      programs.beets = {
        enable = true;
        package = pkgs.beets.override {
          pluginOverrides = {
            audible = {
              enable = true;
              propagatedBuildInputs = with pkgs.beetsPackages; [audible];
            };
          };
        };
        settings = {
          directory = "/data/media/music";
          plugins = ["fish" "chroma" "fetchart" "embedart" "lyrics"];
          import = {
            write = true;
            hardlink = true;
          };
          group_albums = true;
          ui = {
            color = true;
          };
          # replaygain = {
          #   backend = "ffmpeg";
          # };
        };
      };
    };
  };
}
