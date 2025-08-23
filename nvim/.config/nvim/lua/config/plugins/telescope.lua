return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"^.git/",
						"^node_modules/",
						"^target/",
						"^build/",
						"^venv/",
						"%.o$",
						"%.pdf$",
						"%.jpg$",
						"%.png$",
					},
					hidden = true,
				},
			})
			local builtin = require("telescope.builtin")

			------------------- REMAP --------------------------
			vim.keymap.set("n", "<leader>d", "<cmd>Telecope diagnostics<CR>", { desc = "Show diagnostics (Telescope)" })
			vim.keymap.set("n", "<leader>df", function()
				vim.diagnostic.open_float()
				vim.diagnostic.open_float()
			end, { desc = "Show diagnostic float" })

			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find git files" })
			vim.keymap.set("n", "<leader>ps", function()
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
				})
			end)
		end,
	},
}
