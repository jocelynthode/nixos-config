{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "taxi-zebra";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "liip";
    repo = "taxi-zebra";
    rev = version;
    sha256 = "sha256-5Sy/goElwLGt2Sg05Z8G04vsEZsTKCZKsI1/wQNifTI=";
  };

  propagatedBuildInputs = with python3Packages; [ taxi requests click ];

  meta = with lib; {
    homepage = "https://github.com/liip/taxi-zebra";
    description = "Zebra backend for taxi";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
