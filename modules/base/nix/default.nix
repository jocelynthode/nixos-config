{ config, lib, pkgs, ... }:
let
  baseDirenv = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  baseNixIndex = {
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    systemd.user = {
      services.nix-index = {
        Unit = {
          Description = "Service to run nix-index";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.nix-index}/bin/nix-index";
        };
      };
      timers.nix-index = {
        Unit = {
          Description = "Timer that starts nix-index weekly";
          PartOf = [ "nix-index.service" ];
        };
        Timer = {
          OnCalendar = "weekly";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
in
{
  options.aspects.base.nix = {
    enableDirenv = lib.mkOption {
      default = true;
      example = false;
    };
    unfreePackages = lib.mkOption {
      default = [ ];
      example = [ pkgs.discord ];
    };
    # Note that this is only enabled for charlotte, until https://github.com/bennofs/nix-index/issues/143 is resolved.
    enableNixIndex = lib.mkOption {
      default = true;
      example = false;
    };
  };

  config = {

    aspects.base.persistence = {
      homePaths = 
        (lib.optional config.aspects.base.nix.enableDirenv ".local/share/direnv") ++
        (lib.optional config.aspects.base.nix.enableNixIndex ".cache/nix-index");
      systemPaths = (lib.optional config.aspects.base.nix.enableDirenv "/root/.local/share/direnv");
    };

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

        trusted-users = [ "root" "@wheel" ];
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

    home-manager.users.jocelyn = { ... }:
      lib.recursiveUpdate
        (lib.optionalAttrs config.aspects.base.nix.enableDirenv baseDirenv)
        (lib.optionalAttrs config.aspects.base.nix.enableNixIndex baseNixIndex);
    home-manager.users.root = { ... }: lib.optionalAttrs config.aspects.base.nix.enableDirenv baseDirenv;
  };
}
