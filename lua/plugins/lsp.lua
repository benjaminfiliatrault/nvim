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
					vim.lsp.buf.hover({
						close_events = {
							"CursorMoved",
							"CursorMovedI",
							"BufHidden",
							"InsertCharPre",
							"WinLeave",
						},
					})
				end, opts)
				keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
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

				vim.api.nvim_create_autocmd("CursorHold", {
					callback = function()
						-- Check for diagnostics at current cursor position
						local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
						if #diagnostics > 0 then
							-- Open a floating window to display diagnostics
							vim.diagnostic.open_float(nil, {
								scope = "cursor",
								focusable = false,
								close_events = {
									"CursorMoved",
									"CursorMovedI",
									"BufHidden",
									"InsertCharPre",
									"WinLeave",
								},
							})
						end
					end,
				})

				---@param jumpCount number
				local function jumpWithVirtLineDiags(jumpCount)
					pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

					vim.diagnostic.jump({ count = jumpCount })

					vim.diagnostic.config({
						virtual_text = false,
						virtual_lines = { current_line = true },
					})
				end

				-- Goto previous/next diagnostic warning/error
				keymap.set("n", "nd", function()
					jumpWithVirtLineDiags(1)
				end, { desc = "󰒕 Next diagnostic" })

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
			virtual_text = false,
			virtual_lines = false,
			float = false,
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
