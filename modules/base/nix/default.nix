{
  config,
  lib,
  pkgs,
  ...
}:
let
  baseDirenv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
in
{
  options.aspects.base.nix = {
    enableDirenv = lib.mkEnableOption "enableDirenv";
  };

  config = {
    aspects.base.persistence = {
      homePaths = lib.optional config.aspects.base.nix.enableDirenv ".local/share/direnv";
      systemPaths = lib.optional config.aspects.base.nix.enableDirenv "/root/.local/share/direnv";
    };

    programs = {
      command-not-found.enable = false;
      nix-index-database.comma.enable = true;
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };
    };

    nixpkgs.overlays = [
      (_final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];

    nix = {
      settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://tekila.cachix.org"
          "https://devenv.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "tekila.cachix.org-1:Ujkoh3GxcP2pnxmUzMPqBasUVmnI61TUry0VaL0uD68="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        keep-outputs = true;
        keep-derivations = true;
      };
      package = pkgs.lixPackageSets.stable.lix;
      extraOptions = ''
        !include ${config.sops.secrets.nixAccessTokens.path}
      '';
    };

    home-manager.users.jocelyn = _: lib.optionalAttrs config.aspects.base.nix.enableDirenv baseDirenv;
  };
}
