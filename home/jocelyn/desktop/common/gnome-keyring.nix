{ config, pkgs, ... }: {
  # home = {
  #   packages = with pkgs; [ gnome.gnome-keyring ];
  #   sessionVariables = {
  #     SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"; # For gnome-keyring
  #   };
  # };
  # 
  # services.gnome-keyring = {
  #   enable = true;
  #   components = [
  #     "pkcs11"
  #     "secrets"
  #     "ssh"
  #   ];
  # };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    sshKeys = [ "2061C6E686AC5F11BFAF593156B477D691C4AFC2" ];
    pinentryFlavor = "gnome3";
  };
}
