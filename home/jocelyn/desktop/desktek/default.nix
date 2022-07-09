{ pkgs, ... }:
{
  imports = [
    ./kdeconnect.nix
    ./simplescan.nix
    ./solaar.nix
  ];
}
