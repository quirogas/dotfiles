local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    "theHamsta/nvim-dap-virtual-text",
    "folke/which-key.nvim",
    {
      "leoluz/nvim-dap-go",
      config = function()
        local function get_dlv_path()
          local mise_dlv = vim.fn.trim(vim.fn.system "mise which dlv 2>/dev/null")
          if vim.v.shell_error == 0 and mise_dlv ~= "" and vim.fn.executable(mise_dlv) == 1 then
            return mise_dlv
          end
          if vim.fn.executable "dlv" == 1 then
            return "dlv"
          end
          local go_bin_dlv = vim.fn.expand "~/go/bin/dlv"
          if vim.fn.executable(go_bin_dlv) == 1 then
            return go_bin_dlv
          end
          local mason_dlv = vim.fn.stdpath "data" .. "/mason/bin/dlv"
          if vim.fn.executable(mason_dlv) == 1 then
            return mason_dlv
          end
          return "dlv"
        end

        require("dap-go").setup {
          delve = {
            path = get_dlv_path(),
            initialize_timeout_sec = 20,
          },
        }
      end,
    },
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
    { "<leader>dg", group = "Go Debug" },
    { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug Go Test" },
    { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Go Test" },
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
        if server == "delve" then
          dap.adapters["go"] = debugger_settings.adapter
        else
          dap.adapters[server] = debugger_settings.adapter
        end
      end
      if debugger_settings.configurations then
        for lang, configs in pairs(debugger_settings.configurations) do
          dap.configurations[lang] = vim.list_extend(dap.configurations[lang] or {}, configs)
        end
      end
    end
  end
end

return M
