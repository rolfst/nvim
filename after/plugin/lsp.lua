local lsp = require('lsp-zero')

vim.api.nvim_create_user_command("LspHover", "lua vim.lsp.buf.hover()", {})
vim.api.nvim_create_user_command("LspRename", "lua vim.lsp.buf.rename()", {})
vim.api.nvim_create_user_command("LspAddToWorkspaceFolder", "lua vim.lsp.buf.add_workspace_folder()", {})
vim.api.nvim_create_user_command("LspListWorkspaceFolders", "lua vim.lsp.buf.list_workspace_folders()", {})
vim.api.nvim_create_user_command("LspRemoveWorkspaceFolder", "lua vim.lsp.buf.remove_workspace_folder()", {})
vim.api.nvim_create_user_command("LspWorkspaceSymbol", "lua vim.lsp.buf.workspace_symbol()", {})
vim.api.nvim_create_user_command("LspDocumentSymbol", "lua vim.lsp.buf.document_symbol()", {})
vim.api.nvim_create_user_command("LspCodeAction", "lua vim.lsp.buf.code_action()", {})
vim.api.nvim_create_user_command("LspCodeLensRefresh", "lua vim.lsp.codelens.refresh()", {})
vim.api.nvim_create_user_command("LspCodeLensRun", "lua vim.lsp.codelens.run()", {})
vim.api.nvim_create_user_command("LspDeclaration", "lua vim.lsp.buf.declaration()", {})
vim.api.nvim_create_user_command("LspDefinition", "lua vim.lsp.buf.definition()", {})
vim.api.nvim_create_user_command("LspTypeDefinition", "lua vim.lsp.buf.type_definition()", {})
vim.api.nvim_create_user_command("LspReferences", "lua vim.lsp.buf.references()", {})
vim.api.nvim_create_user_command("LspClearReferences", "lua vim.lsp.buf.clear_references()", {})
vim.api.nvim_create_user_command("LspDocumentHighlight", "lua vim.lsp.buf.document_highlight()", {})
vim.api.nvim_create_user_command("LspImplementation", "lua vim.lsp.buf.implementation()", {})
vim.api.nvim_create_user_command("LspIncomingCalls", "lua vim.lsp.buf.incoming_calls()", {})
vim.api.nvim_create_user_command("LspOutgoingCalls", "lua vim.lsp.buf.outgoing_calls()", {})
vim.api.nvim_create_user_command("LspFormat", "lua vim.lsp.buf.format {async = true}", {})
vim.api.nvim_create_user_command("LspRename", "lua vim.lsp.buf.rename()", {})
vim.api.nvim_create_user_command("LspSignatureHelp", "lua vim.lsp.buf.signature_help()", {})
vim.api.nvim_create_user_command(
    "LspShowDiagnosticCurrent",
    "lua require('languages.base.utils.show_diagnostic').line()",
    {}
)
local icons = require("rolfst.icons")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end
local cmp_config_compare_status_ok, cmp_config_compare = pcall(require, "cmp.config.compare")
if not cmp_config_compare_status_ok then
    return
end
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end
require("luasnip.loaders.from_vscode").lazy_load()
local check_backspace = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local lsp_symbols = icons.cmp
lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver', 'rust_analyzer', 'sumneko_lua', 'pyright', 'eslint',
})
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-space>'] = cmp.mapping.complete(cmp_select),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-c>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif require("neogen").jumpable() then
            require("neogen").jump_next()
        elseif check_backspace() then
            fallback()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        elseif require("neogen").jumpable() then
            require("neogen").jump_prev()
        else
            fallback()
        end
    end, { "i", "s" }),
})

lsp.setup_nvim_cmp({
    formatting = {
        format = function(entry, item)
            item.kind = lsp_symbols[item.kind]
            item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                crates = "[Crates]",
                latex_symbols = "[LaTex]",
            })[entry.source.name]
            return item
        end
    },
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end,
    sources = {
        {
            name = "nvim_lsp",
        },
        {
            name = "luasnip",
        },
        {
            name = "buffer",
        },
        {
            name = "path",
        },
        {
            name = "crates",
        },
        {
            name = "latex_symbols",
        },
        {
            name = "orgmode",
        },
    },
    comparators = {
        cmp_config_compare.exact,
        cmp_config_compare.length,
    },
})


lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local function describe(description)
       local desc = description or '<anonymous>'
       local t = {}
       for k,v in pairs(opts) do
           t[k] = v
       end
       t['desc'] = desc
       return t
    end

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, describe())
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, describe('hover signature'))
    vim.keymap.set('n', 'gws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', 'gds', function() vim.lsp.buf.document_symbol() end, opts)
    vim.keymap.set('n', 'dc', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', 'gR', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', 'gf', vim.cmd.LspZeroFormat, opts)
    vim.keymap.set('i', '<c-h>', function() vim.lsp.buf.signature_help() end, opts)
end)

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end
null_ls.setup({
    debug = false,
    on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                        vim.lsp.buf.format()
                end,
                group = "RolfstIDE",
            })
        end
    end,
})

local rust_server = lsp.build_options("rust_analyzer")

lsp.setup()

require("rust-tools").setup({ server = rust_server})

