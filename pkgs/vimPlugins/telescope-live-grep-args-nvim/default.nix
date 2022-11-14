{ vimUtils, fetchFromGitHub, ... }:

# buildVimPlugin run make and buildVimPluginFrom2Nix does not 
vimUtils.buildVimPluginFrom2Nix {
  pname = "telescope-live-grep-args-nvim";
  version = "2022-11-14";
  src = fetchFromGitHub {
    owner = "nvim-telescope";
    repo = "telescope-live-grep-args.nvim";
    rev = "7de3baef1ec4fb77f7a8195fe87bebd513244b6a";
    sha256 = "sha256-RgGCaAolEWMXJet547ce0oW0+zsxQzXrKn+O9WgV1nk=";
  };
  meta.homepage = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim";
}

