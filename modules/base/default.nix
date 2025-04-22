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
    ./neovim
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

    theme = lib.mkOption {
      default = "dark";
      example = "light";
    };
  };

  config = let
    colorscheme = {
      slug = "catppuccin-mocha";
      name = "Catppuccin Mocha";
      author = "Unknown";
      palette = {
        background = "#1e1e2e";
        background01 = "#313244";
        background02 = "#45475a";
        background03 = "#585b70";
        foreground = "#cdd6f4";
        foreground01 = "#6c7086";
        foreground02 = "#7f849c";
        foreground03 = "#9399b2";
        red = "#f38ba8";
        orange = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        blue = "#89b4fa";
        purple = "#cba6f7";
        brown = "#eba0ac";
        accent = "#f5c2e7";
      };
    };
  in {
    home-manager = {
      useGlobalPkgs = true;
      sharedModules = [
        nix-colors.homeManagerModule
        catppuccin.homeModules.catppuccin
      ];
    };

    aspects.base = {
      btrfs.enable = lib.mkDefault true;
      persistence.enable = lib.mkDefault true;
      fonts = lib.mkDefault {
        monospace = {
          family = "JetBrainsMono NFM";
          package = pkgs.nerd-fonts.jetbrains-mono;
          size = 11;
        };
        regular = {
          family = "NotoSans Nerd Font";
          package = pkgs.nerd-fonts.noto;
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
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    catppuccin = {
      enable = true;
      flavor = "mocha";
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
      earlySetup = true;
      font = "ter-powerline-v24b";
      packages = [
        pkgs.terminus_font
        pkgs.powerline-fonts
      ];
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
