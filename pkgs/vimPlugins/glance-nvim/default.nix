{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPluginFrom2Nix {
  pname = "glance-nvim";
  version = "2022-12-08";
  src = fetchFromGitHub {
    owner = "DNLHC";
    repo = "glance.nvim";
    rev = "cc087d378c3458fd2fb5ddf627af5e8fa1b76458";
    sha256 = "sha256-oM8xK9pl5WdOio1qbWlndikeDGGMMXmaDsRUriaQCBg=";
  };
  meta.homepage = "https://github.com/DNLHC/glance.nvim";
}
