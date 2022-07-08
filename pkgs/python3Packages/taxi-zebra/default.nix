{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "taxi-zebra";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "liip";
    repo = "taxi-zebra";
    rev = version;
    sha256 = "sha256-aX3oiW0+qCHte0GzcNpUwPuubSexfqiGXaWoPY4JWi0=";
  };

  prePatch = ''
    substituteInPlace setup.py \
        --replace "taxi~=6.0" ""
  '';

  propagatedBuildInputs = with python3Packages; [ requests click ];

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/liip/taxi-zebra";
    description = "Zebra backend for taxi";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
