{
  lib,
  hostRole ? "desktop",
  ...
}:
{
  imports = [
    ./base
    ./programs
  ]
  ++ lib.optionals (hostRole == "server") [
    ./services
  ]
  ++ lib.optionals (hostRole == "desktop") [
    ./development
    ./games
    ./graphical
    ./work
  ];
}
