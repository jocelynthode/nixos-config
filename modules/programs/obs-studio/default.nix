{
  config,
  lib,
  pkgs-stable,
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

    home-manager.users.jocelyn = _: {
      programs.obs-studio = {
        enable = true;
        package = pkgs-stable.obs-studio;
        plugins = with pkgs-stable.obs-studio-plugins; [
          # obs-backgroundremoval
          obs-pipewire-audio-capture
          wlrobs
          obs-vkcapture
        ];
      };
    };
  };
}
