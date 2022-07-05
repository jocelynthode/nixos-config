{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin rec {
  pname = "autopair";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "autopair.fish";
    rev = version;
    sha256 = "0lxfy17r087q1lhaz5rivnklb74ky448llniagkz8fy393d8k9cp";
  };

  meta = {
    description = "Auto-complete matching pairs in the Fish command line.";
    homepage = "https://github.com/jorgebucaran/autopair.fish";
    license = lib.licenses.mit;
  };
}
