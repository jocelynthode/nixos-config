_: {
  programs.nixvim = {
    autoGroups = {
      _trim_trailspace = {
        clear = true;
      };
    };
    autoCmd = [
      {
        event = "BufWritePre";
        pattern = [
          "*"
        ];
        callback.__raw = ''
          function()
              if vim.bo.buftype == "" then
                  MiniTrailspace.trim()
                  MiniTrailspace.trim_last_lines()
              end
          end
        '';
        group = "_trim_trailspace";
      }
    ];
  };
}
