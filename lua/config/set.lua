vim.opt.guicursor = ""

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_perl_provider = 0

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = false

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.cursorcolumn = true
vim.opt.cursorline = true

-- disable that anoying foldenable
vim.opt.foldenable = false

-- auto format rust files on save
vim.g.rustfmt_autosave = 1

-- disables the search count at each search.
vim.opt.shortmess:append("S")

vim.opt.timeoutlen = 250

-- For nvimdiff merge tool since that the primary
-- usage of the diff tool for me I disable the line
-- match default to match the entire conflict marker
vim.opt.diffopt:remove("linematch:40")
