return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require('telescope.builtin')

    require("todo-comments").setup()

    telescope.setup({
      defaults = {
        defaults = {
          file_ignore_patterns = {
            "node_modules",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Search for files" })
    keymap.set("n", "<leader>fg", builtin.live_grep, {})
    keymap.set("n", "<leader>fs", builtin.grep_string, {})
    keymap.set("n", "<leader>fb", builtin.buffers, {})
    keymap.set("n", "<leader>fh", builtin.help_tags, {})
    keymap.set("n", "<leader>fd", builtin.diagnostics, {})

    keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search in NeoVim config files" })

    keymap.set("n", "<leader>ft", vim.cmd.TodoTelescope)

  end,
}
