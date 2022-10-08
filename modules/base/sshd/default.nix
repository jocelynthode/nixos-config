{ config, ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    hostKeys = [
      {
        bits = 4096;
        path = "${config.aspects.persistPrefix}/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${config.aspects.persistPrefix}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
