{ vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPlugin {
  pname = "nvim-dap-python";
  version = "2022-07-14";
  src = fetchFromGitHub {
    owner = "mfussenegger";
    repo = "nvim-dap-python";
    rev = "cc6732ab33a84b3a6b4300fcda5b2f837851b88e";
    sha256 = "sha256-E8JnKdju+gi5bVkGmxhTvG6BqCmi0Yu2wpba1Qj/TN8=";
  };
  meta.homepage = "https://github.com/mfussenegger/nvim-dap-python";
}

