local ext_to_lang = {
	prisma = "javascript",
	js = "javascript",
	json = "javascript",
	jsx = "javascript",
	ts = "typescript",
	tsx = "typescript",
	css = "css",
	scss = "css",
	py = "python",
	lua = "lua",
	rs = "rust",
}

local function format()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	local ext = name:match("%.(%w+)$")
	local lang = ext_to_lang[ext]

	if lang then
		if lang == "javascript" or lang == "typescript" or lang == "css" then
			vim.g.neoformat_try_node_exe = 1
			vim.cmd("Neoformat prettier")
			return
		end

		vim.cmd("Neoformat")
		return
	end
end

vim.keymap.set("n", "<leader>m", format, { desc = "Format buf with Neoformat or ls" })
