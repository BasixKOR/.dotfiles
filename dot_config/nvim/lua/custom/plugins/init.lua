return {
  { 'lbrayner/vim-rzip', lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  require 'config.toggleterm',
  require 'config.none-ls',
  require 'config.mini',
  { 'soulis-1256/eagle.nvim', config = true },
  {
    -- For some reason the last release is in 2019, change this to use version when releases.
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  { 'mg979/vim-visual-multi' },
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
    'lewis6991/gitsigns.nvim',
    opts = {},
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
    'rmagatti/auto-session',
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/work", "~/Downloads", "/", "/tmp"}
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {}
  }
}
