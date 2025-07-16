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
  build = "make", -- Or "powershell -ExecutionPolicy Bypass -File Build.ps1" for Windows
}

function M.config()
  -- Load the avante_lib early, typically after your colorscheme is set
  -- It's crucial for tokenizers and model templates.
  require("avante_lib").load()

  -- Avante.nvim setup: Configure the AI provider
  require("avante").setup {
    -- General Avante.nvim settings (optional, you can add more as you explore)
    auto_refresh = true, -- Automatically refresh code after AI edits
    provider = "gemini",
    web_search_engine = {
      provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
    },
    sandbox = {
      allowed_read_paths = { "~" },
      allowed_write_paths = { "~" },
      allowed_commands = { "ls" },
    },
    providers = {
      -- Specify the Gemini provider configuration here
      gemini = {
        -- Set the single, default model for all actions.
        model = os.getenv "AVANTE_GEMINI_DEFAULT_MODEL" or "gemini-2.0-flash",
        -- The endpoint for the Gemini API. This is the default.
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      },
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
