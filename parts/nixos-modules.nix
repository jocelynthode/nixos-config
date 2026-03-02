{ config, ... }:
{
  config.flake.nixosModules = rec {
    common = {
      imports = [
        config.flake.nixosModules.baseModule
        config.flake.nixosModules.programsModule
      ];
    };

    desktop = {
      _module.args.hostRole = "desktop";
      imports = [
        common
        config.flake.nixosModules.developmentModule
        config.flake.nixosModules.graphicalModule
        config.flake.nixosModules.gamesModule
        config.flake.nixosModules.workModule
      ];
    };

    server = {
      _module.args.hostRole = "server";
      imports = [
        common
        config.flake.nixosModules.servicesModule
      ];
    };
  };
}
