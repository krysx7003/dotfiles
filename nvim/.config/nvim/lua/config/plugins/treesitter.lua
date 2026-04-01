return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- "nvim-treesitter/playground",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ignore_install = {},

				ensure_installed = { "python", "lua", "sql", "go", "latex", "kotlin" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
			})
		end,
	},
}
