{ inputs }:
let
  base = import ../modules/base/default.nix { inherit inputs; };
  programs = import ../modules/programs/default.nix { inherit inputs; };
  development = import ../modules/development/default.nix { inherit inputs; };
  graphical = import ../modules/graphical/default.nix { inherit inputs; };
  games = import ../modules/games/default.nix { inherit inputs; };
  work = import ../modules/work/default.nix { inherit inputs; };
  services = import ../modules/services/default.nix { inherit inputs; };

  inherit (base.flake.nixosModules) baseModule;
  inherit (programs.flake.nixosModules) programsModule;
  inherit (development.flake.nixosModules) developmentModule;
  inherit (graphical.flake.nixosModules) graphicalModule;
  inherit (games.flake.nixosModules) gamesModule;
  inherit (work.flake.nixosModules) workModule;
  inherit (services.flake.nixosModules) servicesModule;

  commonModule = {
    imports = [
      baseModule
      programsModule
    ];
  };
in
{
  common = commonModule;

  desktop = {
    _module.args.hostRole = "desktop";
    imports = [
      commonModule
      developmentModule
      graphicalModule
      gamesModule
      workModule
    ];
  };

  server = {
    _module.args.hostRole = "server";
    imports = [
      commonModule
      servicesModule
    ];
  };
}
