return {
  { 'lbrayner/vim-rzip',      lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  require 'config.toggleterm',
  { 'nvim-tree/nvim-tree.lua', config = true },
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
  }
}
