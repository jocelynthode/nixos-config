{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.taskwarrior.enable = lib.mkOption {
    default = false;
    example = true;
  };

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

      systemd.user = {
        services.taskwarrior-sync = {
          Unit = {
            Description = "Run task sync periodically";
            After = [
              "network-online.target"
            ];
            Wants = [
              "taskwarrior-sync.timer"
              "timers.target"
            ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.taskwarrior3}/bin/task sync";
          };
        };
        timers.taskwarrior-sync = {
          Unit = {
            Description = "Run task sync";
            After = [
              "network-online.target"
            ];
            Requires = [
              "taskwarrior-sync.service"
            ];
          };
          Timer = {
            Unit = "taskwarrior-sync.service";
            OnCalendar = "*:0/15";
          };
          Install = {
            WantedBy = ["timers.target"];
          };
        };
      };
    };
  };
}
