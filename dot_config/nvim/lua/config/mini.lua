return {
	'echasnovski/mini.nvim',
	version = '*',
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
	end,
	dependencies = {
		'JoosepAlviste/nvim-ts-context-commentstring'
	}
}
