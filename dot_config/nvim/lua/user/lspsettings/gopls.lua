-- Find gopls path dynamically: mise -> PATH -> ~/go/bin -> mason
local function get_gopls_cmd()
  local mise_gopls = vim.fn.trim(vim.fn.system "mise which gopls 2>/dev/null")
  if vim.v.shell_error == 0 and mise_gopls ~= "" and vim.fn.executable(mise_gopls) == 1 then
    return { mise_gopls, "serve" }
  end
  if vim.fn.executable "gopls" == 1 then
    return { "gopls", "serve" }
  end
  local go_bin_gopls = vim.fn.expand "~/go/bin/gopls"
  if vim.fn.executable(go_bin_gopls) == 1 then
    return { go_bin_gopls, "serve" }
  end
  local mason_gopls = vim.fn.stdpath "data" .. "/mason/bin/gopls"
  if vim.fn.executable(mason_gopls) == 1 then
    return { mason_gopls, "serve" }
  end
  return { "gopls", "serve" }
end

return {
  cmd = get_gopls_cmd(),
  settings = {
    gopls = {
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedwrite = true,
        nilness = true,
        useany = true,
      },
      codelenses = {
        generate = true,
        gc_details = false,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
        regenerate_cgo = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      hoverKind = "Structured",
      semanticTokens = true,
    },
  },
}
