_: {
  nixosModules = rec {
    inherit
      baseModule
      programsModule
      developmentModule
      graphicalModule
      gamesModule
      workModule
      servicesModule
      ;

    common = {
      imports = [
        baseModule
        programsModule
      ];
    };

    desktop = {
      _module.args.hostRole = "desktop";
      imports = [
        common
        developmentModule
        graphicalModule
        gamesModule
        workModule
      ];
    };

    server = {
      _module.args.hostRole = "server";
      imports = [
        common
        servicesModule
      ];
    };
  };
}
