{ vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPlugin {
  pname = "nvim-dap-python";
  version = "2022-11-14";
  src = fetchFromGitHub {
    owner = "mfussenegger";
    repo = "nvim-dap-python";
    rev = "27a0eff2bd3114269bb010d895b179e667e712bd";
    sha256 = "sha256-UlwLESRrfwtzQGP30nYVkELAQWs85eyo9ORIjMLr198=";
  };
  meta.homepage = "https://github.com/mfussenegger/nvim-dap-python";
}

