return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"andythigpen/nvim-coverage",
			version = "*",
			config = function()
				require("coverage").setup({
					auto_reload = true,
				})
			end,
		},
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		local keymap = vim.keymap -- for conciseness
		local keymap_opts = { silent = true }

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }
				-- LSP keybindings
				keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)
				keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, opts)
				keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)
				keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)

				keymap.set("n", "<C-g>", function()
					vim.lsp.buf.code_action()
				end, opts)

				-- Show diagnostic popup on cursor hover
				local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
				vim.api.nvim_create_autocmd("CursorHold", {
					callback = function()
						vim.diagnostic.open_float(nil, { focusable = false })
					end,
					group = diag_float_grp,
				})

				-- Goto previous/next diagnostic warning/error
				keymap.set("n", "nd", vim.diagnostic.goto_next, keymap_opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		vim.diagnostic.config({
			virtual_text = true,
			float = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = "󰠠 ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},
		})
	end,
}
