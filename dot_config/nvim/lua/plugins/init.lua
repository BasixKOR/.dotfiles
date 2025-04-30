return {
  {
    'rcarriga/nvim-notify',
    init = function()
      vim.notify = require 'notify'
    end,
  },
  { 'lbrayner/vim-rzip', lazy = true },
  { 'soulis-1256/eagle.nvim', config = true },
  {
    -- For some reason the last release is in 2019, change this to use version when releases.
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  {
    'simnalamburt/vim-tiny-ime',
    cond = vim.fn.has 'macunix',
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
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      -- Disable use as operator as it conflicts with surround keymap
      { "s",     mode = { "n", "x" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o" },      function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    'xvzc/chezmoi.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    opts = {},
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { os.getenv 'HOME' .. '/.local/share/chezmoi/*' },
        callback = function(ev)
          local bufnr = ev.buf
          vim.schedule(function()
            require('chezmoi.commands.__edit').watch(bufnr)
          end)
        end,
      })
      require('chezmoi').setup(opts)
      require('telescope').load_extension 'chezmoi'
    end,
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
    cond = vim.fn.executable 'cargo' == 1,
    build = './build.sh',
    opts = {
      is_block_ui_break = true,
      default = {
        replace = {
          cmd = 'oxi',
        },
      },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    config = function()
      vim.keymap.set('n', '<leader>qs', function()
        require('persistence').load()
      end)
      vim.keymap.set('n', '<leader>qS', function()
        require('persistence').select()
      end)
      vim.keymap.set('n', '<leader>ql', function()
        require('persistence').load { last = true }
      end)
      vim.keymap.set('n', '<leader>qd', function()
        require('persistence').stop()
      end)
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    ft = { 'markdown', 'codecompanion' }, -- see ai.lua
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  },
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    opts = {
      exclude_filetypes = { 'oil', 'toggleterm', 'minifiles', 'snacks_terminal' },
      theme = 'catppuccin',
    },
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  {
    'gbprod/yanky.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    config = function()
      require('telescope').load_extension 'yank_history'
    end,
  },
}
