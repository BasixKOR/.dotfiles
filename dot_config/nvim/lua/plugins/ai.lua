return {
  'github/copilot.vim', -- Provides Copilot connection and authentication
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- optional:
      'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
    },
  },
}
