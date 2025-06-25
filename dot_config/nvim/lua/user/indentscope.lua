local M = {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
}

function M.config()
  require("mini.indentscope").setup {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  }
end

return M
