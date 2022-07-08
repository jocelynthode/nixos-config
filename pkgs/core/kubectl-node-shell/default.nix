{ pkgs, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "kubectl-node-shell";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "kvaps";
    repo = "kubectl-node-shell";
    rev = "v${version}";
    sha256 = "sha256-dAsNgvHgquXdb2HhLDYLk9IALneKkOxQxKb7BD90+1E=";
  };

  installPhase = ''
    install -m755 ./kubectl-node_shell -D $out/bin/kubectl-node_shell
  '';

  meta = with lib; {
    description = "Exec into node via kubectl ";
    homepage = "https://github.com/kvaps/kubectl-node-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
