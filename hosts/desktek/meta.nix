{ inputs, ... }:
{
  role = "desktop";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    (import (inputs.hardware + "/common/cpu/amd"))
    (import (inputs.hardware + "/common/pc/ssd"))
    (import (inputs.hardware + "/common/gpu/amd"))
  ];
}
