{ vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-dap-go";
  version = "2022-11-14";
  src = fetchFromGitHub {
    owner = "leoluz";
    repo = "nvim-dap-go";
    rev = "c75921726ccfe97070285f206de49eddff276ea5";
    sha256 = "sha256-utDon+npwT1wT+clL+y+pau515hCUdeqvfUDPucu/+k=";
  };
  meta.homepage = "https://github.com/leoluz/nvim-dap-go";
}

