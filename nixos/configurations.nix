{
  inputs,
  lib,
  nixosModules,
  overlays,
}:
let
  autowire = lib.autowire;
  nixosArgs = lib.nixosArgs;
  nixpkgsLib = import (inputs.nixpkgs + "/lib");

  nixosSystem =
    args:
    import (inputs.nixpkgs + "/nixos/lib/eval-config.nix") {
      system = args.system;
      modules = args.modules;
      specialArgs = args.specialArgs or { };
    };

  sharedModules = [
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (final: _prev: { nur = import inputs.nur { pkgs = final; }; })
        inputs.taxi.overlays.default
        inputs.wofi-ykman.overlays.default
        overlays.default
      ];
      nix = {
        nixPath = [
          "nixpkgs=${toString inputs.nixpkgs}"
          "nixpkgs-master=${toString inputs.nixpkgs-master}"
          "nixpkgs-stable=${toString inputs.nixpkgs-stable}"
          "nixos-config=https://github.com/jocelynthode/nixos-config/archive/refs/heads/main.tar.gz"
          "nixos-hardware=${toString inputs.hardware}"
        ];
      };
    }
    (import (inputs.catppuccin + "/modules/nixos"))
    (import (inputs.disko + "/module.nix"))
    (import (inputs.home-manager + "/nixos"))
    (import (inputs.sops-nix + "/modules/sops"))
  ];

  forAllHosts = autowire.forAllDirsWithDefaultNix;

  roleModule =
    role:
    {
      desktop = nixosModules.desktop;
      server = nixosModules.server;
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
        let
          baseArgs =
            if (meta ? includeAllNixpkgs) && meta.includeAllNixpkgs then
              nixosArgs.mkHostSpecialArgs meta.system
            else
              inputs;
        in
        baseArgs // { inherit inputs; };
      roleModules = if (meta ? role) && (meta.role != null) then [ (roleModule meta.role) ] else [ ];
      commonModules = if roleModules == [ ] then [ nixosModules.common ] else [ ];
    in
    nixosSystem {
      system = meta.system;
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
  nixosConfigurations = nixpkgsLib.mapAttrs (_name: mkHost) (forAllHosts ../hosts);
}
