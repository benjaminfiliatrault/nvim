return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-context",
		{
			"NoahTheDuke/vim-just",
			ft = { "just" },
		},
	},
	config = function()
		-- treesitter-context setup (unchanged)
		local context = require("treesitter-context")
		context.setup({
			enable = false,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		})

		local keymap = vim.keymap
		keymap.set("n", "tse", function()
			context.toggle()
		end)

		-- Install parsers (replaces ensure_installed)
		require("nvim-treesitter").install({
			"bash",
			"c",
			"css",
			"dockerfile",
			"gitignore",
			"go",
			"graphql",
			"html",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"prisma",
			"query",
			"svelte",
			"tsx",
			"typescript",
			"rust",
			"vim",
			"vimdoc",
			"yaml",
		})

		-- Enable highlighting + indentation via FileType autocmd
		-- (replaces highlight.enable and indent.enable)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				-- uncomment below if you want treesitter indentation back
				-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Autotag setup (now handled directly by the plugin, not via ts configs)
		require("nvim-ts-autotag").setup()

		-- Incremental selection (still works via built-in nvim 0.12 treesitter)
		vim.keymap.set("n", "<C-s>", function()
			vim.cmd("normal! v")
			vim.cmd("lua vim.treesitter.node_selection.select()")
		end)

		-- Native incremental selection keymaps
		vim.keymap.set({ "n", "x" }, "<C-s>", function()
			require("nvim-treesitter.incremental_selection").init_selection()
		end)
		vim.keymap.set("x", "<C-s>", function()
			require("nvim-treesitter.incremental_selection").node_incremental()
		end)
		vim.keymap.set("x", "<bs>", function()
			require("nvim-treesitter.incremental_selection").node_decremental()
		end)
	end,
}
