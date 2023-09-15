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
    unfreePackages = lib.mkOption {
      default = [];
      example = [pkgs.discord];
    };
  };

  config = {
    aspects.base.persistence = {
      homePaths = lib.optional config.aspects.base.nix.enableDirenv ".local/share/direnv";
      systemPaths = lib.optional config.aspects.base.nix.enableDirenv "/root/.local/share/direnv";
    };

    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;

    nix = {
      settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://tekila.cachix.org"
          "https://hyprland.cachix.org"
          "https://devenv.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "tekila.cachix.org-1:Ujkoh3GxcP2pnxmUzMPqBasUVmnI61TUry0VaL0uD68="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];

        trusted-users = ["root" "@wheel"];
        auto-optimise-store = true;
      };
      package = pkgs.nixStable;
      extraOptions = ''
        experimental-features = nix-command flakes repl-flake
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "hourly";
        options = "--delete-older-than 7d";
      };
    };
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.aspects.base.nix.unfreePackages;

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
