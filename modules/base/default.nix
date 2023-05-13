{
  config,
  options,
  lib,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    ./backup
    ./battery
    ./bluetooth
    ./btrfs
    ./cli
    ./fish
    ./fonts
    ./gnupg
    ./network
    ./nix
    ./nvim
    ./persistence
    ./sshd
    ./virtualisation
  ];

  options.aspects = {
    stateVersion = lib.mkOption {
      example = "22.05";
    };

    allowReboot = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = let
    colorscheme = {
      slug = "catppuccin-latte";
      name = "Catppuccin Latte";
      author = "Unknown";
      colors = {
        background = "#eff1f5";
        background01 = "#e6e9ef";
        background02 = "#ccd0da";
        background03 = "#bcc0cc";
        foreground01 = "#acb0be";
        foreground = "#4c4f69";
        foreground02 = "#dc8a78";
        foreground03 = "#7287fd";
        red = "#d20f39";
        orange = "#fe640b";
        yellow = "#df8e1d";
        green = "#40a02b";
        teal = "#179299";
        blue = "#1e66f5";
        purple = "#8839ef";
        brown = "#dd7878";
        pink = "#ea76cb";
      };
    };
  in {
    home-manager.useGlobalPkgs = true;
    home-manager.sharedModules = [nix-colors.homeManagerModule];

    aspects.base.btrfs.enable = lib.mkDefault true;
    aspects.base.persistence.enable = lib.mkDefault true;

    aspects.base.fonts = lib.mkDefault {
      monospace = {
        family = "JetBrains Mono Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        size = 11;
      };
      regular = {
        family = "NotoSans Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["Noto"];};
        size = 11;
      };
    };

    system = {
      inherit (config.aspects) stateVersion;
      autoUpgrade = {
        enable = true;
        flake = "github:jocelynthode/nixos-config";
        dates = "Sat *-*-* 00:00:00";
        randomizedDelaySec = "10min";
        inherit (config.aspects) allowReboot;
        rebootWindow = {
          lower = "00:00";
          upper = "06:00";
        };
      };
    };

    home-manager.users = {
      jocelyn = _: {
        home.stateVersion = config.aspects.stateVersion;
        systemd.user.sessionVariables = config.home-manager.users.jocelyn.home.sessionVariables;
        systemd.user.startServices = "sd-switch";
        colorScheme = colorscheme;
      };
      root = _: {
        home.stateVersion = config.aspects.stateVersion;
        systemd.user.startServices = "sd-switch";
        colorScheme = colorscheme;
      };
    };

    aspects.base.persistence = {
      homePaths = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
      systemPaths = [
        "/var/lib/systemd"
        {
          directory = "/var/lib/private"; # Used when services use DynamicUser and StateDirectory
          mode = "0700";
        }
        {
          directory = "/var/cache/private"; # Used when services use DynamicUser and CacheDirectory
          mode = "0700";
        }
        {
          directory = "/var/log/private"; # Used when services use DynamicUser and LogDirectory
          mode = "0700";
        }
      ];
    };

    sops = {
      defaultSopsFile = ../../secrets/common/secrets.yaml;
      secrets = {
        "restic/env" = {};
        "restic/password" = {};
        "restic/repository" = {};
        "users/jocelyn/password" = {
          neededForUsers = true;
        };
      };
    };

    environment = {
      enableAllTerminfo = true;
      variables = {
        TERMINAL = "kitty";
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "bat";
        OPENER = "xdg-open";
      };
      systemPackages = with pkgs; [
        git
        killall
        wget
        curl
        python3
        any-nix-shell
        fs-diff
        moreutils
        ldns
        gnumake
        gettext
        devenv
      ];
    };

    console = {
      keyMap = "us";
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "fr_CH.UTF-8";
        LC_MONETARY = "fr_CH.UTF-8";
        LC_MEASUREMENT = "fr_CH.UTF-8";
        LC_COLLATE = "fr_CH.UTF-8";
      };
    };
    time.timeZone = "Europe/Zurich";

    # security = {
    #   sudo.enable = false;
    #   doas = {
    #     enable = true;
    #     extraRules = [
    #       {
    #         users = [ "charlotte" ];
    #         noPass = true;
    #         cmd = "nix-collect-garbage";
    #         runAs = "root";
    #       }
    #     ];
    #   };
    #   polkit.enable = true;
    # };

    services.fwupd.enable = true;

    users = {
      mutableUsers = false;
      users = {
        jocelyn = {
          isNormalUser = true;
          shell = pkgs.fish;
          passwordFile =
            if !(options.virtualisation ? qemu)
            then config.sops.secrets."users/jocelyn/password".path
            else null;
          extraGroups = [
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfWwANBI/hiFVHf60jHaD4HAqFebg0GjCD/Up9jVR+1ocxHm2YycKhYpCba5XyvQsuDJTmWDBQI55EZAB1zuxsCcHicrqgS9Zo+EPAi6Dcr1q3kUYPx+p0DVlCwkym/9zsfidoCuIYtFpXjE0Q3PRPHduUp7hsZ/6rsWktHfTIhAWB8xsHZotQW2R1IDWubRLlhdUkiEwtkPcS8p6NeBIKQFQ/8W0CNG2J10jWH9X7fEy27AIHvy5OyczPkoSgUAhaBTyDjXu2tZw9sxYlO171Wl/lm/74Q+T8Vr/EJBW1qHfk3pYSzDmvdFgQDzY49I0NV3xdG9Bnvx6f8pm4WO/OrGByDF90GAUgdAvF2nRR8QXGpjO6/Q/rpZnx+t9YTJcdObg3SABFxYl1BCRDxpq4GuA8yQk8wG2KWREP9j4ollg2yxkOSC5Q20Vyfo06/CG4HeWFfpvdwcUqhotn0pvW3vIORa87fJyGcxFCtufhK/Fq4idEUnZqVfLGeTqkEaPNCDcgFsqTgapdwnWn4CU8um3x5wdurUWphtMc0vTBxF2ALNb+BRtXEGk3yyfjOgTku/G5+9XvpJwSW8dEf7C2UfAFUW8C7EI118cIbBJH1xvMR++0tw8Mi/ZgkPJszwKUQIvFUfH7tDsVSbN/A0ogtyz2QaVy770WS1ksMJCG0w== openpgp:0x2207C621"
          ];
          uid = 1000;
        };
        root = {
          home = "/root";
        };
      };
    };
  };
}
