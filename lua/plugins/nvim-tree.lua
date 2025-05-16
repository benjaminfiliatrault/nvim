return {
  "nvim-tree/nvim-tree.lua",
  config = function()
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

  end,
}
