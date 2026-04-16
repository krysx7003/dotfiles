local colors = {
	white = "#c5c8c6", --
	gray = "#282a2e", --
	yellow = "#f0c674", --
	darkyellow = "#ebb244", --
}

return {
	normal = {
		a = { bg = colors.darkyellow, fg = colors.gray, gui = "bold" },
		b = { bg = colors.yellow, fg = colors.gray, gui = "bold" },
		c = { bg = colors.gray, fg = colors.white },
	},
	insert = {
		a = { bg = colors.darkyellow, fg = colors.gray, gui = "bold" },
		b = { bg = colors.yellow, fg = colors.gray, gui = "bold" },
		c = { bg = colors.gray, fg = colors.white },
	},
	visual = {
		a = { bg = colors.darkyellow, fg = colors.gray, gui = "bold" },
		b = { bg = colors.yellow, fg = colors.gray, gui = "bold" },
		c = { bg = colors.gray, fg = colors.white },
	},
	replace = {
		a = { bg = colors.darkyellow, fg = colors.gray, gui = "bold" },
		b = { bg = colors.yellow, fg = colors.gray, gui = "bold" },
		c = { bg = colors.gray, fg = colors.white },
	},
	command = {
		a = { bg = colors.darkyellow, fg = colors.gray, gui = "bold" },
		b = { bg = colors.yellow, fg = colors.gray, gui = "bold" },
		c = { bg = colors.gray, fg = colors.white },
	},
	inactive = {
		a = { bg = colors.gray, fg = colors.white },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
}
