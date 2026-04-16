return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "krysx7003/chronos.nvim" },
	config = function()
		require("chronos").setup()
		local nappingfox = require("config.plugins.nappingfox.lualine_theme")

		require("lualine").setup({
			options = {
				theme = nappingfox,
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
