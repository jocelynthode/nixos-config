local _, nvim_tree = pcall(require, "nvim-tree")

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

-- globals must be set prior to requiring nvim-tree to function
local g = vim.g


local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
  filters = {
    dotfiles = false,
    custom = {
      ".git$",
      "target$",
      "node_modules$",
      ".cache$",
      "Cargo.lock$",
      ".terraform$",
    },
  },
  disable_netrw = false,
  hijack_netrw = true,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
    "taxi",
  },
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
    hide_root_folder = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
        { key = "v", cb = tree_cb("vsplit") },
      },
    },
  },
  git = {
    enable = true,
    ignore = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  open_on_setup = true,
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  renderer = {
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
