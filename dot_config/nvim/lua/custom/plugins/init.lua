return {
  { 'lbrayner/vim-rzip', lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  { 'soulis-1256/eagle.nvim', config = true },
  {
    -- For some reason the last release is in 2019, change this to use version when releases.
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  {
    'mg979/vim-visual-multi',
    init = function()
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_maps = {
        ['Select Cursor Down'] = '<M-C-Down>',
        ['Select Cursor Up'] = '<M-C-Up>',
      }
    end,
  },
  {
    'simnalamburt/vim-tiny-ime',
    cond = vim.fn.has 'macunix',
    build = './build',
  },
  {
    'bkad/CamelCaseMotion',
    event = 'VeryLazy',
    config = function()
      vim.g.camelcasemotion_key = '\\'
    end,
  },
  {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {},
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
    -- Optional dependencies
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = true,
  },
  {
    'dmmulroy/tsc.nvim',
    event = 'VeryLazy',
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      local lspconfig = require 'lspconfig'
      local util = lspconfig.util

      local root_path = util.find_git_ancestor(vim.fn.getcwd())
      local is_yarn_pnp = util.path.is_file(util.path.join(root_path, '.pnp.cjs'))

      local tsc_path = is_yarn_pnp and util.path.join(root_path, '.yarn/sdks/typescript/bin/tsc') or nil

      require('tsc').setup {
        bin_path = tsc_path,
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    'xvzc/chezmoi.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'nvim-neorg/neorg',
    version = 'v8.8.1',
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
            default_workspace = 'notes',
          },
        },
      },
    },
  },
  { 'akinsho/git-conflict.nvim', version = '*', config = true },
  {
    'doctorfree/cheatsheet.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local ctactions = require 'cheatsheet.telescope.actions'
      require('cheatsheet').setup {
        bundled_cheetsheets = {
          enabled = { 'default', 'lua', 'markdown', 'regex', 'netrw', 'unicode' },
          disabled = { 'nerd-fonts' },
        },
        bundled_plugin_cheatsheets = {
          enabled = {
            'auto-session',
            'goto-preview',
            'octo.nvim',
            'telescope.nvim',
            'vim-easy-align',
            'vim-sandwich',
          },
          disabled = { 'gitsigns' },
        },
        include_only_installed_plugins = true,
        telescope_mappings = {
          ['<CR>'] = ctactions.select_or_fill_commandline,
          ['<A-CR>'] = ctactions.select_or_execute,
          ['<C-Y>'] = ctactions.copy_cheat_value,
          ['<C-E>'] = ctactions.edit_user_cheatsheet,
        },
      }
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    keys = {
      { '<F4>', '<cmd>Spectre<cr>', mode = { 'n' } },
    },
    cmd = { 'Spectre' },
    cond = vim.fn.executable('cargo') == 1,
    build = './build.sh',
    config = {
      is_block_ui_break = true,
      default = {
        replace = {
          cmd = 'oxi',
        },
      },
    },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = {},
  }, -- Lua
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    keys = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  },
}
