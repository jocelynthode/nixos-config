local _, which_key = pcall(require, "which-key")

local setup = {
  plugins = {
    spelling = {
      enabled = true,  -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 5, -- how many suggestions should be shown in the list?
    },
  },
}

local mappings = {
  { "<leader>F",   "<cmd>Telescope live_grep_args<cr>",                                   desc = "Find Text",                                  nowait = true, remap = false },
  { "<leader>b",   "<cmd>Telescope buffers<cr>",                                          desc = "Buffers",                                    nowait = true, remap = false },

  { "<leader>d",   group = "Debug",                                                       nowait = true,                                       remap = false },
  { "<leader>dC",  "<cmd>lua require'dap'.run_to_cursor()<cr>",                           desc = "Run To Cursor",                              nowait = true, remap = false },
  { "<leader>dG",  group = "Go",                                                          nowait = true,                                       remap = false },
  { "<leader>dGl", "<cmd>lua require('dap-go').debug_last_test()<cr>",                    desc = "Debug Last Test",                            nowait = true, remap = false },
  { "<leader>dGt", "<cmd>lua require('dap-go').debug_test()<cr>",                         desc = "Debug Test",                                 nowait = true, remap = false },
  { "<leader>dP",  group = "Python",                                                      nowait = true,                                       remap = false },
  { "<leader>dPc", "<cmd>lua require('dap-python').test_class()<cr>",                     desc = "Debug Class",                                nowait = true, remap = false },
  { "<leader>dPm", "<cmd>lua require('dap-python').test_method()<cr>",                    desc = "Debug Method",                               nowait = true, remap = false },
  { "<leader>dPs", "<cmd>lua require('dap-python').debug_selection()<cr>",                desc = "Debug Selection",                            nowait = true, remap = false },
  { "<leader>dT",  group = "Telescope",                                                   nowait = true,                                       remap = false },
  { "<leader>dTC", "<cmd>lua require('telescope').extensions.dap.configurations{}<cr>",   desc = "List Configurations",                        nowait = true, remap = false },
  { "<leader>dTb", "<cmd>lua require('telescope').extensions.dap.list_breakpoints{}<cr>", desc = "List Breakpoints",                           nowait = true, remap = false },
  { "<leader>dTc", "<cmd>lua require('telescope').extensions.dap.commands{}<cr>",         desc = "List Commands",                              nowait = true, remap = false },
  { "<leader>dTf", "<cmd>lua require('telescope').extensions.dap.frames{}<cr>",           desc = "List Frames",                                nowait = true, remap = false },
  { "<leader>dTv", "<cmd>lua require('telescope').extensions.dap.variables{}<cr>",        desc = "List Variables",                             nowait = true, remap = false },
  { "<leader>db",  "<cmd>lua require'dap'.step_back()<cr>",                               desc = "Step Back",                                  nowait = true, remap = false },
  { "<leader>dc",  "<cmd>lua require'dap'.continue()<cr>",                                desc = "Continue",                                   nowait = true, remap = false },
  { "<leader>dd",  "<cmd>lua require'dap'.disconnect()<cr>",                              desc = "Disconnect",                                 nowait = true, remap = false },
  { "<leader>dg",  "<cmd>lua require'dap'.session()<cr>",                                 desc = "Get Session",                                nowait = true, remap = false },
  { "<leader>di",  "<cmd>lua require'dap'.step_into()<cr>",                               desc = "Step Into",                                  nowait = true, remap = false },
  { "<leader>do",  "<cmd>lua require'dap'.step_over()<cr>",                               desc = "Step Over",                                  nowait = true, remap = false },
  { "<leader>dp",  "<cmd>lua require'dap'.pause().toggle()<cr>",                          desc = "Toggle Pause",                               nowait = true, remap = false },
  { "<leader>dq",  "<cmd>lua require'dap'.close()<cr>",                                   desc = "Quit",                                       nowait = true, remap = false },
  { "<leader>dr",  "<cmd>lua require'dap'.repl.toggle()<cr>",                             desc = "Toggle Repl",                                nowait = true, remap = false },
  { "<leader>ds",  "<cmd>lua require'dap'.continue()<cr>",                                desc = "Start",                                      nowait = true, remap = false },
  { "<leader>dt",  "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                       desc = "Toggle Breakpoint",                          nowait = true, remap = false },
  { "<leader>du",  "<cmd>lua require'dap'.step_out()<cr>",                                desc = "Step Out",                                   nowait = true, remap = false },
  { "<leader>dx",  "<cmd>lua require'dap'.terminate()<cr>",                               desc = "Terminate",                                  nowait = true, remap = false },

  { "<leader>e",   "<cmd>NvimTreeToggle<cr>",                                             desc = "Explorer",                                   nowait = true, remap = false },
  { "<leader>f",   "<cmd>Telescope find_files<cr>",                                       desc = "Find files",                                 nowait = true, remap = false },

  { "<leader>g",   group = "Git",                                                         nowait = true,                                       remap = false },
  { "<leader>gR",  "<cmd>lua require('gitsigns').reset_buffer()<cr>",                     desc = "Reset Buffer",                               nowait = true, remap = false },
  { "<leader>gb",  "<cmd>Telescope git_branches<cr>",                                     desc = "Checkout branch",                            nowait = true, remap = false },
  { "<leader>gc",  "<cmd>Telescope git_commits<cr>",                                      desc = "Checkout commit",                            nowait = true, remap = false },
  { "<leader>gf",  group = "Fugitive",                                                    nowait = true,                                       remap = false },
  { "<leader>gfd", ":Gvdiffsplit!<CR>",                                                   desc = "Diff",                                       nowait = true, remap = false },
  { "<leader>gfh", ":diffget //2 <CR>",                                                   desc = "Get Left Diff",                              nowait = true, remap = false },
  { "<leader>gfl", ":diffget //3 <CR>",                                                   desc = "Get Right Diff",                             nowait = true, remap = false },
  { "<leader>gg",  "<cmd>:Git<CR>",                                                       desc = "Git Status",                                 nowait = true, remap = false },
  { "<leader>gj",  "<cmd>lua require('gitsigns').next_hunk()<cr>",                        desc = "Next Hunk",                                  nowait = true, remap = false },
  { "<leader>gk",  "<cmd>lua require('gitsigns').prev_hunk()<cr>",                        desc = "Prev Hunk",                                  nowait = true, remap = false },
  { "<leader>gl",  "<cmd>lua require('gitsigns').blame_line()<cr>",                       desc = "Blame",                                      nowait = true, remap = false },
  { "<leader>go",  "<cmd>Telescope git_status<cr>",                                       desc = "Open changed file",                          nowait = true, remap = false },
  { "<leader>gp",  "<cmd>lua require('gitsigns').preview_hunk()<cr>",                     desc = "Preview Hunk",                               nowait = true, remap = false },
  { "<leader>gr",  "<cmd>lua require('gitsigns').reset_hunk()<cr>",                       desc = "Reset Hunk",                                 nowait = true, remap = false },
  { "<leader>gs",  "<cmd>lua require('gitsigns').stage_hunk()<cr>",                       desc = "Stage Hunk",                                 nowait = true, remap = false },
  { "<leader>gu",  "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>",                  desc = "Undo Stage Hunk",                            nowait = true, remap = false },

  { "<leader>h",   "<cmd>nohlsearch<CR>",                                                 desc = "No Highlight",                               nowait = true, remap = false },
  { "<leader>k",   "<cmd>Telescope keymaps<cr>",                                          desc = "Keymaps",                                    nowait = true, remap = false },

  { "<leader>l",   group = "LSP",                                                         nowait = true,                                       remap = false },
  { "<leader>lS",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                    desc = "Workspace Symbols",                          nowait = true, remap = false },
  { "<leader>la",  "<cmd>Lspsaga code_action<cr>",                                        desc = "Code Action",                                nowait = true, remap = false },
  { "<leader>ld",  "<cmd>Lspsaga show_buf_diagnostics<cr>",                               desc = "Document Diagnostics",                       nowait = true, remap = false },
  { "<leader>lf",  "<cmd>lua vim.lsp.buf.format { async = true }<cr>",                    desc = "Format",                                     nowait = true, remap = false },
  { "<leader>li",  "<cmd>LspInfo<cr>",                                                    desc = "Info",                                       nowait = true, remap = false },
  { "<leader>lj",  "<cmd>Lspsaga diagnostic_jump_next<cr>",                               desc = "Next Diagnostic",                            nowait = true, remap = false },
  { "<leader>lk",  "<cmd>Lspsaga diagnostic_jump_prev<cr>",                               desc = "Prev Diagnostic",                            nowait = true, remap = false },
  { "<leader>lr",  "<cmd>Lspsaga rename ++project<cr>",                                   desc = "Rename",                                     nowait = true, remap = false },
  { "<leader>ls",  "<cmd>Telescope lsp_document_symbols<cr>",                             desc = "Document Symbols",                           nowait = true, remap = false },
  { "<leader>lw",  "<cmd>Lspsaga show_workspace_diagnostics<cr>",                         desc = "Workspace Diagnostics",                      nowait = true, remap = false },

  { "<leader>p",   "<cmd>\"_dP<cr>",                                                      desc = "Replace without buffer",                     nowait = true, remap = false },
  { "<leader>q",   "<cmd>qa!<CR>",                                                        desc = "Quit",                                       nowait = true, remap = false },

  { "<leader>r",   group = "SearchReplaceSingleBuffer",                                   nowait = true,                                       remap = false },
  { "<leader>rW",  "<cmd>SearchReplaceSingleBufferCWORD<cr>",                             desc = "[W]ORD",                                     nowait = true, remap = false },
  { "<leader>rb",  group = "SearchReplaceMultiBuffer",                                    nowait = true,                                       remap = false },
  { "<leader>rbW", "<cmd>SearchReplaceMultiBufferCWORD<cr>",                              desc = "[W]ORD",                                     nowait = true, remap = false },
  { "<leader>rbe", "<cmd>SearchReplaceMultiBufferCExpr<cr>",                              desc = "[e]xpr",                                     nowait = true, remap = false },
  { "<leader>rbf", "<cmd>SearchReplaceMultiBufferCFile<cr>",                              desc = "[f]ile",                                     nowait = true, remap = false },
  { "<leader>rbo", "<cmd>SearchReplaceMultiBufferOpen<cr>",                               desc = "[o]pen",                                     nowait = true, remap = false },
  { "<leader>rbs", "<cmd>SearchReplaceMultiBufferSelections<cr>",                         desc = "SearchReplaceMultiBuffer [s]election list",  nowait = true, remap = false },
  { "<leader>rbw", "<cmd>SearchReplaceMultiBufferCWord<cr>",                              desc = "[w]ord",                                     nowait = true, remap = false },
  { "<leader>re",  "<cmd>SearchReplaceSingleBufferCExpr<cr>",                             desc = "[e]xpr",                                     nowait = true, remap = false },
  { "<leader>rf",  "<cmd>SearchReplaceSingleBufferCFile<cr>",                             desc = "[f]ile",                                     nowait = true, remap = false },
  { "<leader>ro",  "<cmd>SearchReplaceSingleBufferOpen<cr>",                              desc = "[o]pen",                                     nowait = true, remap = false },
  { "<leader>rs",  "<cmd>SearchReplaceSingleBufferSelections<cr>",                        desc = "SearchReplaceSingleBuffer [s]election list", nowait = true, remap = false },
  { "<leader>rw",  "<cmd>SearchReplaceSingleBufferCWord<cr>",                             desc = "[w]ord",                                     nowait = true, remap = false },

  { "<leader>s",   group = "Search",                                                      nowait = true,                                       remap = false },
  { "<leader>sC",  "<cmd>Telescope commands<cr>",                                         desc = "Commands",                                   nowait = true, remap = false },
  { "<leader>sM",  "<cmd>Telescope man_pages<cr>",                                        desc = "Man Pages",                                  nowait = true, remap = false },
  { "<leader>sR",  "<cmd>Telescope registers<cr>",                                        desc = "Registers",                                  nowait = true, remap = false },
  { "<leader>sb",  "<cmd>Telescope git_branches<cr>",                                     desc = "Checkout branch",                            nowait = true, remap = false },
  { "<leader>sh",  "<cmd>Telescope help_tags<cr>",                                        desc = "Find Help",                                  nowait = true, remap = false },
  { "<leader>sr",  "<cmd>Telescope oldfiles<cr>",                                         desc = "Open Recent File",                           nowait = true, remap = false },
  { "<leader>ss",  "<cmd>Telescope grep_string theme=ivy<cr>",                            desc = "Search Text",                                nowait = true, remap = false },

  { "<leader>t",   group = "Terminal",                                                    nowait = true,                                       remap = false },
  { "<leader>tf",  "<cmd>ToggleTerm direction=float<cr>",                                 desc = "Float",                                      nowait = true, remap = false },
  { "<leader>th",  "<cmd>ToggleTerm size=10 direction=horizontal<cr>",                    desc = "Horizontal",                                 nowait = true, remap = false },
  { "<leader>tp",  "<cmd>lua _PYTHON_TOGGLE()<cr>",                                       desc = "Python",                                     nowait = true, remap = false },
  { "<leader>tt",  "<cmd>lua _HTOP_TOGGLE()<cr>",                                         desc = "Htop",                                       nowait = true, remap = false },
  { "<leader>tu",  "<cmd>lua _NCDU_TOGGLE()<cr>",                                         desc = "NCDU",                                       nowait = true, remap = false },
  { "<leader>tv",  "<cmd>ToggleTerm size=80 direction=vertical<cr>",                      desc = "Vertical",                                   nowait = true, remap = false },

  { "<leader>w",   "<cmd>w!<CR>",                                                         desc = "Save",                                       nowait = true, remap = false },
  { "<leader>wq",  "<cmd>wqa!<CR>",                                                       desc = "Save and quit",                              nowait = true, remap = false },
  { "<leader>x",   "<cmd>bdelete!<CR>",                                                   desc = "Close Buffer",                               nowait = true, remap = false },
}

which_key.setup(setup)
which_key.add(mappings)
