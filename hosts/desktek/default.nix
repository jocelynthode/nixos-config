{ pkgs, inputs, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/adb.nix
    ../common/optional/gamemode.nix
    ../common/optional/pinentry.nix
    ../common/optional/kdeconnect.nix
    ../common/optional/nvidia.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/printer.nix
    ../common/optional/restic.nix
    ../common/optional/scanner.nix
    ../common/optional/snapper.nix
    ../common/optional/steam.nix
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
}

