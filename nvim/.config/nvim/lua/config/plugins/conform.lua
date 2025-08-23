local cwd = vim.fn.getcwd()

return {
	{
		"stevearc/conform.nvim",

		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				local disable_filetypes = {}
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				h = { "clang_format" },
				python = {
					"ruff_fix",
					"ruff_format",
					"ruff_organize_imports",
				},
			},
		},
		formatters = {
			clang_format = {
				prepend_args = { "-style=file" },
			},
		},
	},
}
