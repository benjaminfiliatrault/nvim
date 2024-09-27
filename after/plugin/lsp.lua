-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

local cmp = require("cmp")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_status = require("lsp-status")
local luasnip = require("luasnip")

mason.setup()
mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"emmet_ls",
		"ts_ls",
		"html",
		"cssls",
		"yamlls",
	},
})

require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip").filetype_extend("javascript", { "javascriptreact" })
require("luasnip").filetype_extend("typescript", { "javascriptreact" })
require("luasnip").filetype_extend("javascript", { "html" })
require("luasnip").filetype_extend("typescript", { "html" })

require("autoclose").setup()

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.opt.completeopt = "noinsert,menuone,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess:append({ c = true })

cmp.setup({
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions

		["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion

		["<C-y>"] = cmp.mapping.confirm({ select = false }),
		-- Use enter to select suggestion
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- tab complete
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
	-- Installed sources
	sources = {
		{ name = "nvim_lsp", max_item_count = 8, keyword_length = 3 },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp_document_symbol" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "crates" },
		{
			name = "scss",
			option = {
				triggers = { "$" }, -- default value
				extension = ".scss", -- default value
				pattern = [=[\%(\s\|^\)\zs\$[[:alnum:]_\-0-9]*:\?]=], -- default value
				folders = { "node_modules/@soltivo/draw-a-line/core/assets/styles" },
			},
		},
	},
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

lsp_status.register_progress()
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.tbl_extend("keep", capabilities, lsp_status.capabilities)

local function on_attach(client, buffer)
	local keymap = vim.keymap
	local keymap_opts = { buffer = buffer, silent = true }

	if client.name == "rust_analyzer" then
		keymap.set("n", "<leader>h", ":RustHoverActions<cr>", keymap_opts)
		keymap.set("n", "<leader>gp", ":RustParentModule<cr>", keymap_opts)
	else
		keymap.set("n", "<leader>h", vim.lsp.buf.hover, keymap_opts)
	end

	-- Code navigation and shortcuts
	local opts = { buffer = buffer, remap = false }

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
	keymap.set("n", "nd", vim.diagnostic.goto_prev, keymap_opts)

	-- on_attach(client)
	lsp_status.on_attach(client)
end

local rust_tools_config = {
	-- rust-tools settings, etc.
	dap = function()
		local install_root_dir = vim.fn.stdpath("data") .. "/mason"
		local extension_path = install_root_dir .. "/packages/codelldb/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

		return {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		}
	end,
}

local rust_tools_rust_server = {
	on_attach = on_attach,
	settings = {
		-- List of all options:
		-- https://github.com/simrat39/rust-tools.nvim/wiki/Server-Configuration-Schema
		["rust-analyzer"] = {
			cargo = {
				autoReload = true,
				buildScripts = {
					enable = true,
				},
			},
			diagnostics = {
				-- Bug in Rust Analyzer, waiting for a fix
				disabled = { "unresolved-proc-macro" },
			},
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			procMacro = {
				enable = true,
			},
		},
	},
}

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
	end,

	["ts_ls"] = function()
		require("typescript-tools").setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {},
		})
	end,

	["emmet_ls"] = function()
		require("lspconfig").emmet_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
			},
			init_options = {
				html = {
					options = {
						-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
						["bem.enabled"] = true,
					},
				},
			},
		})
	end,

	["yamlls"] = function()
		require("lspconfig").yamlls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				yaml = {
					fileTypes = { "yaml", "yml" },
					schemas = {
						"https://s3.amazonaws.com/cfn-resource-specifications-us-east-1-prod/schemas/2.15.0/all-spec.json",
					},
					customTags = {
						"!fn",
						"!And",
						"!If",
						"!Not",
						"!Equals",
						"!Or",
						"!FindInMap sequence",
						"!Base64",
						"!Cidr",
						"!Ref",
						"!Ref Scalar",
						"!Sub",
						"!GetAtt",
						"!GetAZs",
						"!ImportValue",
						"!Select",
						"!Split",
						"!Join sequence",
					},
				},
			},
		})
	end,

	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					workspace = {
						checkThirdParty = false,
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim", "use" },
					},
				},
			},
		})
	end,

	["rust_analyzer"] = function()
		require("rust-tools").setup({
			-- rust_tools specific settings
			tools = rust_tools_config,
			-- on_attach is actually bound in server for rust-tools
			server = rust_tools_rust_server,
			capabilities = capabilities,
		})
	end,
})

require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 2,
	},
})
