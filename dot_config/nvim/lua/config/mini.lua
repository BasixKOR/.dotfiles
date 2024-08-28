return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.ai').setup()

    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }

    require('mini.animate').setup {
      cursor = { enable = false },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },
    }

    require('mini.splitjoin').setup {
      mappings = {
        toggle = 'gs',
      },
    }

    require('mini.operators').setup()

    require('mini.files').setup()
    vim.keymap.set('n', '<leader>-', MiniFiles.open)

    require('mini.animate').setup()

    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
  end,
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
}
