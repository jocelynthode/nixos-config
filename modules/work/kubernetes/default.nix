{ config, lib, pkgs, ... }: {
  options = {
    aspects.work.kubernetes.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.kubernetes.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      { directory = ".kube"; mode = "0700"; }
    ];

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        kubectl
        kubectx
        kubelogin-oidc
        kubernetes-helm
        kubectl-node-shell
        # kubectl-get-all
        # kubectl-neat
        openshift
      ];
    };
  };
}
