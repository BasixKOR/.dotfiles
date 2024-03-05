return {
  { 'lbrayner/vim-rzip',      lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  require 'config.toggleterm',
  require 'config.none-ls',
  { 'echasnovski/mini.nvim',   version = '*' },
  { 'soulis-1256/eagle.nvim',  config = true },
  {
    -- For some reason the last release is in 2019, change this to use version when releases.
    'mbbill/undotree',
    lazy = true,
    cmd = 'UndotreeToggle',
  },
  { 'mg979/vim-visual-multi' },
  {
    'simnalamburt/vim-tiny-ime',
    cond = vim.fn.has('macunix'),
    build = './build'
  },
  {
    'bkad/CamelCaseMotion',
    event = 'VeryLazy',
    config = function ()
      vim.g.camelcasemotion_key = '\\'
    end
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  }
}
