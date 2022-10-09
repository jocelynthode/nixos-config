{ pkgs, lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume_offset=533760" "mitigations=off" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32);
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.sane.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-0 
    '';
  };
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
  ];
}
