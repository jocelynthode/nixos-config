{ lib, vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPlugin {
  pname = "nvim-dap-go";
  version = "2022-09-08";
  src = fetchFromGitHub {
    owner = "leoluz";
    repo = "nvim-dap-go";
    rev = "fca8bf90bf017e8ecb3a3fb8c3a3c05b60d1406d";
    sha256 = "sha256-ZbQw4244BLiSoBipiPc1eEF2aV3BJLT7W8LmBl8xH4Q=";
  };
  meta.homepage = "https://github.com/leoluz/nvim-dap-go";
}

