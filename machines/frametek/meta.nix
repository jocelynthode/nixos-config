{ inputs, ... }:
{
  role = "desktop";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.framework-11th-gen-intel
  ];
}
