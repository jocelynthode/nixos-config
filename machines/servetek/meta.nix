{ inputs, ... }:
{
  role = "server";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];
}
