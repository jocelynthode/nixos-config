{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-dap-repl-highlights";
  version = "unstable-2023-05-09";

  src = fetchFromGitHub {
    owner = "LiadOz";
    repo = "nvim-dap-repl-highlights";
    rev = "0e14c948ad39c483ffc24a03238fcf41ae3c8b39";
    hash = "sha256-PEMZxBBhL546bT2RKiW8uAtN85Yw0diEx5a32BSl5As=";
  };

  meta = {
    description = "Add syntax highlighting to the nvim-dap REPL";
    homepage = "https://github.com/LiadOz/nvim-dap-repl-highlights";
  };
}
