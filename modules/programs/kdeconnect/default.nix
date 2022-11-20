{
  config,
  lib,
  ...
}: {
  options.aspects.programs.kdeconnect.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.kdeconnect.enable {
    aspects.base.persistence.homePaths = [
      ".config/kdeconnect"
    ];

    programs.kdeconnect.enable = true;

    home-manager.users.jocelyn = _: {
      # Hide all .desktop, except for org.kde.kdeconnect.settings
      xdg.desktopEntries = {
        "org.kde.kdeconnect.sms" = {
          exec = "";
          name = "KDE Connect SMS";
          settings.NoDisplay = "true";
        };
        "org.kde.kdeconnect.nonplasma" = {
          exec = "";
          name = "KDE Connect Indicator";
          settings.NoDisplay = "true";
        };
        "org.kde.kdeconnect.app" = {
          exec = "";
          name = "KDE Connect";
          settings.NoDisplay = "true";
        };
      };

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
