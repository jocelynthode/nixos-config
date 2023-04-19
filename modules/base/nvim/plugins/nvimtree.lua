local _, nvim_tree = pcall(require, "nvim-tree")

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

-- globals must be set prior to requiring nvim-tree to function
local g = vim.g


local tree_cb = nvim_tree_config.nvim_tree_callback

local function open_nvim_tree(data)
  local IGNORED_FT = {
    "startify",
    "dashboard",
    "alpha",
    "taxi",
  }
  local filetype = vim.bo[data.buf].ft

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- skip ignored filetypes
  if vim.tbl_contains(IGNORED_FT, filetype) then
    return
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

nvim_tree.setup({
  filters = {
    dotfiles = false,
    custom = {
      "\\.git$",
      "^target$",
      "^node_modules$",
      "^\\.cache$",
      "^Cargo.lock$",
      "^flake.lock$",
      "^\\.terraform$",
      "^\\.direnv$",
    },
  },
  disable_netrw = false,
  hijack_netrw = true,
  open_on_tab = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
  view = {
    side = "left",
    width = 30,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
        { key = "h",                  cb = tree_cb("close_node") },
        { key = "v",                  cb = tree_cb("vsplit") },
      },
    },
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    highlight_opened_files = "icons",
    add_trailing = false,
    indent_markers = {
      enable = false,
    },
    icons = {
      webdev_colors = true,
      show = {
        folder = true,
        file = true,
        git = true,
        folder_arrow = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          deleted = "",
          ignored = "◌",
          renamed = "➜",
          staged = "✓",
          unmerged = "",
          unstaged = "✗",
          untracked = "★",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
      },
    },
  },
})
