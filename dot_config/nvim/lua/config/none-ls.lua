return {
	'nvimtools/none-ls.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local null_ls = require("null-ls")

		-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#ruff-1
		null_ls.setup({
			sources = {
				null_ls.builtins.diagnostics.eslint,
				null_ls.builtins.code_actions.shellcheck,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.ruff_format,
				null_ls.builtins.formatting.biome,
			},
		})
	end
}
