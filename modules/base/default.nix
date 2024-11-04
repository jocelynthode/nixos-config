{
  config,
  options,
  lib,
  pkgs,
  nix-colors,
  catppuccin,
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
      palette = {
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
        accent = "#ea76cb";
      };
    };
  in {
    home-manager = {
      useGlobalPkgs = true;
      sharedModules = [
        nix-colors.homeManagerModule
        catppuccin.homeManagerModules.catppuccin
      ];
    };

    aspects.base = {
      btrfs.enable = lib.mkDefault true;
      persistence.enable = lib.mkDefault true;
      fonts = lib.mkDefault {
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
        ".local/share/keyrings"
      ];
      systemPaths = [
        "/var/lib/systemd"
        "/var/lib/nixos"
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

    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
      "jitsi-meet-1.0.8043"
    ];

    catppuccin = {
      enable = true;
      flavor = "latte";
      accent = "pink";
    };

    services.xserver = {
      xkb = {
        layout = "fr";
        variant = "ergol";
      };
      exportConfiguration = true;
    };

    console = {
      useXkbConfig = true;
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
    services.fwupd = {
      enable = true;
      extraRemotes = [
        "lvfs-testing"
      ];
      # daemonSettings.DisabledPlugins = [
      #   "upower"
      # ];
    };

    users = {
      mutableUsers = false;
      users = {
        jocelyn = {
          isNormalUser = true;
          shell = pkgs.fish;
          hashedPasswordFile =
            if !(options.virtualisation ? qemu)
            then config.sops.secrets."users/jocelyn/password".path
            else null;
          extraGroups = [
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDt+7HTCLF1Q658UrgvVb4a47Jp3aJt8mBY4dWltoHXUqXFkgfU7Y1zoDyEtylXRaqqSi4sWwW2WDT6wmzSx5DPf7y8sj9gSSpCSMoDOXlO2ylZdWdShpgXRJ4DZ0zlM0oWk5iNb+OdWLRluu7K1IYJZe5wMl8+fDsdXLg29xep8CwpjYAFtgPREImS5r5whMHLsUHQ19u0p3cGN2tvh9SW9otCL2rcCWz2KV09/VKWCzc6x5eVnsZtvw9VSmBrpnlt/DgXTqgCeg3L6smRSlyslQzswxhEesMpp+JJRdSD2wcWDZGoVsR9Yhbk9tOOZ3s79k5w2XVTqzYQnLagAS2YkSgS1+0+Wi4G+lqZ8ypEo0hzSpI4HcNxlRXGSAykkvp+TqkAsoOXd/0PauB6N24TBpfi2VDF/EDWSviyhJwD2KU8mLqXya57HwheDX/e35TNpYUwavN1Nf4FXZ/VdN+13mlAbQSkDQRa+bn/HeZGRZTwXmV0Vl0BAS0m8wWNJ223HJTiEVLuJuPMS9xLSvredULISh/9hXW7Ma86bVHA69lK7To8EFZGLZhXb5QH4sJeekPMdsuuioitHb5a0TploRzBrFCqmBM7N85uyBt4gXjMkYpf/kGtGiOAV4k8n9mFDyoCl1MvnP3JlUzRhMJ41Rz4tgCPHZ7s3Hq9lkU3Vw== openpgp:0x0D3B55DC"
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
