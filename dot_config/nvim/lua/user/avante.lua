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
    providers = {
      -- Specify the Gemini provider configuration here
      gemini = {
        -- Recommended model for general use with Avante.nvim
        -- You can choose based on your needs: gemini-1.5-flash-latest, gemini-1.5-pro-latest, etc.
        model = "gemini-1.5-flash-latest",
        -- The endpoint for the Gemini API. This is the default.
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",

        -- Optional: Configure extra request body parameters (e.g., safety settings, temperature)
        -- These are now inside 'extra_request_body'
        extra_request_body = {
          -- temperature = 0.5,
          -- max_output_tokens = 2048,
          -- safety_settings = {
          --   {
          --     category = "HARM_CATEGORY_HATE_SPEECH",
          --     threshold = "BLOCK_NONE",
          --   },
          --   -- Add other safety categories as needed
          -- },
        },
      },
    },

    -- Chat and edit models should now reference the provider and model
    -- You can set these to use the 'gemini' provider's configured model,
    -- or explicitly define a different model if desired.
    -- chat_model = "gemini:gemini-1.5", -- Format: "provider_name:model_name"
    -- edit_model = "gemini:gemini-1.5", -- Format: "provider_name:model_name"
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
