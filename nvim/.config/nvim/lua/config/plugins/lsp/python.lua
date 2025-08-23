local lspconfig = require("lspconfig")

lspconfig.basedpyright.setup({
	filetypes = { "python" },
	on_attach = function(client, bufnr)
		client.server_capabilities.semanticTokensProvider = {
			full = true,
			legend = {
				tokenTypes = {
					"namespace",
					"type",
					"class",
					"enum",
					"interface",
					"struct",
					"typeParameter",
					"parameter",
					"variable",
					"property",
					"enumMember",
					"event",
					"function",
					"method",
					"macro",
					"keyword",
					"modifier",
					"comment",
					"string",
					"number",
					"regexp",
					"operator",
					"decorator",
				},
				tokenModifiers = {
					"declaration",
					"definition",
					"readonly",
					"static",
					"abstract",
					"async",
					"modification",
					"documentation",
					"defaultLibrary",
				},
			},
			range = true,
		}
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.semantic_tokens.force_refresh()
			end,
		})
	end,
})

lspconfig.ruff.setup({
	filetypes = { "python" },
})
