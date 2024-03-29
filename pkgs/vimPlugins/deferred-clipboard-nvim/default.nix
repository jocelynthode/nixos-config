{
  vimUtils,
  fetchFromGitHub,
  unstableGitUpdater,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "deferred-clipboard-nvim";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "EtiamNullam";
    repo = "deferred-clipboard.nvim";
    rev = "v${version}";
    hash = "sha256-nanNQEtpjv0YKEkkrPmq/5FPxq+Yj/19cs0Gf7YgKjU=";
  };

  passthru.updateScript = unstableGitUpdater {};

  meta.homepage = "https://github.com/EtiamNullam/deferred-clipboard.nvim";
}
