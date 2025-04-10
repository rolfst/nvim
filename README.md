# My Neovim Config


## Goal
Configure a neovim with my basic needs with room to add more plugins and languages.

This configure uses mostly the default way of plugin configuration using the `after/plugin` directories that vim
provides. Plugins are installed using [Lazy](https://github.com/folke/lazy.nvim)


## Plugins

### Search
    junegunn/fzf
    ibhagwan/fzf-lua
### LSP Support
    neovim/nvim-lspconfig 
        williamboman/mason.nvim 
        williamboman/mason-lspconfig.nvim 
        folke/neodev.nvim
    Autocompletion
        - hrsh7th/nvim-cmp 
        - hrsh7th/cmp-buffer 
        - hrsh7th/cmp-path 
        - saadparwaiz1/cmp_luasnip 
        - hrsh7th/cmp-nvim-lsp 
        - hrsh7th/cmp-nvim-lua 
        - zbirenbaum/copilot.lua
        Snippets
        - rafamadriz/friendly-snippets 
        - jose-elias-alvarez/null-ls.nvim	
        - L3MON4D3/LuaSnip 

### Util plugins
    rose-pine/neovim
    nvim-treesitter/nvim-treesitter
    zbirenbaum/copilot.lua
    TimUntersberger/neogit
    lewis6991/gitsigns.nvim
    akinsho/toggleterm.nvim
    ThePrimeagen/harpoon
    mbbill/undotree
    danymat/neogen
    tpope/vim-repeat
    folke/trouble.nvim
    numToStr/Comment.nvim
    vim-ctrlspace/vim-ctrlspace
    windwp/nvim-autopairs
    kylechui/nvim-surround
    pechorin/any-jump.vim
    simrat39/symbols-outline.nvim
    kevinhwang91/nvim-hlslens
    kevinhwang91/nvim-bqf
    yorickpeterse/nvim-pqf
    dnlhc/glance.nvim
    iamcco/markdown-preview.nvim
### DAP plugins
    mfussenegger/nvim-dap
    mxsdev/nvim-dap-vscode-js
    jbyuki/one-small-step-for-vimkind
    rcarriga/nvim-dap-ui
    nvim-neotest/nvim-nio
### Test plugins
    nvim-neotest/neotest
    nvim-lua/plenary.nvim
    rouge8/neotest-rust
    nvim-neotest/neotest-python
    MrcJkb/neotest-haskell
    haydenmeade/neotest-jest
#### Language plugins
    simrat39/rust-tools.nvim
    Saecki/crates.nvim
    jose-elias-alvarez/typescript.nvim
#### UI plugins
    nvim-tree/nvim-web-devicons 
    SmiteshP/nvim-navic
    rebelot/heirline.nvim
    luukvbaal/statuscol.nvim
    lvimuser/lsp-inlayhints.nvim
    nvim-treesitter/playground
