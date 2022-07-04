{ lib, fishPlugins, fetchFromGitHub }:

fishPlugins.buildFishPlugin rec {
  pname = "colored_man_pages";
  version = "f885c2507128b70d6c41b043070a8f399988bc7a";

  src = fetchFromGitHub {
    owner = "patrickf1";
    repo = "colored_man_pages.fish";
    rev = version;
    sha256 = "0ifqdbaw09hd1ai0ykhxl8735fcsm0x2fwfzsk7my2z52ds60bwa";
  };

  meta = {
    description = "Fish shell plugin to colorize man pages";
    homepage = "https://github.com/PatrickF1/colored_man_pages.fish";
    license = lib.licenses.mit;
  };
}
