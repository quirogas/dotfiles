local M = {
  "aznhe21/actions-preview.nvim",
}

function M.config()
  local actions_preview = require("actions-preview")

    local wk = require "which-key"
    wk.register {
      name = "LSP",
      ["<leader>la"] = { actions_preview.code_actions, "Preview Action" },
    }

  actions_preview.setup {
    diff = {
      ctxlen = 3,
    },

    -- priority list of external command to highlight diff
    -- disabled by default, must be set by yourself
    highlight_command = {
      require("actions-preview.highlight").delta(),
      require("actions-preview.highlight").diff_so_fancy(),
      require("actions-preview.highlight").diff_highlight(),
    },

    -- priority list of preferred backend
    backend = { "telescope"},

    -- options related to telescope.nvim
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.8,
        height = 0.9,
        prompt_position = "top",
        preview_cutoff = 20,
        preview_height = function(_, _, max_lines)
          return max_lines - 15
        end,
      },
    },
  }
end

return M
