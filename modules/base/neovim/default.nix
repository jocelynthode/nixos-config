{ pkgs, ... }:
{
  imports = [
    ./core
    ./plugins
    ./themes
  ];

  config = {
    aspects.base.persistence.homePaths = [
      ".cache/nvim"
      ".local/state/nvim"
    ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      opts = {
        backup = false;
        clipboard = "unnamedplus";
        cmdheight = 2;
        completeopt = [
          "menuone"
          "noselect"
        ];
        conceallevel = 0;
        fileencoding = "utf-8";
        foldenable = false;
        hlsearch = true;
        ignorecase = true;
        mouse = "a";
        pumheight = 10;
        showmode = false;
        showtabline = 2;
        smartcase = true;
        smartindent = true;
        splitbelow = true;
        splitright = true;
        swapfile = false;
        termguicolors = true;
        background = "dark";
        timeoutlen = 250;
        undofile = true;
        updatetime = 300;
        writebackup = false;
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        cursorline = true;
        number = true;
        relativenumber = true;
        numberwidth = 3;
        signcolumn = "yes";
        wrap = false;
        scrolloff = 8;
        sidescrolloff = 8;
        guifont = "JetBrainsMono NFM:h11";
        laststatus = 3;
        inccommand = "split";
        synmaxcol = 250;
      };

      plugins = {
        web-devicons.enable = true;
        better-escape.enable = true;
        lazygit.enable = true;
        luasnip.enable = true;
        friendly-snippets.enable = true;
        notify.enable = true;
        nui.enable = true;
        helm.enable = true;
        crates.enable = true;
        rustaceanvim.enable = true;
        rainbow-delimiters.enable = true;
        lastplace.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        telescope-dap-nvim
        taxi-vim
        kitty-scrollback-nvim
      ];

      extraPackages = with pkgs; [
        nixfmt-rfc-style
      ];

      extraConfigLua = ''
        vim.opt.whichwrap:append("<>[]hl")
        vim.opt.iskeyword:append("-")

        require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
        require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
        require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close

        require("kitty-scrollback").setup()
      '';

      # use python3_host_prog as python path to use here
      extraPython3Packages =
        ps: with ps; [
          debugpy
          setuptools
        ];
    };
  };
}
