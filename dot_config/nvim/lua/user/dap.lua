local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    "theHamsta/nvim-dap-virtual-text",
    "folke/which-key.nvim",
    -- Add specific debuggers here as needed
    -- { "mfussenegger/nvim-dap-python" },
    { "leoluz/nvim-dap-go", config = function() require("dap-go").setup() end },
    -- { "microsoft/vscode-node-debug2", build = "npm install --legacy-peer-deps", version = ">=1.20.0" },
  },
}

function M.config()
  local dap = require "dap"
  local dapui = require "dapui"
  local virtual_text = require "nvim-dap-virtual-text"

  local wk = require "which-key"

  wk.add {
    { "<leader>d", group = "debug" },
    { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
    { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue" },
    { "<leader>dd", "<cmd>DapDisconnect<CR>", desc = "Disconnect" },
    { "<leader>dn", "<cmd>DapNew<CR>", desc = "New session" },
    { "<leader>dt", "<cmd>DapTerminate<CR>", desc = "Terminate" },
    { "<leader>dr", "<cmd>DapRestartFrame<CR>", desc = "Restart frame" },
    { "<leader>di", "<cmd>DapStepInto<CR>", desc = "Step into" },
    { "<leader>do", "<cmd>DapStepOut<CR>", desc = "Step out" },
    { "<leader>ds", "<cmd>DapStepOver<CR>", desc = "Step over" },
    { "<leader>dp", "<cmd>DapPause<CR>", desc = "Pause" },
    { "<leader>de", "<cmd>DapEval<CR>", desc = "Evaluate" },
    { "<leader>dT", "<cmd>DapToggleRepl<CR>", desc = "Toggle REPL" },
    { "<leader>dB", "<cmd>DapClearBreakpoints<CR>", desc = "Clear breakpoints" },
    { "<leader>dl", "<cmd>DapSetLogLevel<CR>", desc = "Set log level" },
    { "<leader>dL", "<cmd>DapShowLog<CR>", desc = "Show log" },
    { "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", desc = "DAP UI" },
  }

  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })

  dapui.setup {
    layouts = {
      {
        elements = { "scopes", "breakpoints", "stacks", "watches" },
        size = 0.25,
        position = "left",
      },
      {
        elements = { "repl", "console" },
        size = 0.25,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    render = {
      max_type_length = nil,
    },
  }

  virtual_text.setup {
    enabled = true,
    highlight_changed_variables = true,
    highlight_current_line = true,
  }

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- Define debugger servers and load configurations
  local servers = {
    "delve",
    -- Add more servers here, e.g., "python" for python
  }

  for _, server in pairs(servers) do
    -- Try to load server-specific settings from user.dapsettings
    local ok, debugger_settings = pcall(require, "user.dapsettings." .. server)
    if ok and debugger_settings then
      if debugger_settings.adapter then
        -- Special case for go: register the adapter as 'go'
        if server == "delve" then
          dap.adapters["go"] = debugger_settings.adapter
        else
          dap.adapters[server] = debugger_settings.adapter
        end
      end
      if debugger_settings.configurations then
        -- Merge configurations for different languages
        for lang, configs in pairs(debugger_settings.configurations) do
          dap.configurations[lang] = configs
        end
      end
    end
  end
end

return M
