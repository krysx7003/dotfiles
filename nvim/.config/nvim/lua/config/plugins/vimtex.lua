return {
	{
		"lervag/vimtex",
		init = function()
			vim.g.vimtex_view_method = "zathura"

			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
				options = {
					"-pdf",
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

			vim.keymap.set("n", "<leader>ti", function()
				vim.cmd("VimtexTocOpen")
			end, {})
			vim.keymap.set("n", "<leader>tc", function()
				vim.cmd("VimtexCompile")
			end, {})
			vim.keymap.set("n", "<leader>tv", function()
				vim.cmd("VimtexView")
			end, {})
			vim.keymap.set("n", "<leader>ts", function()
				vim.cmd("VimtexStop")
			end, {})
			vim.keymap.set("n", "<leader>tr", function()
				vim.cmd("VimtexClean")
			end, {})
			vim.keymap.set("n", "<leader>tR", function()
				vim.cmd("VimtexClean!")
			end, {})
		end,
	},
}
