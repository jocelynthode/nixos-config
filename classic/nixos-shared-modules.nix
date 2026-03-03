{ inputs }:
{
  sharedModules = [
    (
      let
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixos-config=${toString ../.}"
        ];
      in
      {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          inputs.nur.overlays.default
          inputs.taxi.overlays.default
          inputs.wofi-ykman.overlays.default
          (import ../overlay { inherit inputs; })
        ];
        nix.nixPath = nixPath;
        nix.settings.nix-path = nixPath;
      }
    )
    inputs.catppuccin.nixosModules.catppuccin
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];
}
