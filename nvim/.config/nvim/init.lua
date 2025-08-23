require("config.lazy")
require("config.remap")
require("config.cpp")
require("config.kotlin")
require("config.python")

local cwd = vim.fn.getcwd()
local nvim_dir = cwd .. "/.nvim"
local result = vim.api.nvim_exec2("args", { output = true })

if vim.fn.isdirectory(nvim_dir) == 0 then
	vim.fn.system({ "cp", vim.fn.expand("~/.config/nvim/.nvim/.gitignore"), cwd })
	vim.fn.system({ "mkdir", ".nvim" })
end

vim.opt.tabstop = 4

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff" })

vim.opt.signcolumn = "yes"

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.start(bufnr, client.id)
		end
	end,
})
