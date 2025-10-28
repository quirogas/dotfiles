-- Find gopls path from mise, with a fallback to the mason path
local gopls_path = vim.fn.trim(vim.fn.system "mise which gopls 2>/dev/null")
if vim.v.shell_error ~= 0 or gopls_path == "" then
  gopls_path = vim.fn.stdpath "data" .. "/mason/bin/gopls"
end

return {
  -- Dynamically set the command to use the gopls found by mise or mason
  cmd = { gopls_path, "serve" },
  settings = {
    gopls = {
      -- Enables additional analyses that provide more diagnostics.
      -- "staticcheck" is a good default for catching common issues.
      analyses = {
        staticcheck = true,
      },
      -- Configuration for the hover provider.
      gofumpt = true,
      -- By default, gopls will not show documentation on hover.
      -- Set this to true to get documentation, which is often desired.
      hoverKind = "Structured",
      -- Enables the use of semantic tokens for syntax highlighting,
      -- which can provide more detailed and accurate colors.
      semanticTokens = true,
      -- Automatically organize imports on save.
      -- This is often handled by a formatter, but can be useful here.
      ["local"] = "your/module/path", -- Change this to your Go module path
    },
  },
}
