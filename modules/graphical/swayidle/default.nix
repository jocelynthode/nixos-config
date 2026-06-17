{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn = { config, ... }: {
      services.swayidle = {
        enable = true;
        systemdTargets = [ "graphical-session.target" ];
        events = {
          "before-sleep" = "${lib.getExe config.programs.noctalia.package} msg session lock";
          "lock" = "${lib.getExe config.programs.noctalia.package} msg session lock";
        };
        timeouts = [
          {
            timeout = 600;
            command = "${lib.getExe config.programs.noctalia.package} msg session lock";
          }
          {
            timeout = 610;
            command = "${lib.getExe config.programs.noctalia.package} msg mic-mute";
          }
          {
            timeout = 700;
            command = "${lib.getExe config.programs.noctalia.package} msg dpms-off";
            resumeCommand = "${lib.getExe config.programs.noctalia.package} msg dpms-on";
          }
        ];
      };
    };
  };
}
