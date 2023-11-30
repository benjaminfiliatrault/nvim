-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
	-- Packer can manage itself
	use('wbthomason/packer.nvim')

	use({
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		requires = { { 'nvim-lua/plenary.nvim' } }
	})

	-- Theme
	use('rebelot/kanagawa.nvim')

	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

	-- You know what this is
	use('theprimeagen/harpoon')
	-- Git tree visualizer
	use('mbbill/undotree')
	-- Git plugin
	use('tpope/vim-fugitive')
	-- Fuzzy Finder
	use('junegunn/fzf')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{ 'williamboman/mason.nvim' }, -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'hrsh7th/cmp-buffer' }, -- Optional
			{ 'hrsh7th/cmp-path' }, -- Optional
			{ 'saadparwaiz1/cmp_luasnip' }, -- Optional
			{ 'hrsh7th/cmp-nvim-lua' }, -- Optional

			-- Snippets
			{ 'L3MON4D3/LuaSnip' }, -- Required
			{ 'rafamadriz/friendly-snippets' }, -- Optional
		}
	}

	-- To easily surround selected word with quotes & other stuff
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	})

	-- Auto detect tab length
	use('tpope/vim-sleuth')

	-- Prettier recommended
	use('sbdchd/neoformat')
	-- Eslint official
	use('eslint/eslint')

	use('preservim/vim-markdown')

	-- For that pretty Status bar at the bottom
	use('vim-airline/vim-airline')

	-- Improve comment writting
	use('terrortylor/nvim-comment')

	use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons' } }

	-- All the Debugger stuff
	use('mfussenegger/nvim-dap')
	use('theHamsta/nvim-dap-virtual-text')
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
	use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
	use {
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
	}

end)
