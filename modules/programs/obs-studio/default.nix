{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.obs-studio.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.obs-studio.enable {
    aspects.base.persistence.homePaths = [
      ".config/obs-studio"
    ];

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      kernelModules = ["v4l2loopback"];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };
    security.polkit.enable = true;

    home-manager.users.jocelyn = _: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          # obs-backgroundremoval
          obs-pipewire-audio-capture
          wlrobs
          obs-vkcapture
        ];
      };
    };
  };
}
