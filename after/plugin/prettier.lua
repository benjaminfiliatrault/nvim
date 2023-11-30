local ext_to_lang = {
  js = "javascript",
  json = "javascript",
  jsx = "javascript",
  ts = "typescript",
  tsx = "typescript",
  py = "python",
  lua = "lua",
  rs = "rust",
}

local function format()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local ext = name:match("%.(%w+)$")
  local lang = ext_to_lang[ext]
  if lang then
    local key = "neoformat_enabled_" .. lang
    if vim.g[key] then
      vim.cmd("Neoformat")
      return
    end
  end
  vim.lsp.buf.format()
end

vim.keymap.set('n', '<leader>m', format, { desc = "Format buf with Neoformat or ls" })
