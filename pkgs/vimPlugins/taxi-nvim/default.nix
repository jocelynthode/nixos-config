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
    rev = "5d7914b0e9ee4826f4ad4b7bb7bbfef312c4a249";
    hash = "sha256-3GjSUphUVa3DIN9y3X/ZN9Y3FoAZ4i/dCrYtj2itpJs=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.homepage = "https://github.com/jocelynthode/taxi.nvim";
}
