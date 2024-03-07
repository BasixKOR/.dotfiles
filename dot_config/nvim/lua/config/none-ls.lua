return {
	'nvimtools/none-ls.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local lspconfig = require 'lspconfig'
		local util = lspconfig.util

		local null_ls = require 'null-ls'
		local command_resolver = require 'null-ls.helpers.command_resolver'

		local root_path = util.find_git_ancestor(vim.fn.getcwd())

		local is_yarn_pnp = util.path.is_file(util.path.join(root_path, '.pnp.cjs'))
		local is_biome = util.path.is_file(util.path.join(root_path, 'biome.json'))

		-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#ruff-1
		null_ls.setup {
			debug = true,
			sources = {
				null_ls.builtins.formatting.prettierd.with {
					dynamic_command = command_resolver.from_yarn_pnp(),
					condition = function()
						return not is_biome and is_yarn_pnp
					end,
				},

				null_ls.builtins.formatting.prettierd.with {
					condition = function()
						return not is_biome and not is_yarn_pnp
					end,
				},

				null_ls.builtins.formatting.biome.with {
					condition = function()
						return is_biome
					end,
				},
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.ruff_format,
			},
		}
	end,
}
