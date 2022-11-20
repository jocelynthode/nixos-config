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

    home-manager.users.jocelyn = _: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
