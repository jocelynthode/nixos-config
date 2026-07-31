{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.aspects.services.kodi;
  kodi-gbm =
    let
      base = pkgs-stable.kodi-gbm.override {
        inherit (pkgs-stable) ffmpeg;
        x11Support = false;
      };
    in
    base.overrideAttrs (old: {
      version = "22.0b1";
      kodiReleaseName = "Piers";
      src = pkgs.fetchFromGitHub {
        owner = "xbmc";
        repo = "xbmc";
        rev = "22.0b1-Piers";
        hash = "sha256-WTnFExkD07WOJ0u1uZWkpC8pzG0D7ZpdE1lfonzdCFY=";
      };
      patches = [ ];
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs-stable.libsysprof-capture
        pkgs-stable.sysprof.dev
        pkgs-stable.pcre2.dev
        pkgs-stable.nlohmann_json
      ];
      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs-stable.crossguid
        pkgs-stable.exiv2
      ];
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        "-DLIBXSLT_LIBRARY=${lib.getLib pkgs-stable.libxslt}/lib/libxslt.so"
        "-DLIBXSLT_INCLUDE_DIR=${lib.getDev pkgs-stable.libxslt}/include"
      ];
    });

  kodiPkg =
    if cfg.plugins == [ ] then
      kodi-gbm
    else
      kodi-gbm.withPackages (kodiPkgs: with kodiPkgs; cfg.plugins);
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
