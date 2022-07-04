{ pkgs }: {
  homeManagerModules = import ./modules/home-manager;
} // (import ./pkgs { inherit pkgs; })
