{ inputs, ... }:
{
  role = "desktop";
  system = "x86_64-linux";
  includeAllNixpkgs = true;
  extraModules = [
    (import (inputs.hardware + "/common/cpu/intel"))
    (import (inputs.hardware + "/common/pc/laptop"))
    (import (inputs.hardware + "/common/pc/ssd"))
    (import (inputs.hardware + "/framework/13-inch/11th-gen-intel"))
  ];
}
