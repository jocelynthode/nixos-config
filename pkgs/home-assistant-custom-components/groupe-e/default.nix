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
    rev = "ff7c9da1f2d31191c8b0150b92926d2e4f0ab8aa";
    hash = "sha256-00ToaTEYVSbZSK/xVO1zDb56Axm77iVF6AJlb/Ec1RI=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/jocelynthode/hscs-groupe-e";
  };
}
