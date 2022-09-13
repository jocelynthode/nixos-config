{ pkgs, inputs, lib, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    # inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-laptop-hdd
    # inputs.hardware.nixosModules.lenovo-thinkpad-t430
    # inputs.hardware.nixosModules.common-gpu-nvidia-disable
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    #../common/optional/gamemode.nix
    ../common/optional/gnome-keyring.nix
    # ../common/optional/nvidia.nix
    ../common/optional/pipewire.nix
    # ../common/optional/podman.nix
    ../common/optional/snapper.nix
    ../common/optional/udev.nix
    ../common/optional/xserver.nix
  ];

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
  ];

  networking = {
    networkmanager.enable = true;
    wireguard.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    logitech.wireless.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs hostname colorscheme wallpaper; }; # Pass flake variable
  };

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/lib/radicale/collections"
        "/var/lib/acme"
      ];
    };
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 80 5232 8080 8112 6881 ];
  };

  services.ddclient = {
    enable = true;
    server = "www.ovh.com";
    ssl = true;
    username = "tekila.ovh-ident";
    domains = [ "dyn.tekila.ovh" ];
    passwordFile = config.age.secrets.ddclient-password.path;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jocelyn.thode+acme@gmail.com";
    certs = {
      "dav.tekila.ovh" = {
        listenHTTP = ":80";
        reloadServices = [ "radicale" ];
        group = "radicale";
      };
    };
  };

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" ];
        ssl = true;
        certificate = "${config.security.acme.certs."dav.tekila.ovh".directory}/fullchain.pem";
        key = "${config.security.acme.certs."dav.tekila.ovh".directory}/key.pem";
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets.radicale-htpasswd.path;
        htpasswd_encryption = "bcrypt";
      };
    };
  };

  age.secrets.radicale-htpasswd = {
    owner = "radicale";
    group = "radicale";
    file = ../common/secrets/radicale-htpasswd.age;
  };
  age.secrets.ddclient-password.file = ../common/secrets/ddclient-password.age;

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=poweroff
      HandlePowerKeyLongPress=poweroff
    '';
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    virtualHosts."tekila.ovh" = {
      root = "/var/www/dde";
      listen = [{ port = 8080; addr = "0.0.0.0"; ssl = false; }];
      locations."/" = {
        extraConfig = ''
          autoindex on;
          autoindex_exact_size on;
        '';
      };
    };
  };


  environment.etc = {
    "deluge/auth" = {
      text = ''
        deluge:deluge:5
      '';
      mode = "0440";
    };
  };


  services = {
    deluge = {
      enable = true;
      dataDir = "/var/www/dde/deluge";
    };
    deluge.web = {
      enable = true;
      port = 8112;
      openFirewall = true;
    };
  };

}

