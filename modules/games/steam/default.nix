{
  pkgs,
  config,
  lib,
  ...
}: {
  options.aspects.games.steam.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.steam.enable {
    aspects.base.persistence.homePaths = [
      ".steam"
      ".local/share/Steam"
      "Astral Ascent"
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libkrb5
            keyutils
          ];
      };
      # package = pkgs.steam.override {
      #   extraLibraries = p:
      #     with p; [
      #     ];
      # };
      remotePlay.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--output-width 2560"
          "--output-height 1440"
          "--nested-refresh 144"
          "--fullscreen"
        ];
      };
    };

    hardware.xone.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "-r 144"
      ];
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      protontricks
      mangohud
    ];

    home-manager.users.jocelyn = _: {
      home.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-custom}";
      };
    };
  };
}
