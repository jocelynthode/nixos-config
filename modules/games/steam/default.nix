{
  pkgs,
  config,
  lib,
  ...
}: {
  options.aspects.games.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.aspects.games.steam.enable {
    aspects.base.persistence.homePaths = [
      ".steam"
      ".local/share/Steam"
      "Astral Ascent"
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = true;
        };
      };
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--nested-width 2560"
          "--nested-height 1440"
          "--nested-refresh 144"
          "--force-grab-cursor"
          "--grab"
          "--fullscreen"
        ];
      };
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    hardware.xone.enable = true;

    programs.gamescope = {
      enable = true;
      # capSysNice = true;
      args = [
        "--nested-width 2560"
        "--nested-height 1440"
        "--nested-refresh 144"
        "--force-grab-cursor"
        "--grab"
        "--fullscreen"
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
