{ lib, ... }: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Fixed in master so not needed after https://github.com/NixOS/nixpkgs/commit/d534fa7085900882da0ca9b5ac0e5ad7c5070c81
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_CH.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "fr_CH.UTF-8";
      LC_MONETARY = "fr_CH.UTF-8";
      LC_MEASUREMENT = "fr_CH.UTF-8";
      LC_COLLATE = "fr_CH.UTF-8";
    };
  };
  time.timeZone = "Europe/Zurich";
}
