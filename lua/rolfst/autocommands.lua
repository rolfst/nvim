local group = vim.api.nvim_create_augroup("NvimIDE", {
    clear = true,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        -- require("rolfst.modules.lsp").setup()
    end,
    group = group,
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWinLeave" }, {
    callback = function()
        local buftype = vim.tbl_contains(
            { "prompt", "nofile", "help", "quickfix" },
            vim.bo.buftype
        )
        local filetype = vim.tbl_contains({
            "calendar",
            "Outline",
            "git",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "NeogitStatus",
            "octo",
            "toggleterm",
        }, vim.bo.filetype)
        if buftype or filetype then
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.cursorcolumn = false
            vim.opt_local.colorcolumn = "0"
        end
    end,
    group = group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "dart",
        "haskell",
        "objc",
        "objcpp",
        "ruby",
    },
    command = "setlocal ts=2 sw=2",
    group = group,
})

local open_folds_filetypes = {
    "nix",
    "markdown",
    "text",
    "gitcommit",
    "help",
    "org",
    "norg",
    "rst",
    "tex",
    "latex",
}

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local ft = vim.bo.filetype
        if vim.tbl_contains(open_folds_filetypes, ft) then
            return
        end
        local ok, ufo = pcall(require, "ufo")
        if not ok then return end
        local bufnr = vim.api.nvim_get_current_buf()
        local attempts = 0
        local function try_close()
            attempts = attempts + 1
            local info = require("ufo.main").inspectBuf(bufnr)
            if info then
                vim.api.nvim_buf_call(bufnr, function()
                    ufo.closeAllFolds()
                end)
            elseif attempts < 30 then
                vim.defer_fn(try_close, 100)
            end
        end
        vim.defer_fn(try_close, 100)
    end,
    group = group,
})

local status_ok, Snacks = pcall(require, "snacks")
if status_ok then
    vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
            if event.data.actions[1].type == "move" then
                Snacks.rename.on_rename_file(
                    event.data.actions[1].src_url,
                    event.data.actions[1].dest_url
                )
            end
        end,
    })
end
