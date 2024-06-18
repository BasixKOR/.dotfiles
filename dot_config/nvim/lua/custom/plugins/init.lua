return {
  { 'lbrayner/vim-rzip', lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  require 'config.toggleterm',
  require 'config.none-ls',
  require 'config.mini',
  require 'config.telescope',
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
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
}
