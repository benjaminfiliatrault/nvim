-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------

-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- General settings:
--------------------

-- Highlight on yank
autocmd("TextYankPost", {
	desc = "Highlight text when yanking (copying) text",
	group = augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
	pattern = "",
	command = ":%s/\\s\\+$//e",
})

autocmd("VimEnter", {
	desc = "Open the dashboard",
	group = augroup("dashboard", { clear = true }),
    once = true,
	callback = function()
		require("dashboard").setup({
			theme = "hyper",
			hide = { statusline = true },
			preview = {
				command = "lolcrab -g cool",
				file_path = vim.fn.expand("~/.config/nvim/logo.txt"),
				file_width = 99,
				file_height = 10,
			},
			config = {
				header = {},
				week_header = { enable = false },
				shortcut = {
					{
						icon = " ",
						icon_hl = "DiffChange",
						desc = "Files ",
						group = "Statement",
						action = "Telescope find_files",
						key = "f",
					},
					{
						icon = " ",
						icon_hl = "DiffChange",
						desc = "Recent ",
						group = "DiffAdd",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						icon = " ",
						icon_hl = "DiffChange",
						desc = "Grep ",
						group = "DiffDelete",
						action = "Telescope live_grep",
						key = "g",
					},
					{
						icon = " ",
						icon_hl = "DiffChange",
						desc = "Quit ",
						group = "WarningMsg",
						action = "qall!",
						key = "q",
					},
				},
				project = { enable = true, limit = 8, display = { "  ", "Directory" } },
				mru = { enable = true, limit = 5, display = { "  ", "Recent" } },
				footer = {},
			},
		}) -- config
	end,
})
