{ inputs }:
let
  shared = import ./nixos-shared-modules.nix { inherit inputs; };
  nixosModules = import ./nixos-modules.nix { inherit inputs; };

  inherit (shared) sharedModules;
in
{
  desktek =
    sharedModules
    ++ [
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      inputs.hardware.nixosModules.common-gpu-amd
    ]
    ++ [
      nixosModules.desktop
      ../machines/desktek
    ];

  frametek =
    sharedModules
    ++ [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.hardware.nixosModules.common-pc-laptop
      inputs.hardware.nixosModules.common-pc-laptop-ssd
      inputs.hardware.nixosModules.framework-11th-gen-intel
    ]
    ++ [
      nixosModules.desktop
      ../machines/frametek
    ];

  servetek =
    sharedModules
    ++ [
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.hardware.nixosModules.common-pc-ssd
    ]
    ++ [
      nixosModules.server
      ../machines/servetek
    ];

  iso = sharedModules ++ [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    nixosModules.common
    ../machines/iso
  ];
}
