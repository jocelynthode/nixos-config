{ config, ... }: {
  programs.htop = {
    enable = true;
    settings = {
      color_scheme = 6;
      cpu_count_from_one = 0;
      delay = 15;
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
      tree_view = 0;
    } // (with config.lib.htop; leftMeters [
      (bar "LeftCPUs2")
      (bar "CPU")
      (bar "Battery")
      (text "Blank")
      (text "Blank")
      (text "Blank")
      (graph "Memory")
      (text "NetworkIO")
      (text "DiskIO")
    ]) // (with config.lib.htop; rightMeters [
      (bar "RightCPUs2")
      (bar "Memory")
      (bar "Swap")
      (text "Blank")
      (text "Blank")
      (text "Blank")
      (graph "LoadAverage")
      (text "Uptime")
      (text "Systemd")
    ]);
  };
}
