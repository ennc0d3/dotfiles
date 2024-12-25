return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "gopls",
        "pyright",
        "terraform-ls",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "python",
        "javascript",
        "proto",
        "terraform",
        "hcl",
      },
    },
  },
  --- ENN
  --- CSV
  {
    "chrisbra/csv.vim",
    enabled = true,
  },
  --- For C/C++ stuff. Also good for protobuf
  {
    "rhysd/vim-clang-format",
    init = function()
      vim.cmd([[
         autocmd FileType proto ClangFormatAutoEnable
    ]])
    end
  },
  ---
  --- For buffer tabs
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- patched fonts support
      "lewis6991/gitsigns.nvim"      -- display git status
    },
  },
  ---
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end
  },
  --- Comment plugin, use gcc - linewise, gbc - blockwise, gca} - curly
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function() require("Comment").setup() end
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end
  },

  -- vim-surround
  {
    "kylechui/nvim-surround",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    event = "VeryLazy",
    version = "2.1.7",
    config = function() require("nvim-surround").setup() end
  },

  -- code completion remove may be
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- cmp_nvim_lsp
      "neovim/nvim-lspconfig", -- lspconfig
      "onsails/lspkind-nvim",  -- lspkind (VS pictograms)
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" }, -- Snippets
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          -- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/go.json
        end
      }, { "saadparwaiz1/cmp_luasnip", enabled = true }
    },
  },

  -- Golang
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- lsp doc
  {
    "ray-x/navigator.lua",
    dependencies = {
      { "hrsh7th/nvim-cmp" }, { "nvim-treesitter/nvim-treesitter" },
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" }, {
      "ray-x/go.nvim",
      event = { "CmdlineEnter" },
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()'
    }, {
      "ray-x/lsp_signature.nvim",       -- Show function signature when you type
      event = "VeryLazy",
      config = function() require("lsp_signature").setup() end
    }
    },
  },

  --- copilot
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      -- { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
    -- Neural
    {
      "dense-analysis/neural",
      config = function()
        require('neural').setup({
          source = {
            openai = {
              api_key = vim.env.OPENAI_API_KEY,
            }
          }
        })
      end
    --
     },
    -- Added for kitty 
    {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup()
    end,
    },
    --
    {
        "fladson/vim-kitty",
        Ift = "kitty",
    },
  },


}
