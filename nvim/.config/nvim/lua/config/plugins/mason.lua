return {
	"mason-org/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				-- Lua
				"lua-language-server",
				"stylua",
				-- Python
				"debugpy",
				"basedpyright",
				"ruff",
				-- C/C++
				"codelldb",
				"clangd",
				"clang-format",
				-- QML
				"qmlls",
				-- Markdown
				"markdownlint-cli2",
				-- Go
				"gofumpt",
				"goimports",
				"gopls",
				"delve",
				-- Ts/Js
				"biome",
				"vtsls",
			},
		})
	end,
}
