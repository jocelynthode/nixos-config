{ config, lib, pkgs, ... }: {
  options.aspects.graphical.mpv.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.mpv.enable {

    home-manager.users.jocelyn = { ... }: {
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
          slang = "fr,fra,en,eng";

          volume = 60;
          af-add = "dynaudnorm=g=5:f=250:r=0.9:p=0.5";

          target-trc = "auto";
          vf = "format=colorlevels=full:colormatrix=auto";
          video-output-levels = "full";

          dither-depth = "auto";
          temporal-dither = true;
          dither = "fruit";

          blend-subtitles = true;

          sub-color = "#FFFF00";
          sub-shadow-color = "#000000";
          sub-font = config.aspects.base.fonts.regular.family;
          sub-pos = 95;
          sub-font-size = 60;
          sub-bold = true;

          override-display-fps = 60;
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";

        };
      };
    };
  };
}
