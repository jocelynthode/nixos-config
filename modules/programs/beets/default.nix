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
          plugins = ["albumtypes" "autobpm" "duplicates" "fish" "chroma" "fetchart" "embedart" "replaygain" "lyrics" "ftintitle" "lastgenre" "scrub" "spotify" "deezer" "the"];
          import = {
            write = true;
            hardlink = true;
            languages = ["fr" "en"];
            group_albums = true;
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
          deezer = {
            source_weight = 0.1;
          };
        };
      };
    };
  };
}
