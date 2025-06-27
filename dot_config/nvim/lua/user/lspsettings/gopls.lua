-- Find gopls path from mise, with a fallback to the default path
local gopls_path = vim.fn.trim(vim.fn.system "mise which gopls 2>/dev/null")
if vim.fn.empty(gopls_path) == 1 then
  gopls_path = "gopls" -- Fallback to gopls in PATH
end

return {
  -- Dynamically set the command to use the gopls found by mise
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
