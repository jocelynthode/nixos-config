{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.taskwarrior.enable = lib.mkEnableOption "taskwarrior";

  config = lib.mkIf config.aspects.programs.taskwarrior.enable {
    aspects.base.persistence.homePaths = [
      ".config/task"
      ".local/share/task"
    ];

    home-manager.users.jocelyn = _: {
      programs.taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;
        colorTheme =
          if config.aspects.theme == "dark"
          then "dark-256"
          else "light-256";
        config = {
          context = {
            work = {
              read = "+work";
              write = "+work";
            };
            home = {
              read = "+home";
              write = "+home";
            };
          };
        };
      };
    };
  };
}
