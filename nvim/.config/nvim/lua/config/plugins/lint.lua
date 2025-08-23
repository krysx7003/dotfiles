return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "ruff" },
			markdown = {
				"markdownlint-cli2",
			},
		}
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.py", "*.md" },
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
