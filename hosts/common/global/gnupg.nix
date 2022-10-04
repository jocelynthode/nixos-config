{ pkgs, ... }: {
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    gnupg-pkcs11-scd
  ];
}
