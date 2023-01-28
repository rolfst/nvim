local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local null_ls_builtins = {
    cpplint = diagnostics.cpplint,
    flake8 = diagnostics.flake8,
    golangci_lint = diagnostics.golangci_lint,
    luacheck = diagnostics.luacheck,
    rubocop = diagnostics.rubocop,
    shellcheck = diagnostics.shellcheck,
    vint = diagnostics.vint,
    yamllint = diagnostics.yamllint,
    black = formatting.black,
    cbfmt = formatting.cbfmt,
    prettierd = formatting.prettierd.with({
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "yaml",
            "markdown",
            "markdown.mdx",
            "graphql",
            "handlebars",
        },
        env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("$HOME/.config/nvim/.configs/formatters/.prettierrc.json"),
        },
        options = {
            args = { "$FILENAME", "--no-progress" },
        },
    }),
    shfmt = formatting.shfmt,
    stylua = formatting.stylua,
}
null_ls.register({
    null_ls_builtins[v],
})
