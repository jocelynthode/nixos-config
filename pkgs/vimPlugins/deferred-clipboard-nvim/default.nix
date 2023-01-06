{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "deferred-clipboard-nvim";
  version = "2023-01-05";
  src = fetchFromGitHub {
    owner = "EtiamNullam";
    repo = "deferred-clipboard.nvim";
    rev = "f5022be07dea085c2b56fd26e86718f1ee19cf21";
    sha256 = "sha256-PxeggFnwzqGfvb7ZjUT1ixksnpaT9rZYPK//O5f2TXk=";
  };
  meta.homepage = "https://github.com/EtiamNullam/deferred-clipboard.nvim";
}
