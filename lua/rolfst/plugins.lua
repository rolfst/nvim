local global = require("rolfst.global")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    dev = {
        path = "~/workspaces/nvim-plugins",
    },
    -- {
    --     "junegunn/fzf",
    --     build = function()
    --         vim.fn["fzf#install"]()
    --     end,
    --     lazy = true,
    -- },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "FzfLua",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-lua/plenary.nvim",
            "mrcjkb/telescope-manix",
            "nvim-telescope/telescope-media-files.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "camgraff/telescope-tmux.nvim",
        },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- dependencies = { "mrjones2014/nvim-ts-rainbow" },
    },
    { "nvim-treesitter/playground" },

    {
        "TimUntersberger/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = "Neogit",
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = {
            "BufRead",
        },
    },
    { "akinsho/toggleterm.nvim" },
    { "ThePrimeagen/harpoon" },
    { "rgroli/other.nvim" },
    -- { "mbbill/undotree" },
    { "XXiaoA/atone.nvim", cmd = "Atone" },
    {
        "neovim/nvim-lspconfig",
    },
    --     dependencies = {
    --         -- LSP Support
    --         { "williamboman/mason.nvim" },
    --         { "williamboman/mason-lspconfig.nvim" },
    --         { "j-hui/fidget.nvim" },
    --         { "folke/neodev.nvim" },
    --         { "saghen/blink.cmp" },
    --     },
    -- },
    -- Autocompletion
    -- {
    --     "hrsh7th/nvim-cmp",
    --     dependencies = {
    --         { "hrsh7th/cmp-buffer" },
    --         { "hrsh7th/cmp-path" },
    --         { "saadparwaiz1/cmp_luasnip" },
    --         { "hrsh7th/cmp-nvim-lsp" },
    --         { "hrsh7th/cmp-nvim-lua" },
    --
    --         -- Snippets
    --         { "L3MON4D3/LuaSnip" },
    --         { "rafamadriz/friendly-snippets" },
    --     },
    -- },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
    },
    { "rafamadriz/friendly-snippets" },
    {
        "saghen/blink.cmp",
        version = "1.*",
        build = "cargo build --release",
        dependencies = {
            { "L3MON4D3/LuaSnip", version = "v2.*" },
            { "rafamadriz/friendly-snippets" },
        },
        sources = {
            default = { "luasnip", "lsp", "path", "buffer" },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
    },

    {
        "danymat/neogen",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        event = {
            "BufRead",
        },
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        config = function()
            require("mcphub").setup()
        end,
    },
    { "HakonHarnes/img-clip.nvim" },
    {
        "Davidyz/VectorCode",
        version = "0.7.7",
        build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
        -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
        cmd = { "VectorCode", "VectorCodeSearch", "VectorCodeIndex" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "flyingshutter/gemini-autocomplete.nvim", opts = {} },
    {
        "olimorris/codecompanion.nvim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim",
            {
                "echasnovski/mini.diff",
            },
            "HakonHarnes/img-clip.nvim",
        },
    },
    -- { "zbirenbaum/copilot.lua" },
    -- {
    --     "CopilotC-Nvim/CopilotChat.nvim",
    --     branch = "main",
    --     dependencies = {
    --         { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    --         { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    --     },
    --     opts = {
    --         debug = true, -- Enable debugging
    --         -- See Configuration section for rest
    --     },
    -- },
    --     -- See Commands section for default commands if you want to lazy load on them

    -- Util plugins
    { "gpanders/editorconfig.nvim" },
    { "tpope/vim-repeat" },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "numToStr/Comment.nvim",
        event = {
            "CursorMoved",
        },
    },
    {
        "vim-ctrlspace/vim-ctrlspace",
        keys = {
            { "<space><space>", "<Cmd>CtrlSpace<CR>", desc = "CtrlSpace" },
        },
        cmd = "CtrlSpace",
    },
    { "echasnovski/mini.nvim", version = false },
    { "echasnovski/mini.move", version = false },
    { "echasnovski/mini.ai", version = false },
    { "echasnovski/mini.diff", version = false },
    {
        "HakonHarnes/img-clip.nvim",
    },

    {
        "Dkendal/nvim-treeclimber",
        dependencies = { "rktjmp/lush.nvim" },
    },
    {
        "windwp/nvim-autopairs",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
        },
    },

    {
        "kylechui/nvim-surround",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "pechorin/any-jump.vim",
        event = {
            "bufread",
        },
    },

    {
        "simrat39/symbols-outline.nvim",
        event = {
            "bufread",
        },
    },

    {
        "kevinhwang91/nvim-hlslens",
        event = {
            "BufRead",
        },
    },

    {
        "stevearc/quicker.nvim",
        ft = "qf",
    },
    {
        "yorickpeterse/nvim-pqf",
        url = "https://gitlab.com/yorickpeterse/nvim-pqf",
    },
    "dnlhc/glance.nvim",
    { "anuvyklack/pretty-fold.nvim" },
    { "ziontee113/neo-minimap" },
    -- DAP plugins
    { "mfussenegger/nvim-dap" },
    { "rolfst/nvim-dap-vscode-js", lazy = true },
    -- {
    --     "microsoft/vscode-js-debug",
    --     build = "npm install --legacy-peer-deps --ignore-scripts --production && npx gulp vsDebugServerBundle && mv dist out && ln -s "
    --         .. global.plugin_path
    --         .. "/vscode-js-debug "
    --         .. global.mason_path
    --         .. "/",
    -- },

    { "jbyuki/one-small-step-for-vimkind", lazy = true },
    {
        "rcarriga/nvim-dap-ui",
        event = {
            "bufread",
        },
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            -- "mxsdev/nvim-dap-vscode-js",
            "jbyuki/one-small-step-for-vimkind",
        },
    },
    { "nvim-neotest/nvim-nio" },
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     build = function()
    --         vim.fn["mkdp#util#install"]()
    --     end,
    --     lazy = false,
    -- },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
    },
    {
        "OXY2DEV/markview.nvim",
        event = "VeryLazy",
        opts = {
            preview = {
                filetypes = { "markdown", "codecompanion" },
                ignore_buftypes = {},
            },
        },
    },

    -- Test plugins

    {
        "nvim-neotest/neotest",
        -- dev = true,
        -- "/home/rolfst/workspaces/nvim-plugins/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "MrcJkb/neotest-haskell",
            "haydenmeade/neotest-jest",
            "Nelfimov/neotest-node-test-runner",
        },
        opts = {
            adapters = { ["neotest-node-test-runner"] = {} },
            -- {
            --     dev = true,
            --     "/home/rolfst/workspaces/nvim-plugins/neotest-node-test",
            -- },
            -- "jfpedroza/neotest-elixir",
            -- "olimorris/neotest-phpunit",
            -- "nvim-neotest/neotest-go",
        },
    },

    -- Language plugins
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "Saecki/crates.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = "BufRead Cargo.toml",
    },
    { "mfussenegger/nvim-jdtls" },

    {
        "jose-elias-alvarez/typescript.nvim",
        ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    { "OlegGulevskyy/better-ts-errors.nvim" },
    { "onsails/diaglist.nvim" },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "ray-x/sad.nvim",
        dependencies = { { "ray-x/guihua.lua", build = "cd lua/fzy && make" } },
    },
    -- UI plugins
    --
    { "norcalli/nvim-colorizer.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "SmiteshP/nvim-navic" },
    {
        "rebelot/heirline.nvim",
    },
    { "luukvbaal/statuscol.nvim" },
    -- {
    --     "lvimuser/lsp-inlayhints.nvim",
    -- },
    {
        "ggandor/lightspeed.nvim",
        dependencies = {
            "tpope/vim-repeat",
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "OXY2DEV/markview.nvim",
        },
        lazy = false,
    },
    { "folke/which-key.nvim" },
    { "folke/snacks.nvim" },

    -- tools
    {
        "saxon1964/neovim-tips",
        version = "*", -- Only update on tagged releases
        lazy = true, -- Load only when keybinds are triggered
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
            "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
            -- OR: "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
        },
        opts = {
            -- IMPORTANT: Daily tip DOES NOT WORK with lazy = true
            -- Reason: lazy = true loads plugin only when keybinds are triggered,
            --         but daily_tip needs plugin loaded at startup
            -- Solution: Keep daily_tip = 0 here, or use Option 2 below for daily tips
            daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
            -- Other optional settings...
            bookmark_symbol = "🌟 ",
        },
        keys = {
            { "<leader>nto", ":NeovimTips<CR>", desc = "Neovim tips" },
            {
                "<leader>ntr",
                ":NeovimTipsRandom<CR>",
                desc = "Show random tip",
            },
            { "<leader>nte", ":NeovimTipsEdit<CR>", desc = "Edit your tips" },
            { "<leader>nta", ":NeovimTipsAdd<CR>", desc = "Add your tip" },
            { "<leader>ntp", ":NeovimTipsPdf<CR>", desc = "Open tips PDF" },
        },
    },
    { "sotte/presenting.vim" },
    {
        "renerocksai/telekasten.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "renerocksai/calendar-vim",
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-telescope/telescope-media-files.nvim",
        },
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
})
