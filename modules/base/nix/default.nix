{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  baseDirenv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  baseNixIndex = {
    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;
  };
in {
  options.aspects.base.nix = {
    enableDirenv = lib.mkOption {
      default = true;
      example = false;
    };
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

        trusted-users = ["root" "@wheel"];
        auto-optimise-store = true;
      };
      package = pkgs.nixStable;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
    };

    home-manager = {
      sharedModules = [inputs.nix-index-database.hmModules.nix-index];
      users.jocelyn = _:
        lib.recursiveUpdate
        (lib.optionalAttrs config.aspects.base.nix.enableDirenv baseDirenv)
        baseNixIndex;
      users.root = _: baseNixIndex;
    };
  };
}
