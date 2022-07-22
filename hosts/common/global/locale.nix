{ lib, ... }: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "fr_CH.UTF-8";
      LC_MONETARY = "fr_CH.UTF-8";
      LC_MEASUREMENT = "fr_CH.UTF-8";
      LC_COLLATE = "fr_CH.UTF-8";
    };
  };
  time.timeZone = "Europe/Zurich";
}
