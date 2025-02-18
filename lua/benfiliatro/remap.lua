-- Set leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/benfiliatro/packer.lua<CR>")

-- Debugger Mapping
vim.keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", { noremap=true })
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { noremap=true })
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { noremap=true })
vim.keymap.set("n", "<leader>dr", ":lua require('dapui').open({reset=true})<CR>", { noremap=true })
vim.keymap.set("n", "<leader>dq", ":lua require('dapui').close({reset=true})<CR>", { noremap=true })

-- Best remaps ever so no arrows
vim.api.nvim_set_keymap('n', '<left>', [[:echo "STOP IT. USE 'h'"<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<up>', [[:echo "STOP IT. USE 'j'"<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<down>', [[:echo "STOP IT. USE 'k'"<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<right>', [[:echo "STOP IT. USE 'l'"<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', "<cmd>vsp<CR> <C-w>w <cmd>terminal<CR> i", { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Leader><ESC>', '<C-\\><C-n>', { noremap = true })
