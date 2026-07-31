{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.aspects.services.kodi;
  kodiPkg =
    if cfg.plugins == [ ] then
      pkgs.kodi-gbm
    else
      pkgs.kodi-gbm.withPackages (kodiPkgs: with kodiPkgs; cfg.plugins);
in
{
  options.aspects.services.kodi = {
    enable = lib.mkEnableOption "kodi";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/kodi";
        user = "kodi";
        group = "kodi";
      }
    ];

    environment.systemPackages = [ kodiPkg ];

    users.users.kodi = {
      isSystemUser = true;
      home = "/var/lib/kodi";
      createHome = true;
      group = "kodi";
      extraGroups = [
        "input"
        "video"
        "audio"
        "media"
      ];
    };

    users.groups.kodi = { };

    services.getty.autologinUser = "kodi";

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${kodiPkg}/bin/kodi-standalone";
          user = "kodi";
        };
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.bash}/bin/bash";
        };
      };
    };

    programs.sway = {
      enable = true;
      xwayland.enable = false;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8088 ];
      allowedUDPPorts = [ 8088 ];
    };

    services.pulseaudio.enable = false;
    services.pipewire.enable = false;

    hardware.graphics.enable = true;
  };
}
