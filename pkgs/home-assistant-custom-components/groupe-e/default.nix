{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python3Packages,
}:

buildHomeAssistantComponent {
  owner = "jocelynthode";
  domain = "groupe_e";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "jocelynthode";
    repo = "hscs-groupe-e";
    rev = "cea1f786cabb9fd85a0404dcddd5361ca5db3701";
    hash = "sha256-mM4+C++6vZYCLax3HJ70jcEX81Y2JsC/mZQ8ndvr+qs=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/jocelynthode/hscs-groupe-e";
  };
}
