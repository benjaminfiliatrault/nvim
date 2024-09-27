-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		requires = {
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-lua/plenary.nvim" },
		},
	})

	use({ "folke/neodev.nvim", opts = {} })

	-- Theme
	use({
		"scottmckendry/cyberdream.nvim",
		requires = {
			"SmiteshP/nvim-navic",
		},
	})

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- Dashboard
	use({
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
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
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

	-- Rust tooling
	use("simrat39/rust-tools.nvim")
	use("rust-lang/rust.vim")

	use({
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("coverage").setup()
		end,
	})

	-- Auto closing brackets
	use("m4xshen/autoclose.nvim")

	-- You know what this is
	use("theprimeagen/harpoon")
	-- Git tree visualizer
	use("mbbill/undotree")
	-- Git plugin
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	use("rhysd/conflict-marker.vim")

	use("github/copilot.vim")

	-- Fuzzy Finder
	use("junegunn/fzf")

	use({
		"folke/todo-comments.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			{ "nvim-lua/lsp-status.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" }, -- Optional
			{ "hrsh7th/cmp-path" }, -- Optional
			{ "saadparwaiz1/cmp_luasnip" }, -- Optional
			{ "hrsh7th/cmp-nvim-lua" }, -- Optional
			{ "mmolhoek/cmp-scss" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "rafamadriz/friendly-snippets" }, -- Optional
			{ "towolf/vim-helm" }, -- Helm Chart yaml
		},
	})

	-- To easily surround selected word with quotes & other stuff
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	use("rhaiscript/vim-rhai")

	-- Auto detect tab length
	use("tpope/vim-sleuth")

	-- Prettier recommended
	use("sbdchd/neoformat")

	-- Eslint official
	use("mfussenegger/nvim-lint")

	use("preservim/vim-markdown")

	-- For that pretty Status bar at the bottom
	use("vim-airline/vim-airline")

	-- Improve comment writting
	use("terrortylor/nvim-comment")

	use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons" } })

	-- All the Debugger stuff
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")

	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			{ "mfussenegger/nvim-dap" },
			{ "nvim-neotest/nvim-nio" },
		},
	})

	use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } })
	use({
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install && npx gulp vsDebugServerBundle && mv dist out",
	})
end)
