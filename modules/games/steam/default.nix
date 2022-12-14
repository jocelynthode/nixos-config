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
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      gamescope
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
