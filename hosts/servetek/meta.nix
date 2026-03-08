{ inputs, ... }:
{
  role = "server";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    (import (inputs.hardware + "/common/cpu/intel"))
    (import (inputs.hardware + "/common/pc/ssd"))
  ];
}
