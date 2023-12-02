local lsp = require("lsp-zero")
local cmp = require('cmp')
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_status = require("lsp-status")
local luasnip = require("luasnip")

lsp.preset("recommended")

local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess:append({ c = true })

mason.setup({
	-- ui = {
	-- icons = {
	-- server_installed = "✓",
	-- server_pending = "➜",
	-- server_uninstalled = "✗",
	-- },
	-- },
})

mason_lspconfig.setup({
	ensure_installed = {
		'tsserver',
		'lua_ls',
		'rust_analyzer',
		'html',
		'cssls',
		'jsonls',
	}
})


-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-p>'] = cmp_action.luasnip_jump_forward(),
		['<C-n>'] = cmp_action.luasnip_jump_backward(),
		['<C-y>'] = cmp.mapping.confirm({ select = false }),
		-- Use enter to select suggestion
		['<CR>'] = cmp.mapping.confirm({ select = true }),

		-- tab complete
		['<Tab>'] = cmp_action.tab_complete(),
	}),
	-- Installed sources
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp_document_symbol" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "crates" },
	},
})

lsp.set_sign_icons({
	error = '⛔️',
	warn = '⚠️',
	hint = '?',
	info = 'i'
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		style = 'minimal',
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
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

	keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

	-- Show diagnostic popup on cursor hover
	local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, { focusable = false })
		end,
		group = diag_float_grp,
	})

	-- Goto previous/next diagnostic warning/error
	keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts)
	keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts)

	-- on_attach(client)
	lsp_status.on_attach(client)
end

local rust_tools_config = {
	-- rust-tools settings, etc.
	dap = function()
		local install_root_dir = vim.fn.stdpath "data" .. "/mason"
		local extension_path = install_root_dir .. "/packages/codelldb/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

		return {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
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
				autoReload = true
			}
		},
	},
}

mason_lspconfig.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have a dedicated handler.
	function(server_name)
		-- I use lsp-status which adds itself to the capabilities table
		require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
	end,

	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
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
