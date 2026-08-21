{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python3Packages,
}:

buildHomeAssistantComponent {
  owner = "jocelynthode";
  domain = "groupe_e";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jocelynthode";
    repo = "hscs-groupe-e";
    rev = "5ec3972da1bff64fcb0c8ae9c0995ee4cccb188c";
    hash = "sha256-WvqsNmHPQgKL1baGmgB25tvA8Ob07hYVDZJJJND+1Pk=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/jocelynthode/hscs-groupe-e";
  };
}
