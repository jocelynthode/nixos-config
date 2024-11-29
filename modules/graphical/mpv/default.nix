{
  config,
  lib,
  ...
}: {
  options.aspects.graphical.mpv.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.mpv.enable {
    aspects.base.persistence.homePaths = [
      ".local/state/mpv"
    ];

    home-manager.users.jocelyn = _: {
      programs.mpv = {
        enable = true;
        config = {
          vo = "gpu";
          profile = "gpu-hq";
          gpu-api = "vulkan";
          hwdec = "auto";
          border = false;
          msg-color = true;
          term-osd-bar = true;
          cursor-autohide = 1000;
          save-position-on-quit = true;
          cache = true;
          demuxer-max-bytes = "1800M";
          demuxer-max-back-bytes = "1200M";

          alang = "ja,jp,jpn,en,eng,fr,fra";
          slang = "fr,fra,en,eng,enUS,en-US";

          volume = 60;
          af-add = "dynaudnorm=g=5:f=250:r=0.9:p=0.5";

          target-trc = "auto";
          vf = "format=colorlevels=full:colormatrix=auto";
          video-output-levels = "full";

          dither-depth = "auto";
          temporal-dither = true;
          dither = "fruit";

          blend-subtitles = true;

          sub-auto = "fuzzy";
          ytdl-raw-options = "ignore-config=,sub-lang=\"en,eng,enUS,en-US,fr,fra\",write-sub=,write-auto-sub=";
          sub-color = "#FFFF00";
          sub-shadow-color = "#000000";
          sub-font = config.aspects.base.fonts.regular.family;
          sub-pos = 95;
          sub-font-size = 60;
          sub-bold = true;

          display-fps-override = 60;
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";
          stream-buffer-size = "3MiB";
        };
      };
    };
  };
}
