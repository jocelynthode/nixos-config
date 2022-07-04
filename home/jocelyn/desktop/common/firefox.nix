{ pkgs, lib, ... }:

let
  addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      tree-style-tab
      ublock-origin
      https-everywhere
      videospeed
      greasemonkey
      don-t-fuck-with-paste
      betterttv
      multi-account-containers
    ];
    profiles = {
      jocelyn = {
        bookmarks = { };
        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.startup.page" = 3;
          "extensions.pocket.enabled" = false;
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;
          "browser.search.region" = "CH";
          "media.eme.enabled" = true;
          "general.useragent.locale" = "fr-CH";
          "browser.shell.checkDefaultBrowser" = true;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.bookmarks.showMobileBookmarks" = true;
        };
      };
    };
  };
}
