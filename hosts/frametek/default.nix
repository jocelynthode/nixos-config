{ pkgs, inputs, config, hostname, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.framework
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/fingerprint.nix
    ../common/optional/plymouth.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/light.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/steam.nix
    ../common/optional/xserver.nix
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/upower"
    ];
  };

  networking = {
    networkmanager.enable = true;
    wireguard.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs = {
    dconf.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      gnome.gnome-keyring
    ];
  };

  hardware = {
    bluetooth.enable = true;
    video.hidpi.enable = true;
  };

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;

  services.upower = {
    enable = true;
    # Default values: 10/3/2/HybridSleep
    percentageLow = 10;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "HybridSleep";
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      IdleAction=suspend
      IdleActionSec=15min
      HandlePowerKey=hibernate
      HandlePowerKeyLongPress=poweroff
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs hostname; }; # Pass flake variable
  };

  system.stateVersion = "22.11";
}

