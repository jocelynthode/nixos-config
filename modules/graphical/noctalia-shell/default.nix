{
  config,
  lib,
  noctalia,
  ...
}:
let
  cfg = config.aspects.graphical.noctalia-shell;
in
{
  options.aspects.graphical.noctalia-shell = {
    enable = lib.mkEnableOption "Noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    aspects.base.persistence.homePaths = [
      ".config/noctalia"
      ".cache/noctalia"
    ];

    home-manager.sharedModules = [ noctalia.homeModules.default ];

    home-manager.users.jocelyn =
      { osConfig, ... }:
      {
        home.file.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON { defaultWallpaper = osConfig.stylix.image; };
        };

        xdg.configFile."noctalia/sounds" = {
          source = ./sounds;
          recursive = true;
        };

        stylix.targets.noctalia-shell.enable = false;

        programs.noctalia-shell = {
          enable = true;

          settings = {
            appLauncher = {
              terminalCommand = "kitty -e"; # default: "alacritty -e"
            };

            audio = {
              mprisBlacklist = [ "firefox" ]; # default: []
              preferredPlayer = "feishin"; # default: ""
            };

            bar = {
              backgroundOpacity = 0.7; # default: 0.93
              capsuleOpacity = 0.7; # default: 1
              marginHorizontal = 12; # default: 4
              monitors = [
                "eDP-1"
                "DP-1"
                "DP-3"
                "DP-4"
              ]; # default: []
              showCapsule = false; # default: true
              useSeparateOpacity = true; # default: false

              widgets = {
                center = [
                  {
                    compactMode = false;
                    hideMode = "hidden";
                    hideWhenIdle = false;
                    id = "MediaMini";
                    maxWidth = 250;
                    scrollingMode = "always";
                    showAlbumArt = true;
                    showArtistFirst = true;
                    showProgressRing = true;
                    showVisualizer = false;
                    useFixedWidth = false;
                    visualizerType = "linear";
                  }
                  {
                    customFont = "";
                    formatHorizontal = "ddd, dd MMM yyyy HH:mm:ss";
                    formatVertical = "HH mm - dd MM";
                    id = "Clock";
                    tooltipFormat = "ddd, dd MMM yyyy HH:mm:ss";
                    useCustomFont = false;
                  }
                ];

                left = [
                  {
                    characterCount = 5;
                    colorizeIcons = false;
                    enableScrollWheel = false;
                    followFocusedScreen = true;
                    groupedBorderOpacity = 1;
                    hideUnoccupied = true;
                    iconScale = 0.8;
                    id = "Workspace";
                    labelMode = "none";
                    showApplications = false;
                    showLabelsOnlyWhenOccupied = false;
                    unfocusedIconsOpacity = 1;
                  }
                  {
                    compactMode = false;
                    diskPath = "/";
                    id = "SystemMonitor";
                    showCpuTemp = false;
                    showCpuUsage = true;
                    showDiskUsage = true;
                    showGpuTemp = false;
                    showLoadAverage = false;
                    showMemoryAsPercent = true;
                    showMemoryUsage = true;
                    showNetworkStats = true;
                    useMonospaceFont = true;
                  }
                ];

                right = [
                  {
                    displayMode = "alwaysShow";
                    id = "VPN";
                  }
                  {
                    displayMode = "alwaysShow";
                    id = "Network";
                  }
                  {
                    hideWhenZero = false;
                    id = "NotificationHistory";
                    showUnreadBadge = true;
                  }
                  {
                    displayMode = "alwaysShow";
                    id = "Microphone";
                    middleClickCommand = "pwvucontrol || pavucontrol";
                  }
                  {
                    displayMode = "alwaysShow";
                    id = "Volume";
                    middleClickCommand = "pwvucontrol || pavucontrol";
                  }
                  {
                    displayMode = "onhover";
                    id = "Brightness";
                  }
                  {
                    displayMode = "onhover";
                    id = "Bluetooth";
                  }
                  {
                    id = "NightLight";
                  }
                  {
                    displayMode = "graphic";
                    deviceNativePath = "__default__";
                    hideIfNotDetected = true;
                    id = "Battery";
                    showNoctaliaPerformance = false;
                    showPowerProfiles = true;
                  }
                  {
                    blacklist = [ ];
                    colorizeIcons = false;
                    drawerEnabled = false;
                    hidePassive = false;
                    id = "Tray";
                    pinned = [ ];
                  }
                  {
                    colorizeDistroLogo = false;
                    colorizeSystemIcon = "primary";
                    customIconPath = "";
                    enableColorization = true;
                    icon = "noctalia";
                    id = "ControlCenter";
                    useDistroLogo = true;
                  }
                ];
              };
            };

            colorSchemes = {
              predefinedScheme = "Catppuccin"; # default: "Noctalia (default)"
            };

            controlCenter = {
              shortcuts = {
                left = [
                  { id = "Network"; }
                  { id = "Bluetooth"; }
                  { id = "WallpaperSelector"; }
                  # default also includes NoctaliaPerformance
                ];
                right = [
                  { id = "Notifications"; }
                  { id = "PowerProfile"; }
                  { id = "KeepAwake"; }
                  { id = "NightLight"; }
                ];
              };
            };

            dock = {
              enabled = false; # default: true
            };

            general = {
              compactLockScreen = true; # default: false
            };

            location = {
              autoLocate = false; # default: true
              firstDayOfWeek = 1; # default: -1
              hideWeatherCityName = true; # default: false
              name = "Fribourg"; # default: ""
              weatherShowEffects = false; # default: true
            };

            network = {
              bluetoothRssiPollIntervalMs = 10000; # default: 60000
            };

            nightLight = {
              enabled = true; # default: false
            };

            notifications = {
              monitors = [
                "eDP-1"
                "DP-1"
                "DP-3"
                "DP-4"
              ]; # default: []

              sounds = {
                criticalSoundFile = "/home/jocelyn/.config/noctalia/sounds/link.wav"; # default: ""
                enabled = true; # default: false
                lowSoundFile = "/home/jocelyn/.config/noctalia/sounds/link.wav"; # default: ""
                normalSoundFile = "/home/jocelyn/.config/noctalia/sounds/link.wav"; # default: ""
                volume = 0.9; # default: 0.5
              };
            };

            osd = {
              enabledTypes = [
                0
                1
                2
                null
              ]; # default: [0, 1, 2]
              monitors = [
                "eDP-1"
                "DP-1"
                "DP-3"
                "DP-4"
              ]; # default: []
            };

            sessionMenu = {
              largeButtonsLayout = "grid"; # default: "single-row"
              powerOptions = [
                { action = "lock"; }
                { action = "suspend"; }
                { action = "hibernate"; }
                { action = "reboot"; }
                { action = "logout"; }
                { action = "shutdown"; }
                # default also includes rebootToUefi
              ];
            };

            settingsVersion = 59;

            ui = {
              fontDefault = osConfig.aspects.base.fonts.regular.family; # default: ""
              fontFixed = osConfig.aspects.base.fonts.monospace.family; # default: ""
              panelBackgroundOpacity = 0.9; # default: 0.93
            };

            wallpaper = {
              directory = "/home/jocelyn/Pictures"; # default: ""
            };
          };
        };
      };
  };
}
