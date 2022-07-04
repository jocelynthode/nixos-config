{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin rec {
  pname = "tide";
  version = "main";

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "tide";
    rev = version;
    sha256 = "sha256-6ys1SEfcWO0cRRNawrpnUU9tPJVVZ0E6RcPmrE9qG5g=";
  };

  meta = {
    description = "The ultimate Fish prompt.";
    homepage = "https://github.com/IlanCosman/tide";
    license = lib.licenses.mit;
  };
}

