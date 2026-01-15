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
    ];

    home-manager.sharedModules = [ noctalia.homeModules.default ];

    home-manager.users.jocelyn =
      { osConfig, ... }:
      {
        programs.noctalia-shell = {
          enable = true;
          systemd.enable = true;

          settings = {
            appLauncher = {
              autoPasteClipboard = false;
              clipboardWrapText = true;
              customLaunchPrefix = "";
              customLaunchPrefixEnabled = false;
              enableClipPreview = true;
              enableClipboardHistory = false;
              iconMode = "tabler";
              ignoreMouseInput = false;
              pinnedApps = [ ];
              position = "center";
              screenshotAnnotationTool = "";
              showCategories = true;
              showIconBackground = false;
              sortByMostUsed = true;
              terminalCommand = "kitty -e";
              useApp2Unit = false;
              viewMode = "list";
            };

            audio = {
              cavaFrameRate = 30;
              mprisBlacklist = [ "firefox" ];
              preferredPlayer = "feishin";
              visualizerType = "linear";
              volumeOverdrive = false;
              volumeStep = 5;
            };

            bar = {
              backgroundOpacity = 0.7;
              capsuleOpacity = 1;
              density = "default";
              exclusive = true;
              floating = true;
              marginHorizontal = 4;
              marginVertical = 4;
              monitors = [ "DP-1" ];
              outerCorners = true;
              position = "top";
              showCapsule = false;
              showOutline = false;
              useSeparateOpacity = true;

              widgets = {
                center = [
                  {
                    compactMode = false;
                    compactShowAlbumArt = true;
                    compactShowVisualizer = false;
                    hideMode = "hidden";
                    hideWhenIdle = false;
                    id = "MediaMini";
                    maxWidth = 250;
                    panelShowAlbumArt = true;
                    panelShowVisualizer = true;
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
                    usePrimaryColor = false;
                  }
                ];

                left = [
                  {
                    characterCount = 2;
                    colorizeIcons = false;
                    enableScrollWheel = true;
                    followFocusedScreen = true;
                    groupedBorderOpacity = 1;
                    hideUnoccupied = true;
                    iconScale = 0.8;
                    id = "Workspace";
                    labelMode = "index";
                    showApplications = false;
                    showLabelsOnlyWhenOccupied = true;
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
                    usePrimaryColor = false;
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
                    displayMode = "alwaysShow";
                    hideIfNotDetected = true;
                    id = "Battery";
                    showNoctaliaPerformance = false;
                    showPowerProfiles = true;
                    warningThreshold = 30;
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

            brightness = {
              brightnessStep = 5;
              enableDdcSupport = false;
              enforceMinimum = true;
            };

            calendar = {
              cards = [
                {
                  enabled = true;
                  id = "calendar-header-card";
                }
                {
                  enabled = true;
                  id = "calendar-month-card";
                }
                {
                  enabled = true;
                  id = "weather-card";
                }
              ];
            };

            colorSchemes = {
              darkMode = true;
              manualSunrise = "06:30";
              manualSunset = "18:30";
              matugenSchemeType = "scheme-fruit-salad";
              predefinedScheme = "Catppuccin";
              schedulingMode = "off";
              useWallpaperColors = false;
            };

            controlCenter = {
              cards = [
                {
                  enabled = true;
                  id = "profile-card";
                }
                {
                  enabled = true;
                  id = "shortcuts-card";
                }
                {
                  enabled = true;
                  id = "audio-card";
                }
                {
                  enabled = false;
                  id = "brightness-card";
                }
                {
                  enabled = true;
                  id = "weather-card";
                }
                {
                  enabled = true;
                  id = "media-sysmon-card";
                }
              ];

              diskPath = "/";
              position = "close_to_bar_button";

              shortcuts = {
                left = [
                  { id = "Network"; }
                  { id = "Bluetooth"; }
                  { id = "WallpaperSelector"; }
                ];

                right = [
                  { id = "Notifications"; }
                  { id = "PowerProfile"; }
                  { id = "KeepAwake"; }
                  { id = "NightLight"; }
                ];
              };
            };

            desktopWidgets = {
              enabled = false;
              gridSnap = false;
              monitorWidgets = [ ];
            };

            dock = {
              animationSpeed = 1;
              backgroundOpacity = 1;
              colorizeIcons = false;
              deadOpacity = 0.6;
              displayMode = "auto_hide";
              enabled = false;
              floatingRatio = 1;
              inactiveIndicators = false;
              monitors = [ ];
              onlySameOutput = true;
              pinnedApps = [ ];
              pinnedStatic = false;
              position = "bottom";
              size = 1;
            };

            general = {
              allowPanelsOnScreenWithoutBar = true;
              animationDisabled = false;
              animationSpeed = 1;
              avatarImage = "";
              boxRadiusRatio = 1;
              compactLockScreen = true;
              dimmerOpacity = 0.2;
              enableShadows = true;
              forceBlackScreenCorners = false;
              iRadiusRatio = 1;
              language = "";
              lockOnSuspend = true;
              radiusRatio = 1;
              scaleRatio = 1;
              screenRadiusRatio = 1;
              shadowDirection = "bottom_right";
              shadowOffsetX = 2;
              shadowOffsetY = 3;
              showChangelogOnStartup = true;
              showHibernateOnLockScreen = false;
              showScreenCorners = false;
              showSessionButtonsOnLockScreen = true;
              telemetryEnabled = false;
            };

            hooks = {
              darkModeChange = "";
              enabled = false;
              performanceModeDisabled = "";
              performanceModeEnabled = "";
              screenLock = "";
              screenUnlock = "";
              wallpaperChange = "";
            };

            location = {
              analogClockInCalendar = false;
              firstDayOfWeek = 1;
              hideWeatherCityName = true;
              hideWeatherTimezone = false;
              name = "Fribourg";
              showCalendarEvents = true;
              showCalendarWeather = true;
              showWeekNumberInCalendar = false;
              use12hourFormat = false;
              useFahrenheit = false;
              weatherEnabled = true;
              weatherShowEffects = true;
            };

            network = {
              bluetoothDetailsViewMode = "grid";
              bluetoothHideUnnamedDevices = false;
              bluetoothRssiPollIntervalMs = 10000;
              bluetoothRssiPollingEnabled = false;
              wifiDetailsViewMode = "grid";
              wifiEnabled = false;
            };

            nightLight = {
              autoSchedule = true;
              dayTemp = "6500";
              enabled = true;
              forced = false;
              manualSunrise = "06:30";
              manualSunset = "18:30";
              nightTemp = "4000";
            };

            notifications = {
              backgroundOpacity = 1;
              criticalUrgencyDuration = 15;
              enableKeyboardLayoutToast = true;
              enabled = true;
              location = "top_right";
              lowUrgencyDuration = 3;
              monitors = [ "DP-1" ];
              normalUrgencyDuration = 8;
              overlayLayer = true;
              respectExpireTimeout = false;

              saveToHistory = {
                critical = true;
                low = true;
                normal = true;
              };

              sounds = {
                criticalSoundFile = "";
                enabled = false;
                excludedApps = "discord,firefox,chrome,chromium,edge";
                lowSoundFile = "";
                normalSoundFile = "";
                separateSounds = false;
                volume = 0.5;
              };
            };

            osd = {
              autoHideMs = 2000;
              backgroundOpacity = 1;
              enabled = true;
              enabledTypes = [
                0
                1
                2
                null
              ];
              location = "top_right";
              monitors = [ "DP-1" ];
              overlayLayer = true;
            };

            sessionMenu = {
              countdownDuration = 10000;
              enableCountdown = true;
              largeButtonsLayout = "grid";
              largeButtonsStyle = true;
              position = "center";

              powerOptions = [
                {
                  action = "lock";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
                {
                  action = "suspend";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
                {
                  action = "hibernate";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
                {
                  action = "reboot";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
                {
                  action = "logout";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
                {
                  action = "shutdown";
                  command = "";
                  countdownEnabled = true;
                  enabled = true;
                }
              ];

              showHeader = true;
              showNumberLabels = true;
            };

            settingsVersion = 39;

            systemMonitor = {
              cpuCriticalThreshold = 90;
              cpuPollingInterval = 3000;
              cpuWarningThreshold = 80;
              criticalColor = "";
              diskCriticalThreshold = 90;
              diskPollingInterval = 3000;
              diskWarningThreshold = 80;
              enableDgpuMonitoring = false;
              externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
              gpuCriticalThreshold = 90;
              gpuPollingInterval = 3000;
              gpuWarningThreshold = 80;
              loadAvgPollingInterval = 3000;
              memCriticalThreshold = 90;
              memPollingInterval = 3000;
              memWarningThreshold = 80;
              networkPollingInterval = 3000;
              tempCriticalThreshold = 90;
              tempPollingInterval = 3000;
              tempWarningThreshold = 80;
              useCustomColors = false;
              warningColor = "";
            };

            templates = {
              alacritty = false;
              cava = false;
              code = false;
              discord = false;
              emacs = false;
              enableUserTemplates = false;
              foot = false;
              fuzzel = false;
              ghostty = false;
              gtk = false;
              helix = false;
              hyprland = false;
              kcolorscheme = false;
              kitty = false;
              mango = false;
              niri = false;
              pywalfox = false;
              qt = false;
              spicetify = false;
              telegram = false;
              vicinae = false;
              walker = false;
              wezterm = false;
              yazi = false;
              zed = false;
              zenBrowser = false;
            };

            ui = {
              bluetoothDetailsViewMode = "grid";
              bluetoothHideUnnamedDevices = false;
              boxBorderEnabled = false;
              fontDefault = osConfig.aspects.base.fonts.regular.family;
              fontDefaultScale = 1;
              fontFixed = osConfig.aspects.base.fonts.monospace.family;
              fontFixedScale = 1;
              networkPanelView = "ethernet";
              panelBackgroundOpacity = 0.9;
              panelsAttachedToBar = true;
              settingsPanelMode = "attached";
              tooltipsEnabled = true;
              wifiDetailsViewMode = "grid";
            };

            wallpaper = {
              directory = "/home/jocelyn/Pictures";
              enableMultiMonitorDirectories = false;
              enabled = true;
              fillColor = "#000000";
              fillMode = "crop";
              hideWallpaperFilenames = false;
              monitorDirectories = [ ];
              overviewEnabled = false;
              panelPosition = "follow_bar";
              randomEnabled = false;
              randomIntervalSec = 300;
              recursiveSearch = false;
              setWallpaperOnAllMonitors = true;
              solidColor = "#1a1a2e";
              transitionDuration = 1500;
              transitionEdgeSmoothness = 0.05;
              transitionType = "random";
              useSolidColor = false;
              useWallhaven = false;
              wallhavenApiKey = "";
              wallhavenCategories = "111";
              wallhavenOrder = "desc";
              wallhavenPurity = "100";
              wallhavenQuery = "";
              wallhavenRatios = "";
              wallhavenResolutionHeight = "";
              wallhavenResolutionMode = "atleast";
              wallhavenResolutionWidth = "";
              wallhavenSorting = "relevance";
              wallpaperChangeMode = "random";
            };
          };
        };
      };
  };
}
