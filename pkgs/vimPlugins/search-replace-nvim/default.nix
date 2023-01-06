{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "search-replace-nvim";
  version = "2023-01-05";
  src = fetchFromGitHub {
    owner = "roobert";
    repo = "search-replace.nvim";
    rev = "582981f2795fff2a79d3a60844552047a397bffa";
    sha256 = "sha256-k5FgWYr7rSe9TxQTnng+BDf/FUmqOvkF4giPwtMlFFk=";
  };
  meta.homepage = "https://github.com/roobert/search-replace.nvim";
}
