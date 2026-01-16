{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.taskwarrior.enable = lib.mkEnableOption "taskwarrior";

  config = lib.mkIf config.aspects.programs.taskwarrior.enable {
    aspects.base.persistence.homePaths = [
      ".config/task"
      ".local/share/task"
    ];

    home-manager.users.jocelyn =
      { osConfig, ... }:
      {
        programs.taskwarrior =
          let
            # Prefer Stylix polarity when available; fall back to
            # the existing aspects.theme toggle elsewhere.
            stylixDark =
              if osConfig ? stylix && (osConfig.stylix.enable or false) then
                (osConfig.stylix.polarity or "either") != "light"
              else
                null;
            actuallyDark = if stylixDark != null then stylixDark else osConfig.aspects.theme == "dark";
          in
          {
            enable = true;
            package = pkgs.taskwarrior3;
            colorTheme = if actuallyDark then "dark-256" else "light-256";
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
