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
    rev = "e7168aa24105d9dfe244ea63bfe58cbdb9aae541";
    hash = "sha256-LtYyVA63GUBIddo7w3EmZRma9d5WFrgoIBkCMv3bx2w=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/jocelynthode/hscs-groupe-e";
  };
}
