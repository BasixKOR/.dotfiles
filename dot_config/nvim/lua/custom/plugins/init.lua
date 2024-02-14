return {
  { 'lbrayner/vim-rzip',       lazy = true },
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = true
  },
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    cmd = 'ToggleTerm',
    version = "*",
    config = true
  },
  { 'nvim-tree/nvim-tree.lua', config = true },
  require 'config.none-ls',
  { 'echasnovski/mini.nvim', version = '*' },
  { 'soulis-1256/eagle.nvim' }
}
