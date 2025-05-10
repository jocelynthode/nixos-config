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
  };

  networking.wireless.enable = false;

  fileSystems = {
    "/var/www/dde" = {
      device = "/dev/disk/by-label/dde";
      fsType = "ext4";
      options = ["defaults" "noatime"];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 8;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        intel-media-sdk # QSV up to 11th gen
      ];
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "i965";
    LIBVA_DRIVERS_PATH = "${pkgs.intel-vaapi-driver}/lib/dri";
  };

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=poweroff
      HandlePowerKeyLongPress=poweroff
    '';
  };
}
