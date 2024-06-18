return {
  {
    'nvim-telescope/telescope-z.nvim',
    keys = {
      { '<leader>sz', require('telescope').extensions.z.z, desc = "[S]earch by rupa/[z]" },
    },
    lazy = false,
  },
}
