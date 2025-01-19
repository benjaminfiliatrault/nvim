-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})

	use({ "folke/lazydev.nvim", opts = {} })

	-- Theme
	use({ "catppuccin/nvim", as = "catppuccin" })

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- Note taking
	use({
		"epwalsh/obsidian.nvim",
		tag = "*", -- recommended, use latest release instead of latest commit
		requires = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
	})

	-- Dashboard
	use({
		"nvimdev/dashboard-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "doom",
				hide = { statusline = true },
				preview = {
					command = "lolcrab",
					file_path = vim.fn.expand("~/.config/nvim/logo.txt"),
					file_width = 99,
					file_height = 10,
				},
				config = {
					header = {},
					week_header = { enable = false },
					center = {
						{
							desc = "Files ",
							group = "Statement",
							action = "Telescope find_files",
							key = "f",
							desc_hl = "group",
							key_hl = "TabLine",
							key_format = " -> %s",
						},
						{
							icon_hl = "DiffChange",
							desc = "Recent ",
							group = "DiffAdd",
							action = "Telescope oldfiles",
							key = "r",
							desc_hl = "group",
							key_hl = "TabLine",
							key_format = " -> %s",
						},
						{
							icon_hl = "DiffChange",
							desc = "Grep ",
							group = "DiffDelete",
							action = "Telescope live_grep",
							key = "g",
							desc_hl = "group",
							key_hl = "TabLine",
							key_format = " -> %s",
						},
						{
							icon_hl = "DiffChange",
							desc = "Quit ",
							group = "WarningMsg",
							action = "qall!",
							key = "q",
							desc_hl = "group",
							key_hl = "TabLine",
							key_format = " -> %s",
						},
					},
					footer = {},
				},
			}) -- config
		end,
	})

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

	-- Rust tooling
	use("mrcjkb/rustaceanvim")
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

	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	})

	use("prisma/vim-prisma")

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

	use({
		"luckasRanarison/tailwind-tools.nvim",
		run = ":UpdateRemotePlugins",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
	})

	use("rhaiscript/vim-rhai")

	-- Prettier recommended
	use("sbdchd/neoformat")

	-- Eslint official
	use("mfussenegger/nvim-lint")

	use("preservim/vim-markdown")

	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- For that pretty Status bar at the bottom
	use("vim-airline/vim-airline")

	-- Improve comment writting
	use("terrortylor/nvim-comment")

    -- Status bar at the bottom
	use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" } })

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
		run = "npm ci && npx gulp vsDebugServerBundle && mv dist out",
	})
end)
