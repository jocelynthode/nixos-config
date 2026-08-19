{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python3Packages,
}:

buildHomeAssistantComponent rec {
  owner = "carnevlu";
  domain = "groupe_e";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "carnevlu";
    repo = "hscs-groupe-e";
    rev = "d1474e0abdf148dfb2ffd987c0e0fb4c6c3c430c";
    hash = "sha256-RRynku0nbOGKuYGYzi3n8ReNf5IdmkKoqx5LriUQvRU=";
  };

  dependencies = with python3Packages; [ aiohttp ];

  meta = {
    description = "Groupe-E Energy integration for Home Assistant";
    homepage = "https://github.com/carnevlu/hscs-groupe-e";
  };
}
