{ pkgs, ... }: {
  home.packages = with pkgs; [
    (taxi-cli.withPlugins (
      plugins: with plugins; [
        zebra
      ]
    ))
  ];
}
