_: {
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai = {};
      bufremove = {};
      cursorword = {};
      diff = {};
      extra = {};
      hipatterns = {
        highlighters = {
          fixme = {
            pattern = "%f[%w]()FIXME()%f[%W]";
            group = "MiniHipatternsFixme";
          };
          hack = {
            pattern = "%f[%w]()HACK()%f[%W]";
            group = "MiniHipatternsHack";
          };
          todo = {
            pattern = "%f[%w]()TODO()%f[%W]";
            group = "MiniHipatternsTodo";
          };
          note = {
            pattern = "%f[%w]()NOTE()%f[%W]";
            group = "MiniHipatternsNote";
          };

          hex_color.__raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
        };
      };
      indentscope = {
        symbol = "▎";
        draw = {
          animation.__raw = "require('mini.indentscope').gen_animation.none()";
        };
      };
      move = {
        mappings = {
          left = "<A-Left>";
          right = "<A-Right>";
          down = "<A-Down>";
          up = "<A-Up>";

          line_left = "<A-Left>";
          line_right = "<A-Right>";
          line_down = "<A-Down>";
          line_up = "<A-Up>";
        };
        options = {
          reindent_linewise = true;
        };
      };
      pairs = {};
      surround = {};
      starter = {
        evaluate_single = true;
        header = ''
                                         __
            ___     ___    ___   __  __ /\_\    ___ ___
           / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
          /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
          \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
           \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
        '';
        items = {
          "__unkeyed-1.telescope".__raw = "require('mini.starter').sections.telescope()";
          "__unkeyed-2.buildtin_actions".__raw = "require('mini.starter').sections.builtin_actions()";
        };
      };
      trailspace = {};
    };
  };
}
