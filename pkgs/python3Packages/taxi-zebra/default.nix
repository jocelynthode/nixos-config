{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "taxi-zebra";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "liip";
    repo = "taxi-zebra";
    rev = version;
    sha256 = "sha256-L38cLdXZRqkHVJZL1wXnJc9KsVG3i/5T8amW55hsmMI=";
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
