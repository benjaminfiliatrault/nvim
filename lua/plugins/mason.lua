return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"luckasRanarison/tailwind-tools.nvim",
		"prisma/vim-prisma",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_enable = true,
			-- list of servers for mason to install
			ensure_installed = {
				"cssls",
				"emmet_ls",
				"graphql",
				"html",
				"lua_ls",
				"marksman",
				"prismals",
				"pyright",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"jsonls",
			},
		})

		mason_tool_installer.setup({
			automatic_enable = true,
			ensure_installed = {
				"eslint_d", -- js linter
				"isort", -- python formatter
				"prettier", -- prettier formatter
				"pylint", -- python linter
				"stylua", -- lua formatter
				"vacuum", -- openapi linter
			},
		})
	end,
}
