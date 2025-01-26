return {
  {
    'zbirenbaum/copilot.lua',
    event = 'BufWritePre',
    cmd = 'Copilot',
    build = ':Copilot auth',
    opts = {
      suggestion = { enabled = false },
    },
  }, -- Provides Copilot connection and authentication
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- optional:
      'MeanderingProgrammer/render-markdown.nvim',
    },
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat', 'CodeCompanionCmd' },
    opts = {
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
    },
  },
}
