{ config, pkgs, ... }: {
  home = {
    packages = with pkgs; [ gnome.gnome-keyring ];
    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"; # For gnome-keyring
    };
  };
  
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
}
