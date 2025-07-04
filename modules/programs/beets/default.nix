{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.beets.enable = lib.mkEnableOption "beets";

  config = lib.mkIf config.aspects.programs.beets.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/beets"
    ];

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
          library = "/home/jocelyn/.local/share/beets/library.db";
          plugins = ["albumtypes" "duplicates" "fish" "chroma" "fetchart" "embedart" "replaygain" "lyrics" "ftintitle" "lastgenre" "scrub" "the"];
          import = {
            write = true;
            hardlink = true;
          };
          paths = {
            default = "%the{$albumartist}/$album%if{$atypes, $atypes} ($year)/$track - $title";
            singleton = "%the{$albumartist}/$album ($year)/$track - $title";
            "albumtype:soundtrack" = "_Soundtracks/$album ($year)/$track - %the{$artist} - $title";
            "albumtype:compilation" = "_Compilations/$album%aunique{} ($year)/$track - %the{$artist} - $title";
            comp = "_Compilations/$album%aunique{} ($year)/$track - %the{$artist} - $title";
          };
          group_albums = true;
          ui = {
            color = true;
          };
          languages = ["fr" "en"];
          replaygain = {
            backend = "ffmpeg";
          };
          lastgenre = {
            source = "track";
          };
          embedart = {
            maxwidth = 500;
          };
          lyrics = {
            auto = true;
          };
          fetchart = {
            art_filename = "cover.jpg";
            quality = 85;
            minwidth = 500;
            maxwidth = 500;
            enforce_ratio = true;
            cover_format = "JPEG";
          };
          match = {
            preferred = {
              countries = ["XW" "FR" "US"];
              media = ["Digital Media|File" "CD"];
            };
          };
          musicbrainz = {
            external_ids = {
              bandcamp = true;
              deezer = true;
            };
          };
        };
      };
    };
  };
}
