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
    rev = "d407389c6ca145b20ae313c75b42797d249c2a6c";
    hash = "sha256-k/ZpFFeopdD7mE7beXrPYacIrMptCsbTW1yGzw6pT1E=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.homepage = "https://github.com/jocelynthode/taxi.nvim";
}
