local _, which_key = pcall(require, "which-key")

local setup = {
  plugins = {
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 5, -- how many suggestions should be shown in the list?
    },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["b"] = {
    "<cmd>Telescope buffers<cr>",
    "Buffers",
  },
  d = {
    name = "Debug",
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    p = { "<cmd>lua require'dap'.pause().toggle()<cr>", "Toggle Pause" },
    P = {
      name = "Python",
      m = { "<cmd>lua require('dap-python').test_method()<cr>", "Debug Method" },
      c = { "<cmd>lua require('dap-python').test_class()<cr>", "Debug Class" },
      s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
    },
    G = {
      name = "Go",
      t = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" },
      l = { "<cmd>lua require('dap-go').debug_last_test()<cr>", "Debug Last Test" },
    },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    T = {
      name = "Telescope",
      c = { "<cmd>lua require('telescope').extensions.dap.commands{}<cr>", "List Commands" },
      C = { "<cmd>lua require('telescope').extensions.dap.configurations{}<cr>", "List Configurations" },
      b = { "<cmd>lua require('telescope').extensions.dap.list_breakpoints{}<cr>", "List Breakpoints" },
      v = { "<cmd>lua require('telescope').extensions.dap.variables{}<cr>", "List Variables" },
      f = { "<cmd>lua require('telescope').extensions.dap.frames{}<cr>", "List Frames" },
    },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
  },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>qa!<CR>", "Quit" },
  ["x"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
  ["f"] = {
    "<cmd>Telescope find_files<cr>",
    "Find files",
  },
  ["k"] = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  ["F"] = { "<cmd>Telescope live_grep_args<cr>", "Find Text" },
  ["p"] = { "<cmd>lua require('notify').dismiss()<cr>", "Dismiss notifications" },
  g = {
    name = "Git",
    g = { "<cmd>:Git<CR>", "Git Status" },
    j = { "<cmd>lua require('gitsigns').next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require('gitsigns').prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require('gitsigns').blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require('gitsigns').stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    f = {
      name = "Fugitive",
      d = { ":Gvdiffsplit!<CR>", "Diff" },
      h = { ":diffget //2 <CR>", "Get Left Diff" },
      l = { ":diffget //3 <CR>", "Get Right Diff" },
    },
  },

  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = {
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      "Document Diagnostics",
    },
    w = {
      "<cmd>Telescope diagnostics<cr>",
      "Workspace Diagnostics",
    },
    f = { "<cmd>lua vim.lsp.buf.format { async = true }<cr>", "Format" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    j = {
      "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
  },
  r = {
    name = "SearchReplaceSingleBuffer",
    s = { "<cmd>SearchReplaceSingleBufferSelections<cr>", "SearchReplaceSingleBuffer [s]election list" },
    o = { "<cmd>SearchReplaceSingleBufferOpen<cr>", "[o]pen" },
    w = { "<cmd>SearchReplaceSingleBufferCWord<cr>", "[w]ord" },
    W = { "<cmd>SearchReplaceSingleBufferCWORD<cr>", "[W]ORD" },
    e = { "<cmd>SearchReplaceSingleBufferCExpr<cr>", "[e]xpr" },
    f = { "<cmd>SearchReplaceSingleBufferCFile<cr>", "[f]ile" },
    b = {
      name = "SearchReplaceMultiBuffer",
      s = { "<cmd>SearchReplaceMultiBufferSelections<cr>","SearchReplaceMultiBuffer [s]election list" },
      o = { "<cmd>SearchReplaceMultiBufferOpen<cr>", "[o]pen" },
      w = { "<cmd>SearchReplaceMultiBufferCWord<cr>", "[w]ord" },
      W = { "<cmd>SearchReplaceMultiBufferCWORD<cr>", "[W]ORD" },
      e = { "<cmd>SearchReplaceMultiBufferCExpr<cr>", "[e]xpr" },
      f = { "<cmd>SearchReplaceMultiBufferCFile<cr>", "[f]ile" },
    },
  },
  s = {
    name = "Search",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    s = { "<cmd>Telescope grep_string theme=ivy<cr>", "Search Text" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
  },

  t = {
    name = "Terminal",
    u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },
}

which_key.setup(setup)
which_key.register(mappings, opts)
