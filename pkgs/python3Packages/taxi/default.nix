{ lib
, fetchFromGitHub
, python3Packages
, backends ? [ ]
}:

python3Packages.buildPythonPackage rec {
  pname = "taxi";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "sephii";
    repo = "taxi";
    rev = version;
    sha256 = "sha256-iIy3odDX3QzVG80AFp81m8AYKES4JjlDp49GGpuIHLI=";
  };

  checkInputs = with python3Packages; [ pytest pytestrunner freezegun ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    requests
    click
    setuptools
  ] ++ backends;

  meta = with lib; {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
