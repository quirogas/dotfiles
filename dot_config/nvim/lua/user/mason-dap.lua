local M = {
  "williamboman/mason.nvim",
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",
}

function M.config()
  require("mason-nvim-dap").setup {
    ensure_installed = { "python", "delve" },
  }
end

return M
