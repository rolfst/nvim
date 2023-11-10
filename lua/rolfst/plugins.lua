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
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
        lazy = true,
    },
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
    { "mbbill/undotree" },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP Support
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "j-hui/fidget.nvim" },
            { "folke/neodev.nvim" },
        },
    },
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
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
    { "Dkendal/nvim-treeclimber", dependencies = { "rktjmp/lush.nvim" } },
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
        "kevinhwang91/nvim-bqf",
        dependencies = {
            "junegunn/fzf",
        },
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

    { "mxsdev/nvim-dap-vscode-js", lazy = true },
    {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && ln -s "
            .. global.plugin_path
            .. "/vscode-js-debug "
            .. global.mason_path
            .. "/",
    },

    { "jbyuki/one-small-step-for-vimkind", lazy = true },
    {
        "rcarriga/nvim-dap-ui",
        event = {
            "bufread",
        },
        dependencies = {
            "mfussenegger/nvim-dap",
            "mxsdev/nvim-dap-vscode-js",
            "jbyuki/one-small-step-for-vimkind",
        },
        -- config = function()
        -- 	require("rolfst.modules.dap").setup()
        -- end,
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        lazy = false,
    },
    -- Test plugins

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "rouge8/neotest-rust",
            "nvim-neotest/neotest-python",
            "MrcJkb/neotest-haskell",
            "haydenmeade/neotest-jest",
            -- "jfpedroza/neotest-elixir",
            -- "olimorris/neotest-phpunit",
            -- "nvim-neotest/neotest-go",
        },
    },

    -- Language plugins
    {
        "simrat39/rust-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
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
    { "onsails/diaglist.nvim" },
    { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },
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
    {
        "lvimuser/lsp-inlayhints.nvim",
    },
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
    { "nvim-treesitter/nvim-treesitter-context" },
    { "folke/which-key.nvim" },

    -- tools
    { "sotte/presenting.vim" },
    {
        "renerocksai/telekasten.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "renerocksai/calendar-vim",
            "nvim-telescope/telescope-symbols.nvim",
            -- "nvim-telescope/telescope-media-files.nvim"
        },
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
})
