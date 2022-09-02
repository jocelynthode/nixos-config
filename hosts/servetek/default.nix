{ pkgs, inputs, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    # inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-laptop-hdd
    inputs.hardware.nixosModules.lenovo-thinkpad-t430
    inputs.hardware.nixosModules.common-gpu-nvidia-disable
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/gamemode.nix
    ../common/optional/gnome-keyring.nix
    # ../common/optional/nvidia.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/snapper.nix
    ../common/optional/udev.nix
    ../common/optional/xserver.nix
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
    enable = true;
    allowedTCPPorts = [ 80 5232 ];
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
}

