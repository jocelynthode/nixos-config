{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "search-replace-nvim";
  version = "unstable-2023-01-08";
  src = fetchFromGitHub {
    owner = "roobert";
    repo = "search-replace.nvim";
    rev = "b3485c9cd14319c5320bbdd74af0b3c67733490d";
    hash = "sha256-iPtviRmPOVncVSa7mySS7nS07Sh6Ma7NUVUZbpVXToU=";
  };
  meta.homepage = "https://github.com/roobert/search-replace.nvim";
}
