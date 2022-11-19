{ config, lib, pkgs, ... }: {
  options.aspects.programs.taskwarrior.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.taskwarrior.enable {
    sops.secrets."taskwarrior/certificate" = {
      sopsFile = ../../../secrets/common/secrets.yaml;
      owner = "jocelyn";
      group = "users";
    };

    sops.secrets."taskwarrior/key" = {
      sopsFile = ../../../secrets/common/secrets.yaml;
      owner = "jocelyn";
      group = "users";
    };

    sops.secrets."taskwarrior/ca" = {
      sopsFile = ../../../secrets/common/secrets.yaml;
      owner = "jocelyn";
      group = "users";
    };

    aspects.base.persistence.homePaths = [
      ".config/task"
      ".local/share/task"
    ];

    home-manager.users.jocelyn = _: {
      programs.taskwarrior = {
        enable = true;
        config = {
          context.work.read = "+work";
          context.work.write = "+work";
          context.home.read = "+home";
          context.home.write = "+home";
          taskd.certificate = config.sops.secrets."taskwarrior/certificate".path;
          taskd.key = config.sops.secrets."taskwarrior/key".path;
          taskd.ca = config.sops.secrets."taskwarrior/ca".path;
          taskd.credentials = "public/jocelyn/98c8e2b7-67e1-4680-a89d-4d562efc9f66";
          taskd.server = "tasks.tekila.ovh:53589";
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
            ExecStart = "${pkgs.taskwarrior}/bin/task sync";
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
            WantedBy = [ "timers.target" ];
          };
        };
      };
    };
  };
}

