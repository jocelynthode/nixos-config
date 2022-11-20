{
  lib,
  fishPlugins,
  fetchFromGitHub,
}:
fishPlugins.buildFishPlugin rec {
  pname = "tide";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "tide";
    rev = "v${version}";
    sha256 = "sha256-vi4sYoI366FkIonXDlf/eE2Pyjq7E/kOKBrQS+LtE+M=";
  };

  meta = {
    description = "The ultimate Fish prompt.";
    homepage = "https://github.com/IlanCosman/tide";
    license = lib.licenses.mit;
  };
}
