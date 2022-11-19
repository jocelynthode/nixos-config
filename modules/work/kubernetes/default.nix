{ config, lib, pkgs, ... }: {
  options = {
    aspects.work.kubernetes.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.kubernetes.enable {
    aspects.base.persistence.homePaths = [
      { directory = ".kube"; mode = "0700"; }
    ];

    home-manager.users.jocelyn = _: {
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
