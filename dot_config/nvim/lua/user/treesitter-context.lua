local M = {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true,
    max_lines = 3, -- Adjust the number of context lines to show
    min_window_height = 10,
    line_numbers = true,
    trim_scope = "outer",
    separator = "─",
  },
}

return M
