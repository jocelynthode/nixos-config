{
  services.snapper = {
    configs = {
      persist = {
        subvolume = "/persist";
        extraConfig = ''
          ALLOW_USERS="jocelyn"
          TIMELINE_CREATE="yes"
          TIMELINE_CLEANUP="yes"
          TIMELINE_LIMIT_HOURLY="10"
          TIMELINE_LIMIT_DAILY="3"
          TIMELINE_LIMIT_WEEKLY="0"
          TIMELINE_LIMIT_MONTHLY="0"
          TIMELINE_LIMIT_YEARLY="0"
        '';
      };
    };
  };
}
