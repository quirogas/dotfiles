local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
}

function M.config()
  local status_ok, mini_icons = pcall(require, "mini.icons")
  if status_ok then
    mini_icons.setup()
  end

  local which_key = require "which-key"
  which_key.setup {
    preset = "modern",
    win = {
      border = "rounded",
    },
  }

  which_key.add {
    { "<leader>T", group = "Treesitter" },
    { "<leader>b", group = "Buffers" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
    { "<leader>l", group = "LSP" },
    { "<leader>p", group = "Plugins" },
    { "<leader>t", group = "Test" },
  }
end

return M
