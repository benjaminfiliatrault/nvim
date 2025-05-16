return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic", "vim-airline/vim-airline" },
	config = function()
		local nvim_navic = require("nvim-navic")

		require("lualine").setup({
			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				theme = "catppuccin-mocha",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = { { "branch", icon = "" }, { "diff" } },
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
					{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
					{
						"filename",
						path = 4, -- Show 1 level down so folder/file.txt
						symbols = { modified = "  ", readonly = "", unnamed = "unknown" },
					},
					{
						function()
							return nvim_navic.get_location()
						end,
						cond = function()
							return package.loaded["nvim-navic"] and nvim_navic.is_available()
						end,
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { { "location" } },
			},
			extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
		})
	end,
}
