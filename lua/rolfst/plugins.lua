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
	-- { "nvim-telescope/telescope-fzf-native.nvim", lazy = true },
	-- { "nvim-telescope/telescope-file-browser.nvim", lazy = true },
	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope-fzf-native.nvim",
	-- 		"nvim-telescope/telescope-file-browser.nvim",
	-- 	},
	-- },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd([[colorscheme rose-pine]])
		end,
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
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
	{ "mbbill/undotree" },
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
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
	{ "jose-elias-alvarez/null-ls.nvim", dependencies = {
		"nvim-lua/plenary.nvim",
	} },

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
	{ "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{
		"numToStr/Comment.nvim",
		event = {
			"CursorMoved",
		},
		config = function()
			require("rolfst.modules.comment").setup()
		end,
	},
	{
		"vim-ctrlspace/vim-ctrlspace",
		keys = {
			{ "<space><space>", "<Cmd>CtrlSpace<CR>", desc = "CtrlSpace" },
		},
		cmd = "CtrlSpace",
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
	{ "pechorin/any-jump.vim", event = {
		"bufread",
	} },

	{ "simrat39/symbols-outline.nvim", event = {
		"bufread",
	} },

	{
		"kevinhwang91/nvim-hlslens",
		event = {
			"BufRead",
		},
		config = function()
			require("rolfst.modules.hlslens").setup()
		end,
	},

	{ "kevinhwang91/nvim-bqf", dependencies = {
		"junegunn/fzf",
	} },

	{ "yorickpeterse/nvim-pqf", url = "https://gitlab.com/yorickpeterse/nvim-pqf" },
	"dnlhc/glance.nvim",
	-- DAP plugins
	{ "mfussenegger/nvim-dap" },

	{ "mxsdev/nvim-dap-vscode-js", lazy = true },

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
		config = function()
			require("rolfst.modules.dap").setup()
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
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
		"Saecki/crates.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "BufRead Cargo.toml",
	},

	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- UI plugins
	{ "nvim-tree/nvim-web-devicons" },
	{ "SmiteshP/nvim-navic" },
	{
		"rebelot/heirline.nvim",
		config = function()
			require("rolfst.modules.heirline").setup()
		end,
	},
	{ "luukvbaal/statuscol.nvim" },
	{
		"lvimuser/lsp-inlayhints.nvim",
		config = function()
			require("rolfst.modules.lsp-inlayhints").setup()
		end,
		lazy = true,
	},
	{ "ggandor/lightspeed.nvim", dependencies = {
		"tpope/vim-repeat",
	} },
})
