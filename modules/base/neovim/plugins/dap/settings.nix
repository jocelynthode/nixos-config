{ pkgs, ... }:
{
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
    dap-go.enable = true;
    dap-lldb = {
      enable = true;
      settings = {
        codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      };
    };
    dap-python.enable = true;
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };
}
