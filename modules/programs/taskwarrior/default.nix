{ config, lib, pkgs, ... }: {
  options.aspects.programs.taskwarrior.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.taskwarrior.enable {
    home-manager.users.jocelyn = { ... }: {
      programs.taskwarrior = {
        enable = true;
        config = {
          context.work.read = "+work";
          context.work.write = "+work";
          context.home.read = "+home";
          context.home.write = "+home";
        };
      };
    };
  };
}

