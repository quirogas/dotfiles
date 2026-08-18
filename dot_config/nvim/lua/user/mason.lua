local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  local servers = { "lua_ls", "gopls", "jsonls", "ruff", "yamlls", "ts_ls", "eslint", "html", "cssls" }

  require("mason-lspconfig").setup {
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = servers,
  }

  local lsp_defaults = require "user.lspconfig"

  -- A helper function to apply our custom settings to each server
  local function setup_server(server_name)
    -- Start with the custom settings for the server, if they exist
    local server_opts = {}
    local ok, custom_settings = pcall(require, "user.lspsettings." .. server_name)
    if ok and type(custom_settings) == "table" then
      server_opts = custom_settings
    end

    -- Apply our default on_attach and capabilities to the server options
    server_opts.on_attach = lsp_defaults.on_attach
    server_opts.capabilities = lsp_defaults.common_capabilities()

    if vim.lsp.config then
      vim.lsp.config(server_name, server_opts)
      vim.lsp.enable(server_name)
    else
      require("lspconfig")[server_name].setup(server_opts)
    end
  end

  -- Loop through the servers and define their configurations
  for _, server_name in ipairs(servers) do
    setup_server(server_name)
  end
end

return M
