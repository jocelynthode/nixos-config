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

      libdvdcss-src = pkgs.fetchurl {
        url = "https://mirrors.kodi.tv/build-deps/sources/libdvdcss-1.5.0.tar.bz2";
        hash = "sha256-8gSp2KyKhBQJXVVjc+Wvm5W7fMcr8UZ9k2pIyWHoxHQ=";
      };

      libdvdread-src = pkgs.fetchurl {
        url = "https://mirrors.kodi.tv/build-deps/sources/libdvdread-7.0.1.tar.bz2";
        hash = "sha256-tp902c7qHtFztXneupn2acLLQvP9BtfSOzP/IiqmN2M=";
      };

      libdvdnav-src = pkgs.fetchurl {
        url = "https://mirrors.kodi.tv/build-deps/sources/libdvdnav-7.0.0.tar.bz2";
        hash = "sha256-E2PN+vbpLAtXRXkpm1SA9YZ/symJRRRooo8/QC7Eh4c=";
      };

      # Kodi rc1 needs SWIG >= 4.5.0 for its Python bindings, newer than the
      # swig in nixpkgs-stable.  Upstream nixpkgs is moving to 4.5.x in
      # NixOS/nixpkgs#554403; pin the release kodi's binding tests target.
      swig = pkgs-stable.swig.overrideAttrs (_: {
        version = "4.5.0";
        src = pkgs.fetchFromGitHub {
          owner = "swig";
          repo = "swig";
          rev = "v4.5.0";
          hash = "sha256-NXN3Zx66PNpYNuFVCalHymb/GW0cUi5drjIXNOVMgb8=";
        };
      });
    in
    base.overrideAttrs (old: {
      version = "22.0rc1";
      kodiReleaseName = "Piers";

      src = pkgs.fetchFromGitHub {
        owner = "xbmc";
        repo = "xbmc";
        rev = "22.0rc1-Piers";
        hash = "sha256-zIQdK3Rj+TLSopJ1R10kEDlHkrgHa36HFN4VszSUJLM=";
      };

      patches = [ ];

      libdvdcss = libdvdcss-src;
      libdvdread = libdvdread-src;
      libdvdnav = libdvdnav-src;

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        pkgs-stable.libsysprof-capture
        pkgs-stable.sysprof.dev
        pkgs-stable.pcre2.dev
        pkgs-stable.nlohmann_json
        pkgs-stable.meson
        pkgs-stable.ninja
      ];

      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs-stable.crossguid
        pkgs-stable.exiv2
      ];

      # 22.x builds the DVD libraries from source with ExternalProject and reads
      # the tarball location from <MODULE>_URL (uppercase). 21.x used the
      # lowercase libdvdcss_URL-style variables, so drop those from the
      # inherited 21.3 flags to avoid unused-variable warnings.  The inherited
      # SWIG path is dropped too; see the 4.5.0 build above.
      cmakeFlags =
        lib.filter (f: !(lib.hasPrefix "-Dlibdvd" f) && !(lib.hasPrefix "-DSWIG_EXECUTABLE" f)) (
          old.cmakeFlags or [ ]
        )
        ++ [
          "-DLIBDVDCSS_URL=${libdvdcss-src}"
          "-DLIBDVDREAD_URL=${libdvdread-src}"
          "-DLIBDVDNAV_URL=${libdvdnav-src}"
          "-DSWIG_EXECUTABLE=${lib.getExe swig}"
          "-DLIBXSLT_LIBRARY=${lib.getLib pkgs-stable.libxslt}/lib/libxslt.so"
          "-DLIBXSLT_INCLUDE_DIR=${lib.getDev pkgs-stable.libxslt}/include"
        ];

      # Adding ninja to nativeBuildInputs switches the cmake hook to the Ninja
      # generator, so the inherited 21.3 checkPhase (which shells out to make)
      # has to be adapted.
      checkPhase =
        lib.replaceString "make -j $NIX_BUILD_CORES kodi-test"
          "${lib.getExe pkgs-stable.ninja} -j $NIX_BUILD_CORES kodi-test"
          old.checkPhase;
    });

  kodiPkg = if cfg.plugins == [ ] then kodi-gbm else kodi-gbm.withPackages (_: cfg.plugins);
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
    aspects.base.backup.includePaths = [ "/var/lib/kodi" ];

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
      allowedTCPPorts = [
        8088 # HTTP interface
        9090 # JSON-RPC
      ];
      allowedUDPPorts = [
        1900 # UPnP / SSDP Discovery
        3702 # WS-Discovery
        9777 # Event server
      ];
    };

    services.pulseaudio.enable = false;
    services.pipewire.enable = false;

    hardware.graphics.enable = true;
  };
}
