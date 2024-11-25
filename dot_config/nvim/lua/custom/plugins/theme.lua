return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = os.getenv 'TERM' == 'xterm-ghostty',
    },
  }
}
