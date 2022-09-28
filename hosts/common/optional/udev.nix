{ pkgs, ... }: {
  services.udev.packages = with pkgs; [
    qmk-udev-rules
    android-udev-rules
    yubikey-personalization
  ];
}
