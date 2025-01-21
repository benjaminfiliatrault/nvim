vim.opt.guicursor = ""
-- Unset background
vim.o.background = ""

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_perl_provider = 0

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
    filters = {
        dotfiles = false,
    },
    git = { ignore = false },
    sort = {
        sorter = "case_sensitive",
    },
    trash = {
        cmd = "trash"
    },
    view = {
        width = 35,
        side = "right"
    },
    renderer = {
        group_empty = false,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
    },
})

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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

vim.opt.cursorcolumn = true;
vim.opt.cursorline = true;

-- disable that anoying foldenable
vim.opt.foldenable = false

-- auto format rust files on save
vim.g.rustfmt_autosave = 1

