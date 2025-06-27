local M = {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPost", -- Load when a file is read to detect conflicts
  dependencies = { "folke/which-key.nvim", "nvim-tree/nvim-web-devicons" },
}

function M.config()
  local wk = require "which-key"

  wk.add {
    { "<leader>gc", group = "Conflict" },
    { "<leader>gcl", "<cmd>GitConflictListQf<CR>", desc = "List Conflicts (Quickfix)" },
    { "<leader>gcn", function()
      require("git-conflict").next_conflict()
    end, desc = "Next Conflict" },
    { "<leader>gcp", function()
      require("git-conflict").previous_conflict()
    end, desc = "Prev Conflict" },
  }

  require("git-conflict").setup {
    default_mappings = true, -- Enables default keymaps for choosing changes (co, ct, cb, c0)
    disable_diagnostics = false, -- Show diagnostics for conflict markers
    highlights = { -- You can customize the colors if you want
      ours = "DiffAdd",
      theirs = "DiffText",
    },
  }
end

return M
