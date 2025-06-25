local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    "theHamsta/nvim-dap-virtual-text",
    -- Add specific debuggers here as needed
    -- { "mfussenegger/nvim-dap-python" },
    -- { "leoluz/nvim-dap-go" },
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
    elements = {
      "scopes",
      "breakpoints",
      "stacks",
      "watches",
    },
    icons = { -- Added missing required field
      expanded = "▾", -- Added missing required field
      collapsed = "▸", -- Added missing required field
      current_frame = "▶", -- Added missing required field
    },
    mappings = {}, -- Added missing required field
    element_mappings = {}, -- Added missing required field
    expand_lines = true, -- Added missing required field
    force_buffers = false, -- Fixed type from nil to boolean
    render = { -- Attempting to fix type with a table
      indent = 0, -- Changed type from boolean to integer
    },
    controls = {
      enabled = true, -- Added missing required field
      icons = {
        play = "▶",
        pause = "⏸",
        stop = "⏹",
        step_over = "⏭",
        step_into = " stepping into",
        step_out = " stepping out",
        step_back = " backward stepping",
        run_last = " last run",
        terminate = " terminating",
      },
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.25,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
          {
            id = "stacks",
            size = 0.25,
          },
          {
            id = "watches",
            size = 0.25,
          },
        },
        size = 0.4,
        position = "left",
      },
      {
        elements = {
          {
            id = "repl",
            size = 0.5,
          },
          {
            id = "console",
            size = 0.5,
          },
        },
        size = 0.6,
        position = "bottom",
      },
    },
    -- Floating window options
    floating = {
      max_height = nil, -- Current window height will be used
      max_width = nil, -- Current window width will be used
      border = "rounded", -- Border style for floating windows
      mappings = {
        close = { "q", "&lt;Esc&gt;" },
      },
    },
    -- Sidebar configuration
    sidebar = {
      open_on_start = false,
      elements = {
        {
          id = "v8_inspector",
          size = 0.5,
        },
        {
          id = "breakpoints",
          size = 0.5,
        },
      },
    },
  }

  --[[
  nvim-dap-virtual-text configuration
  Displays virtual text for variables and other debug information.
  Note: Changing the breakpoint icon itself is likely not controlled by this plugin's configuration.
  It might be related to nvim-dap or nvim-dap-ui signs/highlight groups.
  --]]
  virtual_text.setup {
    enabled = true, -- enable this plugin (default true)
    enabled_when_running = true, -- show virtual text only when dap is running (default true)
    -- this will show the virtual text only when the debugger is paused on a breakpoint
    -- and the current buffer is the one with the breakpoint
    only_first_definition = true, -- show only the first definition of a variable (default true)
    gen_text_mode = "compact", -- compact or multiline (default "compact")
    -- compact mode shows one line per variable
    -- multiline mode shows each variable on a new line
    all_references = false, -- show all references of a variable (default false)
    -- this will show the virtual text for all references of a variable
    -- otherwise it will show only for the first reference
    show_stop_reason = true, -- show stop reason (default true)
    -- this will show the reason why the debugger stopped
    comment_prefix = " &lt;-- ", -- prefix for virtual text (default " &lt;-- ")
    -- this will be added before the virtual text
    highlight_changed_variables = true, -- highlight changed variables (default true)
    -- this will highlight variables that have changed since the last stop
    highlight_current_line = true, -- highlight current line (default true)
    -- this will highlight the current line when the debugger is stopped
    highlight_current_frame = true, -- highlight current frame (default true)
    -- this will highlight the current frame in the stack trace
    enable_commands = true, -- Added missing required field
    all_frames = false, -- Added missing required field
    commented = true, -- Added missing required field
    highlight_new_as_changed = false, -- Added missing required field
    clear_on_continue = false, -- Added missing required field
    text_prefix = " &lt;-- ", -- Added missing required field
    separator = " ", -- Added missing required field
    error_prefix = "❌", -- Added missing required field
    info_prefix = "ℹ️", -- Added missing required field
    virt_text_pos = "eol", -- Added missing required field
    virt_lines = false, -- Added missing required field
    virt_lines_above = false, -- Added missing required field
    filter_references_pattern = "", -- Added missing required field
    display_callback = nil, -- Added missing required field
  }

  --[[
  DAP event handling for UI
  Opens and closes the DAP UI automatically.
  --]]
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
        dap.adapters[server] = debugger_settings.adapter
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
