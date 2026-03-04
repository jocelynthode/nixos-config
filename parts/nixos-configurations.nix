{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (inputs.self.lib) autowire;
  inherit (inputs.self.lib) nixosArgs;
  sharedModules = [
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        inputs.nur.overlays.default
        inputs.taxi.overlays.default
        inputs.wofi-ykman.overlays.default
        inputs.self.overlays.default
      ];
      nix = {
        registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-master.flake = inputs.nixpkgs-master;
          nixpkgs-stable.flake = inputs.nixpkgs-stable;
        };
      };
    }
    inputs.catppuccin.nixosModules.catppuccin
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  forAllHosts = autowire.forAllDirsWithDefaultNix;

  roleModule =
    role:
    {
      inherit (config.flake.nixosModules) desktop;
      inherit (config.flake.nixosModules) server;
    }
    .${role};

  mkHost =
    hostPath:
    let
      meta =
        if builtins.pathExists "${hostPath}/meta.nix" then
          import "${hostPath}/meta.nix" { inherit inputs; }
        else
          {
            system = "x86_64-linux";
            specialArgs = "host";
            extraModules = [ ];
          };
      specialArgs =
        if (meta ? includeAllNixpkgs) && meta.includeAllNixpkgs then
          nixosArgs.mkHostSpecialArgs meta.system
        else
          inputs;
      roleModules = if (meta ? role) && (meta.role != null) then [ (roleModule meta.role) ] else [ ];
      commonModules = if roleModules == [ ] then [ config.flake.nixosModules.common ] else [ ];
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit (meta) system;
      inherit specialArgs;
      modules =
        sharedModules
        ++ commonModules
        ++ [ (import hostPath) ]
        ++ roleModules
        ++ (meta.extraModules or [ ]);
    };
in
{
  config.flake.nixosConfigurations = lib.mapAttrs (_name: mkHost) (forAllHosts ../machines);
}
