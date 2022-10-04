{ inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../secrets.yaml;

  sops.secrets."restic/env" = {};
  sops.secrets."restic/password" = {};
  sops.secrets."users/jocelyn/password" = {
    neededForUsers = true;
  };
}
