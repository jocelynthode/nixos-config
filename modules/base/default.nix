{ config, lib, pkgs, nix-colors, ... }: {
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
    ./sshd
  ];

  options.aspects = {
    stateVersion = lib.mkOption {
      example = "22.05";
    };

    persistPrefix = lib.mkOption {
      default = "/persist";
      example = "/persist";
    };

    theme = lib.mkOption {
      default = "gruvbox-material-dark-hard";
      example = "gruvbox-material-dark-hard";
    };

    allowReboot = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.sharedModules = [ nix-colors.homeManagerModule ];

    aspects.base.btrfs.enable = lib.mkDefault true;

    aspects.base.fonts = lib.mkDefault {
      monospace = {
        family = "JetBrains Mono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        size = 11;
      };
      regular = {
        family = "NotoSans Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "Noto" ]; };
        size = 11;
      };
    };

    system = {
      stateVersion = config.aspects.stateVersion;
      autoUpgrade = {
        enable = true;
        flake = "github:jocelynthode/nixos-config";
        dates = "Sat *-*-* 00:00:00";
        randomizedDelaySec = "10min";
        allowReboot = config.aspects.allowReboot;
        rebootWindow = {
          lower = "01:00";
          upper = "05:00";
        };
      };
    };

    home-manager.users = {
      jocelyn = { ... }: {
        home.stateVersion = config.aspects.stateVersion;
        systemd.user.sessionVariables = config.home-manager.users.jocelyn.home.sessionVariables;
        systemd.user.startServices = "sd-switch";
        colorScheme = nix-colors.colorSchemes."${config.aspects.theme}";
      };
      root = { ... }: {
        home.stateVersion = config.aspects.stateVersion;
        systemd.user.startServices = "sd-switch";
        colorScheme = nix-colors.colorSchemes."${config.aspects.theme}";
      };
    };

    environment.persistence."${config.aspects.persistPrefix}" = {
      users.jocelyn.directories = [
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
      ];
      directories = [
        "/var/lib/systemd"
      ];
    };

    sops = {
      defaultSopsFile = ../../secrets/common/secrets.yaml;
      secrets = {
        "restic/env" = { };
        "restic/password" = { };
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
          passwordFile = config.sops.secrets."users/jocelyn/password".path;
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
