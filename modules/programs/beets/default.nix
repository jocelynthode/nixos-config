{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.beets.enable = lib.mkEnableOption "beets";

  config = lib.mkIf config.aspects.programs.beets.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/beets"
    ];

    home-manager.users.jocelyn = _: {
      programs.beets = {
        enable = true;
        package = pkgs.python3.pkgs.beets.override {
          pluginOverrides = {
            audible = {
              enable = true;
              propagatedBuildInputs = [ pkgs.python3.pkgs.beets-audible ];
            };
          };
        };
        settings = {
          directory = "/data/media/music";
          library = "/home/jocelyn/.local/share/beets/library.db";
          plugins = [
            "albumtypes"
            "autobpm"
            "chroma"
            "deezer"
            "duplicates"
            "embedart"
            "fetchart"
            "fish"
            "lastgenre"
            "lyrics"
            "mbsync"
            "replaygain"
            "scrub"
            "spotify"
            "the"
          ];
          import = {
            write = true;
            hardlink = true;
            languages = [
              "fr"
              "en"
            ];
          };
          paths = {
            default = "%the{$albumartist}/$album%if{$atypes, $atypes} ($year)/$track - $title";
            singleton = "_Singletons/%the{$albumartist}/$album ($year)/$track - $title";
            "albumtype:soundtrack" = "_Soundtracks/$album ($year)/$track - %the{$artist} - $title";
            "albumtype:compilation" = "_Compilations/$album%aunique{} ($year)/$track - %the{$artist} - $title";
            comp = "_Compilations/$album%aunique{} ($year)/$track - %the{$artist} - $title";
          };
          ui = {
            color = true;
          };
          replaygain = {
            backend = "ffmpeg";
          };
          lastgenre = {
            source = "track";
            force = true;
            keep_existing = true;
            count = 3;
          };
          embedart = {
            maxwidth = 500;
          };
          lyrics = {
            auto = false;
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
              countries = [
                "XW"
                "FR"
                "US"
              ];
              media = [
                "Digital Media|File"
                "CD"
              ];
            };
          };
          musicbrainz = {
            external_ids = {
              bandcamp = true;
              deezer = true;
            };
          };
          deezer = {
            source_weight = 0.1;
          };
        };
      };
    };
  };
}
