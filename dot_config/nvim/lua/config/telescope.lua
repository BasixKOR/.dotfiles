return {
  {
    'nvim-telescope/telescope-z.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = {
      { '<leader>sz', require('telescope').extensions.z.z, desc = "[S]earch by rupa/[z]" },
    },
    config = function()
      require('telescope').load_extension 'z'
    end,
  },
}
