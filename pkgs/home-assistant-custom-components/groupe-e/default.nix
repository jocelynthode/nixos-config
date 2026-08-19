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
    rev = "1b938a1b490fa49a8b126dd309e8bb2be0708455";
    hash = "sha256-MaW0tw6WkraAAk/ZReLqkFxzNR6PF4whUrjKgssAqUc=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/jocelynthode/hscs-groupe-e";
  };
}
