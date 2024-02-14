return {
  { 'lbrayner/vim-rzip',      lazy = true },
  { 'zbirenbaum/copilot.lua', config = true },
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    cmd = 'ToggleTerm',
    version = "*",
    config = true
  },
  { 'nvim-tree/nvim-tree.lua', config = true },
  require 'config.none-ls',
  { 'echasnovski/mini.nvim',   version = '*' },
  { 'soulis-1256/eagle.nvim' },
  {
    -- For some reason the last release is in 2019, change this to use version when releases.
    'undotree/doc',
    lazy = true,
    cmd = 'UndotreeToggle',
  }
}
