{
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "mm-server-ui";
  version = "2022-12-28";

  src = fetchFromGitLab {
    owner = "nad0u";
    repo = "mm-server-ui";
    rev = "2ace7d3b90574896ebfe0da7b4254695aaa19df9";
    sha256 = "sha256-/gYmm3wkVZvfFP/f9Q2OWYlPi7z5MMeTAV7yc2DyNN0=";
  };
}
