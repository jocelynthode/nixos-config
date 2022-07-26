{ pkgs, inputs, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.framework
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/fingerprint.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/hibernate.nix
    ../common/optional/light.nix
    ../common/optional/pipewire.nix
    ../common/optional/plymouth.nix
    ../common/optional/podman.nix
    ../common/optional/restic.nix
    ../common/optional/snapper.nix
    ../common/optional/steam.nix
    ../common/optional/tlp.nix
    ../common/optional/xserver.nix
  ];

  networking = {
    networkmanager.enable = true;
    wireguard.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    video.hidpi.enable = true;
  };

  services.xserver.dpi = 120;
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.8";
  # };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs hostname colorscheme wallpaper; }; # Pass flake variable
  };
}

