vim.g.mapleader = " "

local function toggle_relative_numbers()
	vim.wo.relativenumber = not vim.wo.relativenumber
end

vim.keymap.set("n", "<leader>rn", toggle_relative_numbers, { desc = "Toggle relative numbers" })

vim.keymap.set("n", "<C-K>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-J>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-H>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-L>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>m", function()
	local buf = vim.api.nvim_create_buf(false, true)

	local result = vim.api.nvim_exec2("messages", { output = true })
	local output_str = result.output or ""

	local msg_lines = {}
	for line in output_str:gmatch("[^\r\n]+") do
		table.insert(msg_lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, msg_lines)

	vim.api.nvim_command("belowright split")
	vim.api.nvim_win_set_buf(0, buf)
end)
