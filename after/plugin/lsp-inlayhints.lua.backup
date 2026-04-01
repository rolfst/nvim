local lsp_inlayhints_status_ok, lsp_inlayhints = pcall(require, "lsp-inlayhints")
if not lsp_inlayhints_status_ok then
    return
end
lsp_inlayhints.setup({
    inlay_hints = {
        highlight = "Comment",
    },
})
vim.api.nvim_create_augroup("LspAttachInlayHints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttachInlayHints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        lsp_inlayhints.on_attach(client, bufnr)
    end,
})
-- require("inlay-hints").setup()
