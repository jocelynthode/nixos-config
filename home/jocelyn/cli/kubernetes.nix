{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubectx
    kubelogin-oidc
    kubernetes-helm
    kubectl-node-shell
    # kubectl-get-all
    # kubectl-neat
  ];
}
