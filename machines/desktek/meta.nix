{ inputs, ... }:
{
  role = "desktop";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-gpu-amd
  ];
}
