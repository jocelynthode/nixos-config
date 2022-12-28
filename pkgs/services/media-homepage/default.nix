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
    sha256 = "sha256-EwGIGZZ/9u5dacRVS5brLi0I3EONoGhjc+oWzbcGcIA=";
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';
}
