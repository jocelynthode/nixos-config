{ inputs }:
{
  sharedModules = [
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        inputs.nur.overlays.default
        inputs.taxi.overlays.default
        inputs.wofi-ykman.overlays.default
        (import ../overlay { inherit inputs; })
      ];
      nix = {
        registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-master.flake = inputs.nixpkgs-master;
        };
      };
    }
    inputs.catppuccin.nixosModules.catppuccin
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];
}
