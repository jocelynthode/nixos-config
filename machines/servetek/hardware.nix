{
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = ["kvm-intel"];
    extraModprobeConfig = ''
      # enable in‑kernel block cloning (reflink) support
      options zfs zfs_bclone_enabled=1
    '';
  };

  networking.wireless.enable = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    intelgpu.vaapiDriver = "intel-media-driver";
    graphics = {
      enable = true;
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRIVERS_PATH = "${pkgs.intel-media-driver}/lib/dri";
  };

  zramSwap.enable = true;
}
