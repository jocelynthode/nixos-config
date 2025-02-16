_: {
  programs.nixvim.plugins = {
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
          linehl = "";
          numhl = "";
        };
        dapBreakpointCondition = {
          text = "●";
          texthl = "DapBreakpointCondition";
          linehl = "";
          numhl = "";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DapLogPoint";
          linehl = "";
          numhl = "";
        };
      };
    };
    dap-ui.enable = true;
    dap-python.enable = true;
    dap-go.enable = true;
    dap-virtual-text.enable = true;
  };
}
