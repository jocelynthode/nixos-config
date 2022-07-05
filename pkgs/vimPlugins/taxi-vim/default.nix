{ lib, vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPluginFrom2Nix {
  pname = "taxi-vim";
  version = "2022-07-01";
  src = fetchFromGitHub {
    owner = "schtibe";
    repo = "taxi.vim";
    rev = "4b3f3ad59074071ea60cd7521811070ee758f0aa";
    sha256 = "sha256-Q+K40Gadiihfg1r4q1GQrikHyFckGzfL7KCZt6F6aec=";
  };
  meta.homepage = "https://github.com/schtibe/taxi.vim";
}

