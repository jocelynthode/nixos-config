{ pkgs, ... }: {
  home.packages = with pkgs; [
    (taxi-cli.override { backends = [ python3Packages.taxi-zebra ]; })
  ];
}
