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
    rev = "dc2f80287e75cf89b5321d91cc158a9aea430bf8";
    hash = "sha256-woynYUge3XWG/0UrhPqSOHeeajLr6fzfbbpttqw6aNY=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.homepage = "https://github.com/jocelynthode/taxi.nvim";
}
