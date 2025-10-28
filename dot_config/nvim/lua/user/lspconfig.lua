local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- { "folke/neodev.nvim", config = true }, -- neodev setup should be handled by itself
    "nvim-tree/nvim-web-devicons", -- Often a dependency for icons in diagnostics/UI
    "folke/which-key.nvim",
  },
}

-- Helper function for LSP keymaps
local function lsp_keymaps(bufnr)
  local wk = require "which-key"
  local opts = { noremap = true, silent = false, buffer = bufnr }

  wk.add {
    { "g", group = "goto" },
    { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration", buffer = bufnr },
    { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definition", buffer = bufnr },
    { "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation", buffer = bufnr },
    { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References", buffer = bufnr },
    { "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Line Diagnostics", buffer = bufnr },
    { "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<CR>", desc = "Hover", buffer = bufnr },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", buffer = bufnr },
    {
      "<leader>f",
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
      buffer = bufnr,
    },
    { "<leader>i", "<cmd>LspInfo<cr>", desc = "Info", buffer = bufnr },
    { "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic", buffer = bufnr },
    { "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic", buffer = bufnr },
    { "<leader>l", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action", buffer = bufnr },
    { "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix", buffer = bufnr },
    { "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", buffer = bufnr },
  }
end

M.on_attach = function(_, bufnr)
  lsp_keymaps(bufnr)

  -- **FIX:** Removed the conditional `vim.lsp.inlay_hint.enable` call for lua_ls
  -- The lua_ls server's own settings for 'hint.enable = true' are sufficient,
  -- and attempting to explicitly enable it here can cause a type mismatch.
  -- Neovim's LSP client should automatically display hints if the server
  -- reports capability and is configured to send them.

  -- Enable completion for the attached client
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- Ensure support for textDocument/semanticTokens is enabled if needed for treesitter highlighting
  capabilities.textDocument.semanticTokens = {
    dynamicRegistration = true,
    requests = {
      full = { delta = true },
      range = true,
    },
    tokenTypes = {}, -- Client must declare capability for token types
    tokenModifiers = {}, -- Client must declare capability for token modifiers
    formats = { "relative" }, -- Client supports relative format
  }
  return capabilities
end

function M.config()
  local icons = require "user.icons"
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
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true, -- Changed from "always" to true
      header = "",
      prefix = "",
    },
  }
end

return M
