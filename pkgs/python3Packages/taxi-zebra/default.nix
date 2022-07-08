{ lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "taxi-zebra";
  version = "2.3.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "taxi_zebra";
    sha256 = "a6035610493306b5f7f68281e03b93dc0cc607fc2428600f95e9554cb1aaa181";
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
