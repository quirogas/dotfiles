local M = {
  "stevearc/conform.nvim",
}

function M.config()
  local conform = require "conform"

  -- set autocommand to use format on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      conform.format { bufnr = args.buf }
    end,
  })

  conform.setup {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff" },
    },
  }
end

return M
