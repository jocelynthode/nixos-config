{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf config.aspects.graphical.firefox.enable {
    aspects.base.persistence.homePaths = [
      ".mozilla/firefox"
      ".cache/mozilla"
    ];

    home-manager.users.jocelyn = _: {
      programs.librewolf.enable = true;
      programs.firefox = {
        enable = true;
        profiles = {
          jocelyn = {
            bookmarks = {};
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              betterttv
              bitwarden
              consent-o-matic
              don-t-fuck-with-paste
              multi-account-containers
              greasemonkey
              kagi-search
              simple-tab-groups
              simplelogin
              sponsorblock
              stylus
              tree-style-tab
              ublock-origin
              videospeed
            ];
            userChrome = ''
              /* Hide tab bar in FF Quantum */
              #TabsToolbar {
                display: none;
              }

              #sidebar-header {
                display: none;
              }
            '';
            settings = {
              "browser.startup.homepage" = "about:blank";
              "browser.startup.page" = 3;
              "browser.aboutwelcome.enabled" = false;
              "browser.privatebrowsing.preserveClipboard" = false;
              "extensions.pocket.enabled" = false;
              "privacy.trackingprotection.enabled" = true;
              "dom.security.https_only_mode" = true;
              "dom.private-attribution.submission.enabled" = false;
              "browser.search.region" = "CH";
              "media.eme.enabled" = true;
              "media.getusermedia.aec_enabled" = false;
              "media.getusermedia.agc_enabled" = false;
              "media.getusermedia.agc2_enabled" = false;
              "media.getusermedia.noise_enabled" = false;
              "media.getusermedia.hpf_enabled" = false;
              # "media.rdd-ffmpeg.enabled" = true;
              # "media.ffmpeg.vaapi.enabled" = true;
              # "media.navigator.mediadatadecoder_vpx_enabled" = true;
              # "media.ffvpx.enabled" = false;
              # "media.rdd-vpx.enabled" = false;
              # "media.rdd-process.enabled" = false;
              "general.useragent.locale" = "fr-CH";
              "browser.shell.checkDefaultBrowser" = true;
              "browser.shell.defaultBrowserCheckCount" = 1;
              "browser.bookmarks.showMobileBookmarks" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "layout.css.devPixelsPerPx" = -1;
              "security.ssl.require_safe_negotiation" = true;
              # "ui.textScaleFactor" = config.aspects.graphical.dpi;
            };
          };
        };
      };
    };
  };
}
