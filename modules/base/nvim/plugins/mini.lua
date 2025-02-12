require('mini.extra').setup()
local starter = require('mini.starter')
starter.setup({
  evaluate_single = true,
  header = [[
                                   __
      ___     ___    ___   __  __ /\_\    ___ ___
     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
  ]],
  items = {
    starter.sections.telescope(),
    starter.sections.builtin_actions(),
  },
})
require('mini.bufremove').setup()
local indentscope = require('mini.indentscope')
indentscope.setup({
  symbol = '▎',
  draw = {
    animation = indentscope.gen_animation.none(),
  },
})
require('mini.cursorword').setup()
require('mini.diff').setup()
require('mini.trailspace').setup()
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.ai').setup()
require('mini.move').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Move visual selection in Visual mode.
    left = '<A-Left>',
    right = '<A-Right>',
    down = '<A-Down>',
    up = '<A-Up>',

    -- Move current line in Normal mode
    line_left = '<A-Left>',
    line_right = '<A-Right>',
    line_down = '<A-Down>',
    line_up = '<A-Up>',
  },

  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})


local f = function(args)
  vim.b[args.buf].miniindentscope_disable = true
  vim.b[args.buf].minicursorword_disable = true
end
vim.api.nvim_create_autocmd('Filetype',
  { pattern = { 'NvimTree', }, callback = f, desc = 'Disable indentscope in NvimTree' })
