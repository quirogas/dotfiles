local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/neodev.nvim", config = true }, -- neodev setup should be handled by itself
    "nvim-tree/nvim-web-devicons", -- Often a dependency for icons in diagnostics/UI
  },
}

-- Helper function for LSP keymaps
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  -- Using vim.keymap.set is the modern way over vim.api.nvim_buf_set_keymap
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- Pass border option directly to hover function
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<CR>", opts)
  vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- Add more keymaps here as needed, e.g., for renaming, code actions, etc.
  -- keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  -- Use client:supports_method instead of client.supports_method
  if client:supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end

  -- Enable completion for the attached client
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- Ensure support for textDocument/semanticTokens is enabled if needed for treesitter highlighting
  capabilities.textDocument.semanticTokens = { dynamicRegistration = true }
  return capabilities
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.config()
  local wk = require "which-key"
  local lspconfig = require "lspconfig"
  local icons = require "user.icons" -- Assuming this file provides your diagnostic icons

  wk.add {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    {
      "<leader>lf",
      -- Use vim.lsp.buf.format directly. Filter is a valid option.
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
    },
    { "<leader>lh", "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", desc = "Hints" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    -- Example for new keymap:
    -- { "<leader>lx", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Docs" },
  }

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "eslint",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "ruff",
    -- Add more servers here, e.g., "tsserver" for TypeScript
    -- "tsserver",
  }

  -- Define diagnostic configuration using the modern vim.diagnostic.config()
  vim.diagnostic.config {
    signs = {
      active = true,
      -- Use the severity directly for icon mapping
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error or "E",
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning or "W",
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information or "I",
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint or "H",
      },
      -- Highlight groups are usually linked automatically, but you can explicitly define them
      -- texthl = {
      --   [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      --   [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      --   [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      --   [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      -- },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  -- Configure LSP UI styling directly for specific features
  -- vim.lsp.handlers["textDocument/hover"] and vim.lsp.handlers["textDocument/signatureHelp"] are deprecated.
  -- Instead, pass options directly to vim.lsp.buf.hover() and vim.lsp.buf.signature_help().
  -- The existing keymap for 'K' has been updated above.
  -- For signature help, if you have a keymap or other trigger for it, update it similarly.
  -- If signature help is automatically shown, its floating window style might be influenced
  -- by the general `vim.diagnostic.config` or `require("lspconfig.ui.windows").default_options`.
  -- However, for the specific border on signature help, you generally would set it where `signature_help` is called.

  -- This line is still relevant for LSPInfo and other lspconfig-provided UI windows.
  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Iterate through servers and set them up
  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    -- Try to load server-specific settings from user.lspsettings
    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok and type(settings) == "table" then
      -- Deep merge server-specific settings with common options
      opts = vim.tbl_deep_extend("force", opts, settings)
    end

    -- Ensure neodev.nvim is set up for lua_ls if it wasn't configured globally
    if server == "lua_ls" then
      -- If neodev has a setup function, it should be called
      -- The `config = true` in lazy.nvim dependency handles this for you if it's a simple setup.
      -- If neodev needs custom options, you might put `require("neodev").setup(custom_options)` here.
    end

    lspconfig[server].setup(opts)
  end
end

return M
