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
    rev = "0d69e8bfcfd91f0f410a341205dde67bfb139ada";
    hash = "sha256-5vLViwGGyYX/+nYc4WmqfuYOdv/ZPYFIZ2jW9ShUZ5Y=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.homepage = "https://github.com/jocelynthode/taxi.nvim";
}
