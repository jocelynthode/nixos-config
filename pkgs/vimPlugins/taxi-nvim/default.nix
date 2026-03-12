{
  vimUtils,
  fetchFromGitHub,
  unstableGitUpdater,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "taxi-nvim";
  version = "2026-03-12";
  src = fetchFromGitHub {
    owner = "jocelynthode";
    repo = "taxi.nvim";
    rev = "dbdd5fbb1aeb91ea770cd091459166670998928f";
    hash = "sha256-t7PoxI9dmXW1eyVrsa98BA2i9YKuiIrGLAoP90dMtxI=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.homepage = "https://github.com/jocelynthode/taxi.nvim";
}
