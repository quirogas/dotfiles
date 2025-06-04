-- https://luals.github.io/wiki/settings/
return {
  settings = {
    Lua = {
      -- Enable formatting for Lua files
      format = {
        enable = true,
      },

      -- Configure diagnostics (linting/error checking)
      diagnostics = {
        -- Define global variables that the linter should recognize
        globals = { "vim", "spec" },
        -- Suppress specific diagnostic codes (e.g., "missing-field")
        -- You can add more codes here if you encounter persistent false positives.
        disable = {
          "missing-field",
        },
      },

      -- Runtime settings for the Lua environment
      runtime = {
        -- Specify the Lua version. LuaJIT is common for Neovim.
        version = "LuaJIT",
        -- Define special global names and how they should be resolved.
        -- 'spec' is mapped to 'require' for better understanding by the language server.
        special = {
          spec = "require",
        },
      },

      -- Workspace settings for project-wide analysis
      workspace = {
        -- Prevents checking third-party dependencies, which can speed up analysis.
        checkThirdParty = false,
        -- Define additional directories to be treated as Lua libraries.
        -- This helps the language server find definitions for Neovim's built-in Lua files
        -- and your personal Neovim configuration files.
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
          -- If you use a 'plugin' directory in your config, add it here:
          -- [vim.fn.stdpath "config" .. "/lua/plugin"] = true,
        },
        -- Automatically add opened files to the workspace.
        -- This ensures that files you're editing are always part of the language server's context.
        -- This is a good default for most Neovim setups.
        ["!autoCmd"] = { "BufReadPost" },
      },

      -- Configure in-editor hints and suggestions
      hint = {
        enable = true,
        -- Controls when array index hints are shown ("Enable", "Auto", "Disable").
        -- "Enable" shows them always, "Auto" shows them when useful, "Disable" hides them.
        arrayIndex = "Auto",
        -- Show hints for `await` expressions.
        await = true,
        -- Controls when parameter name hints are shown ("All", "Literal", "Disable").
        -- "Literal" shows hints for literal arguments.
        paramName = "Literal",
        -- Show hints for parameter types.
        paramType = true,
        -- Controls semicolon hints ("All", "SameLine", "Disable").
        -- "SameLine" shows hints only for semicolons on the same line.
        semicolon = "SameLine",
        -- Show hints for inferred types.
        setType = true,
      },

      -- Disable telemetry to prevent sending usage data
      telemetry = {
        enable = false,
      },
    },
  },
} -- https://luals.github.io/wiki/settings/
