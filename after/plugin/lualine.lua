local nvim_navic = require("nvim-navic")
local colors = require("cyberdream.colors").default
local cyberdream = require("lualine.themes.cyberdream")

require("lualine").setup({
	options = {
		component_separators = { left = " ", right = " " },
		section_separators = { left = " ", right = " " },
		theme = cyberdream,
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha" } },
	},
	sections = {
		lualine_a = { { "mode", icon = "" } },
		lualine_b = { { "branch", icon = "" } },
		lualine_c = {
			{
				"diagnostics",
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = "󰝶 ",
				},
			},
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{
				"filename",
				symbols = { modified = "  ", readonly = "", unnamed = "" },
			},
			{
				function()
					return nvim_navic.get_location()
				end,
				cond = function()
					return package.loaded["nvim-navic"] and nvim_navic.is_available()
				end,
				color = { fg = colors.grey, bg = colors.none },
			},
		},
		lualine_x = {
			{ "diff" },
		},
		lualine_y = {
			{
				"progress",
			},
			{
				"location",
				color = { fg = colors.cyan, bg = colors.none },
			},
		},
		lualine_z = {
			function()
				return "  " .. os.date("%H:%M") .. " 🚀 "
			end,
		},
	},
	extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
})
