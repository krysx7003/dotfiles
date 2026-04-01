return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "krysx7003/chronos.nvim" },
	config = function()
		require("chronos").setup()
		local custom_gruvbox = require("lualine.themes.gruvbox")
		custom_gruvbox.normal = {
			c = {
				bg = "#282a2e",
				fg = "#c5c8c6",
			},
			b = {
				bg = "#f0c674",
				fg = "#282a2e",
				gui = "bold",
			},
			a = {
				bg = "#ebb244",
				fg = "#282a2e",
				gui = "bold",
			},
		}

		custom_gruvbox.visual = {
			c = {
				bg = "#282a2e",
				fg = "#c5c8c6",
			},
			b = {
				bg = "#f0c674",
				fg = "#282a2e",
				gui = "bold",
			},
			a = {
				bg = "#ebb244",
				fg = "#282a2e",
				gui = "bold",
			},
		}

		custom_gruvbox.insert = {
			c = {
				bg = "#282a2e",
				fg = "#c5c8c6",
			},
			b = {
				bg = "#f0c674",
				fg = "#282a2e",
				gui = "bold",
			},
			a = {
				bg = "#ebb244",
				fg = "#282a2e",
				gui = "bold",
			},
		}

		custom_gruvbox.command = {
			c = {
				bg = "#282a2e",
				fg = "#c5c8c6",
			},
			b = {
				bg = "#f0c674",
				fg = "#282a2e",
				gui = "bold",
			},
			a = {
				bg = "#ebb244",
				fg = "#282a2e",
				gui = "bold",
			},
		}

		require("lualine").setup({
			options = {
				theme = custom_gruvbox,
				-- theme = "auto",
				icons_enabled = true,
			},
			sections = {
				lualine_x = {
					function()
						return "Time: " .. require("chronos").current_time
					end,
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
