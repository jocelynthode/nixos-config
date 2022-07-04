{ config, pkgs, ... }: {
  home = {
    sessionVariables.EDITOR = "nvim";
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = false;
    withNodeJs = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      # Mulst always be at the top
      { plugin = impatient-nvim; config = (builtins.readFile ./plugins/impatient.lua) + (builtins.readFile ./core/mappings.lua) + (builtins.readFile ./core/options.lua) + (builtins.readFile ./core/autocmds.lua); type = "lua"; }

      popup-nvim
      plenary-nvim
      nvim-web-devicons
      vim-bbye
      lualine-lsp-progress
      FixCursorHold-nvim
      nvim-base16
      better-escape-nvim
      nvim-ts-context-commentstring
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      vim-fugitive
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
      luasnip
      friendly-snippets
      null-ls-nvim
      SchemaStore-nvim
      taxi-vim
      { plugin = nvim-lspconfig; config = builtins.readFile ./plugins/lsp.lua; type = "lua"; }
      { plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars)); config = builtins.readFile ./plugins/treesitter.lua; type = "lua"; }
      { plugin = gitsigns-nvim; config = builtins.readFile ./plugins/gitsigns.lua; type = "lua"; }
      { plugin = telescope-nvim; config = builtins.readFile ./plugins/telescope.lua; type = "lua"; }
      { plugin = dressing-nvim; config = builtins.readFile ./plugins/dressing.lua; type = "lua"; }
      { plugin = nvim-colorizer-lua; config = "require('colorizer').setup()\n"; type = "lua"; }
      { plugin = nvim-lastplace; config = "require('nvim-lastplace').setup()\n"; type = "lua"; }
      { plugin = nvim-autopairs; config = builtins.readFile ./plugins/autopairs.lua; type = "lua"; }
      { plugin = comment-nvim; config = builtins.readFile ./plugins/comment.lua; type = "lua"; }
      { plugin = indent-blankline-nvim; config = builtins.readFile ./plugins/indentline.lua; type = "lua"; }
      { plugin = surround-nvim; config = builtins.readFile ./plugins/surround.lua; type = "lua"; }
      { plugin = nvim-tree-lua; config = builtins.readFile ./plugins/nvimtree.lua; type = "lua"; }
      { plugin = bufferline-nvim; config = builtins.readFile ./plugins/bufferline.lua; type = "lua"; }
      { plugin = lualine-nvim; config = builtins.readFile ./plugins/lualine.lua; type = "lua"; }
      { plugin = toggleterm-nvim; config = builtins.readFile ./plugins/toggleterm.lua; type = "lua"; }
      { plugin = alpha-nvim; config = builtins.readFile ./plugins/alpha.lua; type = "lua"; }
      { plugin = which-key-nvim; config = builtins.readFile ./plugins/whichkey.lua; type = "lua"; }
      { plugin = nvim-cmp; config = builtins.readFile ./plugins/cmp.lua; type = "lua"; }

    ];
    extraPackages = with pkgs; [
      gcc
      fzf
      gopls
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.vim-language-server
      nodePackages.dockerfile-language-server-nodejs
      pyright
      rnix-lsp
      rust-analyzer
      shellcheck
      sumneko-lua-language-server
      terraform-ls
      terraform

      # null-ls
      nodePackages.prettier
      gitlint
      shfmt
    ];
    # We must require plugin before colorscheme
    extraConfig = ''
      lua require('base16-colorscheme').with_config {telescope = false}

      colorscheme base16-${config.colorScheme.slug}
      hi Normal ctermbg=NONE guibg=NONE
    '';
  };
  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [ "Utility" "TextEditor" ];
    };
  };
}
