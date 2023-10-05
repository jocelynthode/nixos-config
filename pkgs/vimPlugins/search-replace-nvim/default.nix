{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "search-replace-nvim";
  version = "unstable-2023-09-09";
  src = fetchFromGitHub {
    owner = "roobert";
    repo = "search-replace.nvim";
    rev = "d92290a02d97f4e9b8cd60d28b56b403432158d5";
    hash = "sha256-hEdEBDeHbJc3efgo7djktX4RemAiX8ZvQlJIEoAgkPM=";
  };
  meta.homepage = "https://github.com/roobert/search-replace.nvim";
}
