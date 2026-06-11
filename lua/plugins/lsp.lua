return {
	"neovim/nvim-lspconfig",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"b0o/schemastore.nvim",
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
		local lsps = {
			{ "rust_analyzer" },
			{ "cssls" },
			{ "emmet_ls" },
			{ "gopls" },
			{ "graphql" },
			{ "helm_ls" },
			{ "html" },
			{
				"jsonls",
				{
					enable = true,
					settings = {
						json = {
							schemaStore = { enable = false }, -- Disable conflicting sources
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
			},
			{
				"lua_ls",
				{
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
				},
			},
			{ "marksman" },
			{ "phpactor" },
			{ "prismals" },
			{ "pyright" },
			{ "stylua" },
			{ "svelte" },
			{ "tailwindcss" },
			{ "taplo" },
			{ "ts_ls" },
			{
				"yamlls",
				{
					enable = true,
					settings = {
						yaml = {
							schemas = require("schemastore").yaml.schemas(),
							schemaStore = { enable = false }, -- Disable conflicting sources
							customTags = {
								"!And mapping",
								"!And scalar",
								"!And sequence",
								"!Base64",
								"!Cidr",
								"!Equals",
								"!Equals mapping", -- Include all types
								"!Equals scalar",
								"!Equals sequence",
								"!FindInMap mapping",
								"!FindInMap scalar",
								"!FindInMap sequence",
								"!GetAZs",
								"!GetAtt",
								"!GetAtt sequence",
								"!If mapping",
								"!If scalar",
								"!If sequence",
								"!ImportValue",
								"!ImportValue sequence",
								"!Join sequence",
								"!Not",
								"!Not mapping",
								"!Not scalar",
								"!Not sequence",
								"!Or mapping",
								"!Or scalar",
								"!Or sequence",
								"!Ref",
								"!Select sequence",
								"!Split sequence",
								"!Sub",
							},
						},
					},
				},
			},
		}

		for _, value in pairs(lsps) do
			if value[2] then
				vim.lsp.config(value[1], value[2])
				vim.lsp.enable(value[1], true)
			end
		end

		-- import lspconfig plugin
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
			end,
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

		vim.lsp.buf_request(0, "textDocument/definition", nil, function(error, _)
			print(vim.inspect(error))
		end)
	end,
}
