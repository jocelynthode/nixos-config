{
  lib,
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-lsp-notify";
  version = "unstable-2023-03-19";
  src = fetchFromGitHub {
    owner = "mrded";
    repo = "nvim-lsp-notify";
    rev = "9986955e0423f2f5cdb3bd4f824bc980697646a0";
    hash = "sha256-J6PRYS62r4edMO6UDZKrOv2x6RFox5k3pqvVqlnz6hs=";
  };
  meta = with lib; {
    description = "NVIM plugin to notify about LSP processes";
    homepage = "https://github.com/mrded/nvim-lsp-notify";
    license = licenses.mit;
  };
}
