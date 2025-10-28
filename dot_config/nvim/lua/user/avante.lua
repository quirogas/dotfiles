local M = {
  "yetone/avante.nvim",
  event = "VeryLazy", -- Use VeryLazy to ensure it loads after most other plugins
  version = false, -- Never set this value to "*"! Never!
  dependencies = {
    -- Required by Avante for core functionality
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Highly recommended for rendering markdown (e.g., chat responses)
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" }, -- Essential: Add "Avante" filetype for chat window rendering
      },
      ft = { "markdown", "Avante" }, -- Lazy load based on filetype
    },
    -- Optional dependencies you might already have or want to add
    "hrsh7th/nvim-cmp", -- For completion integration
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "nvim-tree/nvim-web-devicons", -- For icons
    -- If you want to use icons specifically from mini.icons, ensure it's here
    -- "echasnovski/mini.icons", -- You mentioned mini.icons in your which-key config, so this might be relevant.
  },
  -- If you need to build from source (e.g., prebuilt binary not available for your system)
  build = "make",
}

function M.config()
  -- Load the avante_lib early, typically after your colorscheme is set
  -- It's crucial for tokenizers and model templates.
  require("avante_lib").load()

  -- Avante.nvim setup: Configure the AI provider
  require("avante").setup {
    provider = "gemini",
    mode = "agentic", -- Use "agentic" mode for tool-based interaction
    behaviour = {
      auto_approve_tool_permissions = false, -- Prompt for permission before using tools
    },
    web_search_engine = {
      provider = "google", -- tavily, serpapi, google, kagi, brave, or searxng
      -- proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    },
    providers = {
      gemini = {
        -- Set a current, valid model
        model = os.getenv "AVANTE_GEMINI_DEFAULT_MODEL" or "gemini-2.5-flash",
        -- No endpoint needed, let the plugin use its default
      },
    },

    --- NEW: Suggestion Engine Tuning ---
    -- This section directly controls the frequency of API requests.
    suggestion = {
      -- Debounce requests to avoid sending them on every keystroke.
      -- The default is 600ms; a slightly higher value can further reduce requests.
      debounce = 800, -- (milliseconds)
    },

    --- NEW: Autocompletion Engine ---
    -- This section enables and configures the inline code completion.
    auto_suggestions = {
      -- Enable the autocompletion feature.
      enabled = true,
      -- Use a provider specifically for completions.
      -- The "flash" models are faster and cheaper, ideal for this.
      provider = "gemini",
      model = "gemini-2.5-flash",
    },
  }

  --- Which-key Mappings for Avante.nvim ---
  local wk = require "which-key"
  -- Assuming you have 'user.icons' or 'mini.icons' and want to use them.
  -- If you're using mini.icons, you can access it directly like this:
  -- local icons = require("mini.icons").get("fa", "solid", "robot") -- Example for a robot icon from FontAwesome

  wk.add {
    { "<leader>a", group = "avante (AI)", icon = "󱚟" },
  }
  -----------------------------------------
end

return M
