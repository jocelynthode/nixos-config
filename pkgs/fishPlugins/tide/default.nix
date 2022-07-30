{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin rec {
  pname = "tide";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "tide";
    rev = "v${version}";
    sha256 = "sha256-jswV+M3cNC3QnJxvugk8VRd3cOFmhg5ejLpdo36Lw1g=";
  };

  meta = {
    description = "The ultimate Fish prompt.";
    homepage = "https://github.com/IlanCosman/tide";
    license = lib.licenses.mit;
  };
}

