return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
					disable = {},
				},
				ensure_installed = { "python", "lua", "sql", "latex", "kotlin" },
				auto_install = true,
				sync_install = true,
				semantic_tokens = true,
			})
		end,
	},
	"nvim-treesitter/playground",
}
