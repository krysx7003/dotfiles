local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Hey! Put lazy into the runtimepath for neovim!
vim.opt.runtimepath:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
require("lazy").setup({
	spec = {
		{
			"ellisonleao/gruvbox.nvim",
			-- "EdenEast/nightfox.nvim",
			config = function()
				vim.o.termguicolors = true
				require("gruvbox").setup({
					overrides = {
						Normal = { bg = "#282a2e" },
						SignColumn = { bg = "#282a2e" },
						LineNr = { fg = "#c5c8c6", bold = true },
						CurSearch = { bg = "#373b41", fg = "#ebb244" },
						ErrorMsg = { bg = "#282a2e", fg = "#fb4934" },
						-- IncSearch
						Search = { bg = "#373b41", fg = "#f0c674" },
						Substitute = { bg = "#ebb244", fg = "#373b41" },
						NormalFloat = { bg = "#373b41", fg = "#c5c8c6" },
						Pmenu = { bg = "#373b41", fg = "#c5c8c6" },
						PmenuSel = { bg = "#f0c674", fg = "#373b41" },
						PmenuSbar = { bg = "#373b41" },
						PmenuThumb = { bg = "#c5c8c6" },
					},
				})
				vim.cmd.colorscheme("gruvbox")
			end,
		},
		{ "nvim-tree/nvim-web-devicons", opt = {} },
		{ import = "config.plugins" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
})
