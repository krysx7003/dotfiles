return {
	"nvim-lualine/lualine.nvim",
	ependencies = { "krysx7003/chronos.nvim" },
	config = function()
		require("chronos").setup()

		require("lualine").setup({
			options = {
				theme = "auto",
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
