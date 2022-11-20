{
  config,
  lib,
  ...
}: {
  options.aspects.base.sshd.permitRootLogin = lib.mkOption {
    default = "no";
    example = "yes";
  };

  config = {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      inherit (config.aspects.base.sshd) permitRootLogin;
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
      hostKeys = [
        {
          bits = 4096;
          path = "${config.aspects.base.persistence.persistPrefix}/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "${config.aspects.base.persistence.persistPrefix}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
