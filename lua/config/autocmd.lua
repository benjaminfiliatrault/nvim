local U = require("config.utils")
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

-- Set conceal on specific file type
local concealFile = { "markdown" }
autocmd("BufEnter", {
	desc = "Conceal for markdown files",
	group = augroup("conceal", { clear = true }),
	callback = function()
		-- Only activate conceallevel on Obsidian repo and markdown files
		if U.contains(concealFile, vim.bo.filetype) and string.find(vim.api.nvim_buf_get_name(0), "DeezNotes") then
			-- Disabled for know until I change my mind
			vim.opt.conceallevel = 2
		end
	end,
})
