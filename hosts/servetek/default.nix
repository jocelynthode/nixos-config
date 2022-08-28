{ pkgs, inputs, config, hostname, colorscheme, wallpaper, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-laptop-hdd
    inputs.hardware.nixosModules.lenovo-thinkpad-t430
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/gamemode.nix
    ../common/optional/gnome-keyring.nix
    ../common/optional/nvidia.nix
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
}

