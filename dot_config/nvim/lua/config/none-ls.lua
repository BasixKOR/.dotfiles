return {
	'nvimtools/none-ls.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local null_ls = require("null-ls")
		local resolvers = require("null-ls.helpers.command_resolver")

		-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#ruff-1
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.prettier.with({
					dynamic_command = resolvers.from_yarn_pnp()
				}),
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.ruff_format,
				null_ls.builtins.formatting.biome,
			},
		})
	end
}
