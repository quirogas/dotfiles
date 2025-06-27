local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}

function M.config()
  local servers = {
    "bashls",
    "jsonls",
    "gopls",
  }

  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = servers,
    automatic_enable = {
      exclude = {
        "lua_ls",
        "gopls",
      },
    },
  }
end

return M
