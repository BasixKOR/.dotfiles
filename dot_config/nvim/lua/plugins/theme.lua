return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = os.getenv 'TERM' == 'xterm-ghostty',
      integrations = {
        mason = true,
        copilot_vim = true,
        notify = true,
        snacks = true,
        lsp_trouble = true,
        which_key = true,
      },
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
