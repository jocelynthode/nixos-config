{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf config.aspects.graphical.firefox.enable {
    aspects.base.persistence.homePaths = [
      ".config/mozilla"
      ".cache/mozilla"
    ];

    home-manager.users.jocelyn =
      { config, ... }:
      {
        xdg.configFile."tridactyl" = {
          source = ./tridactyl;
        };

        stylix.targets.firefox.profileNames = [ "jocelyn" ];

        programs.firefox = {
          enable = true;
          nativeMessagingHosts = [
            pkgs.pkgs.tridactyl-native
          ];
          configPath = "${config.xdg.configHome}/mozilla/firefox";
          profiles = {
            jocelyn = {
              bookmarks = { };
              extensions = {
                packages = with pkgs.nur.repos.rycee.firefox-addons; [
                  betterttv
                  bitwarden
                  consent-o-matic
                  don-t-fuck-with-paste
                  multi-account-containers
                  greasemonkey
                  kagi-search
                  simplelogin
                  sponsorblock
                  stylus
                  ublock-origin
                  videospeed
                  tridactyl
                  sidebery
                  youtube-no-translation
                ];
              };
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
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "toolkit.telemetry.unified" = false;
                "browser.contentblocking.category" = "strict";
                "browser.ping-centre.telemetry" = false;
                "datareporting.healthreport.uploadEnabled" = false;
                "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                "browser.newtabpage.activity-stream.telemetry" = false;
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
                "media.rdd-ffmpeg.enabled" = true;
                "media.ffmpeg.vaapi.enabled" = true;
                "network.http.referer.XOriginTrimmingPolicy" = 2;
                "general.useragent.locale" = "fr-CH";
                "browser.shell.checkDefaultBrowser" = false;
                "browser.bookmarks.showMobileBookmarks" = true;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "layout.css.devPixelsPerPx" = -1;
                "security.ssl.require_safe_negotiation" = true;
                # "ui.textScaleFactor" = config.aspects.graphical.dpi;
                "widget.use-xdg-desktop-portal.mime-handler" = 1;
              };
            };
          };
        };
      };
  };
}
