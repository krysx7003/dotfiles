return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("lspconfig").lua_ls.setup({
				filetypes = { "lua" },
			})
			require("config.plugins.lsp.python")
			require("lspconfig").clangd.setup({
				filetypes = { "cpp" },
			})

			require("lspconfig").kotlin_lsp.setup({
				filetypes = { "kotlin", "kt", "kts" },
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				pvletypes = {},
				underline = true,
				severity_sort = true,
			})

			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = {
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
			})
			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				},
			})
		end,
	},
}
