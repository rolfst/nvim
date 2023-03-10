local global = require("rolfst.global")
local funcs = require("rolfst.funcs")
local icons = require("rolfst.icons")
local navic = require("nvim-navic")

-- {{{ Snippets setup
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

luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
            active = {
                virt_text = { { "⬤", "GruvboxOrange" } },
            },
        },
    },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { global.snippets_path .. "/luasnippets" } })

vim.api.nvim_create_user_command("LuaSnipEdit", "lua require'luasnip.loaders.from_lua'.edit_snippet_files()", {})
vim.keymap.set("n", "<space>se", ":LuaSnipEdit<cr>", { desc = "Edit lua snippet" })

vim.keymap.set({ "i", "s" }, "<a-p>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand()
    end
end)
vim.keymap.set({ "i", "s" }, "<a-k>", function()
    if luasnip.jumpable() then
        luasnip.jump(1)
    end
end)
vim.keymap.set({ "i", "s" }, "<a-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end)
vim.keymap.set({ "i", "s" }, "<a-l>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)
vim.keymap.set({ "i", "s" }, "<a-h>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(-1)
    end
end)

local check_backspace = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lsp_symbols = icons.cmp
local cmp_select = { behavior = cmp.SelectBehavior.Select }
function are()
end

cmp.setup({
    mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<C-space>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif require("neogen").jumpable() then
                require("neogen").jump_next()
            else
                fallback()
            end
        end),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-u>"] = cmp.mapping.scroll_docs(4),
            ["<C-c>"] = cmp.mapping.close(),
            ["<C-l>"] = cmp.mapping({
            i = function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end -- code
            end,
        }),
            ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
            ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                -- cmp.confirm({ select = true })
                cmp.select_next_item()
                -- elseif luasnip.expandable() then
                -- 	luasnip.expand()
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
    }),
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
        end,
    },
    snippet = {
        -- REQUIRED, we must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "crates" },
        -- { name = "latex_symbols", },
    },
    comparators = {
        cmp_config_compare.exact,
        cmp_config_compare.length,
    },
})
-- }}}

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
vim.api.nvim_create_user_command("LspFormat", "lua vim.lsp.buf.format()", { desc = "Format current buffer with LSP" })
vim.api.nvim_create_user_command("LspSignatureHelp", "lua vim.lsp.buf.signature_help()", {})
vim.api.nvim_create_user_command("LspShowDiagnosticCurrent", "lua require('rolfst.utils.show_diagnostic').line()", {})

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
})

vim.fn.sign_define("DiagnosticSignError", {
    text = icons.error,
    texthl = "DiagnosticError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
    text = icons.warn,
    texthl = "DiagnosticWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
    text = icons.hint,
    texthl = "DiagnosticHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
    text = icons.info,
    texthl = "DiagnosticInfo",
})

local M = {}
M.on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local describe = funcs.describe(opts)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, describe(desc))
    end

    nmap("gd", vim.cmd.LspDefinition, "[g]oto [d]efinition")
    nmap("gD", function()
        vim.lsp.buf.declaration()
    end, "[g]oto [D]eclaration")
    nmap("gt", function()
        vim.lsp.buf.type_definition()
    end, "[g]oto [t]ype definition")
    -- nmap('gr', require('FzfLua.builtin').lsp_references, '[G]oto [R]eferences')
    nmap("gI", vim.cmd.LspImplementation, "[G]oto [I]mplementation")
    nmap("dc", function()
        vim.diagnostic.open_float()
    end, "[d]iagnoti[c]s")
    nmap("ca", function()
        vim.lsp.buf.code_action()
    end, "[c]ode [a]ction")

    nmap("<leader>rn", function()
        vim.lsp.buf.rename()
    end, "[r]e[n]ame")

    nmap("gf", vim.cmd.LspFormat, "Format")
    vim.keymap.set("v", "gf", function()
        local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        vim.lsp.buf.format({
            range = {
                    ["start"] = { start_row, 0 },
                    ["end"] = { end_row, 0 },
            },
            async = true,
        })
    end, describe("range format"))

    nmap("cL", function()
        vim.lsp.codelens.refresh()
    end, "[c]ode [l]ens refresh")
    nmap("cl", function()
        vim.lsp.codelens.run()
    end, "[c]ode [l]ens run")

    nmap("K", vim.lsp.buf.hover, "Hover documentation")
    vim.keymap.set("i", "<c-k>", function()
        vim.lsp.buf.signature_help()
    end, describe("signature help"))

    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[w]orkspace [l]ist Folders")
end

M.omni = function(client, bufnr)
    if client.server_capabilities.completionProvider then
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end
end

M.tag = function(client, bufnr)
    if client.server_capabilities.definitionProvider then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end
end

M.document_highlight = function(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.document_highlight()",
            group = "NvimIDE",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.clear_references()",
            group = "NvimIDE",
        })
    end
end

M.document_formatting = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
            group = "NvimIDE",
        })
    end
end

M.get_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    return capabilities
end

-- {{{ Null_ls setup
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end
local actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local completions = null_ls.builtins.completion
local formatting = null_ls.builtins.formatting
null_ls.setup({
    debug = false,
    sources = {
        actions.eslint,
        actions.eslint_d,
        actions.gitsigns,
        actions.refactoring,
        diagnostics.cfn_lint,
        diagnostics.deadnix,
        diagnostics.eslint_d,
        diagnostics.flake8,
        diagnostics.luacheck,
        diagnostics.markdownlint,
        diagnostics.stylelint,
        diagnostics.yamllint,
        diagnostics.zsh,
        completions.spell,
        formatting.black,
        formatting.codespell.with({ filetypes = { "markdown" } }),
        formatting.isort,
        formatting.prettier.with({
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
            -- env = {
            --     PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("$HOME/.config/nvim/.configs/formatters/.prettierrc.json"),
            -- },
            options = {
                args = { "$FILENAME", "--no-progress" },
            },
        }),
        -- formatting.yapf,
        formatting.stylua,
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
                group = "NvimIDE",
            })
        end
    end,
})
-- }}}

-- {{{ Lsp setup
local default_debouce_time = 150
local nvim_lsp_util = require("lspconfig/util")
M.default_config = function(file_types, settings)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            -- languages_setup.keymaps(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = M.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = (settings == nil and {} or settings),
    }
end

M.without_formatting = function(file_types, settings)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            -- languages_setup.keymaps(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = M.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = (settings == nil and {} or settings),
    }
end

M.without_winbar_config = function(file_types)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = file_types,
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
end

local servers = {
    -- angularls = {
    --     flags = {
    --         debounce_text_changes = default_debouce_time,
    --     },
    --     autostart = true,
    --     filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
    --     on_attach = function(client, bufnr)
    --         M.omni(client, bufnr)
    --         M.tag(client, bufnr)
    --         M.document_highlight(client, bufnr)
    --         navic.attach(client, bufnr)
    --     end,
    --     capabilities = M.get_capabilities(),
    --     root_dir = nvim_lsp_util.root_pattern("angular.json"),
    -- },
    bashls = M.default_config({ "sh", "bash", "zsh", "csh", "ksh" }),
    -- clangd = {
    --     flags = {
    --         debounce_text_changes = default_debouce_time,
    --     },
    --     autostart = true,
    --     filetypes = { "c", "cpp", "objc", "objcpp" },
    --     on_attach = function(client, bufnr)
    --         client.offset_encoding = "utf-16"
    --         -- languages_setup.keymaps(client, bufnr)
    --         M.omni(client, bufnr)
    --         M.tag(client, bufnr)
    --         M.document_highlight(client, bufnr)
    --         M.document_formatting(client, bufnr)
    --         navic.attach(client, bufnr)
    --     end,
    --     capabilities = M.get_cpp_capabilities(),
    --     root_dir = function(fname)
    --         return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
    --     end,
    -- },
    -- clojure_lsp = M.default_config({ "clojure", "edn" }),
    -- cmake = M.default_config("cmake"),
    cssls = M.without_formatting({ "css", "scss", "less", "sass" }),
    -- elixirls = {
    --     cmd = { global.mason_path .. "/bin/elixir-ls" },
    --     flags = {
    --         debounce_text_changes = default_debouce_time,
    --     },
    --     autostart = true,
    --     filetypes = "elixir",
    --     on_attach = function(client, bufnr)
    --         -- languages_setup.keymaps(client, bufnr)
    --         M.omni(client, bufnr)
    --         M.tag(client, bufnr)
    --         M.document_highlight(client, bufnr)
    --         M.document_formatting(client, bufnr)
    --         navic.attach(client, bufnr)
    --     end,
    --     capabilities = M.get_capabilities(),
    --     root_dir = function(fname)
    --         return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
    --     end,
    -- },
    -- elmls = M.default_config("elm"),
    emmet_ls = M.without_winbar_config({ "html", "css", "javascriptreact", "typescriptreact" }),
    -- erlangls = M.default_config("erlang"),
    eslint = M.without_winbar_config({
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
    }),
    -- gols = {
    --     flags = {
    --         debounce_text_changes = default_debouce_time,
    --     },
    --     autostart = true,
    --     filetypes = { "go", "gomod" },
    --     on_attach = function(client, bufnr)
    --         -- languages_setup.keymaps(client, bufnr)
    --         M.omni(client, bufnr)
    --         M.tag(client, bufnr)
    --         M.document_highlight(client, bufnr)
    --         M.document_formatting(client, bufnr)
    --         navic.attach(client, bufnr)
    --     end,
    --     settings = {
    --         gopls = {
    --             hints = {
    --                 assignVariableTypes = true,
    --                 compositeLiteralFields = true,
    --                 constantValues = true,
    --                 functionTypeParameters = true,
    --                 parameterNames = true,
    --                 rangeVariableTypes = true,
    --             },
    --         },
    --     },
    --     capabilities = M.get_capabilities(),
    --     root_dir = function(fname)
    --         return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
    --     end,
    -- },
    -- graphql = M.default_config("graphql"),
    -- hls = M.default_config({ "haskell", "lhaskell" }),
    -- html = M.without_formatting("html"),
    -- java language server is configured below servers
    jsonls = M.default_config("json"),
    -- kotlin_language_server = M.default_config("kotlin"),
    -- lemminx = M.default_config({ "xml", "xsd", "xsl", "xslt", "svg" }),
    lua_ls = M.default_config("lua", {
        hint = {
            enable = true,
            arrayIndex = "All",
            await = true,
            paramName = "All",
            paramType = true,
            semicolon = "Disable",
            setType = true,
        },
        runtime = {
            version = "LuaJIT",
            special = {
                reload = "require",
            },
        },
        diagnostics = {
            globals = {
                "vim",
                "NOREF_NOERR_TRUNC",
            },
        },
        telemetry = {
            enable = false,
        },
        workspace = { checkThirdParty = false },
    }),
    -- nil_ls = M.default_config("nix"),
    marksman = M.default_config({ "markdown", "telekasten" }),
    -- omnisharp = M.default_config({"cs", "vb"}),
    pyright = M.default_config("python"),
    -- rust_analyzer = { configured below servers },
    sqls = M.default_config({ "sql", "mysql" }),
    stylelint_lsp = M.without_winbar_config({
        "css",
        "less",
        "postcss",
        "sass",
        "scss",
        "sugarss",
    }),
    -- volar = M.default_config("vue"),
    taplo = M.default_config("toml"),
    -- tsserver = { configured below servers },
    yamlls = M.without_formatting("yaml"),
}
-- }}}

-- {{{ Java
local function start_server_java()
    local jdtls_launcher =
        vim.fn.glob(global.mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
    local jdtls_bundles = {
        vim.fn.glob(
            global.mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
            1
        ),
    }
    vim.list_extend(
        jdtls_bundles,
        vim.split(vim.fn.glob(global.mason_path .. "/packages/java-test/extension/server/*.jar", 1), "\n")
    )
    local jdtls_config = global.mason_path .. "/packages/jdtls/config_" .. global.os
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = global.cache_path .. "/workspace-root/" .. project_name
    require("jdtls").start_or_attach({
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            jdtls_launcher,
            "-configuration",
            jdtls_config,
            "-data",
            workspace_dir,
        },
        filetyps = { "java" },
        root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, {
                upward = true,
            })[1]),
        bundles = jdtls_bundles,
        settings = {
            java = {},
        },
        init_options = {
            bundles = jdtls_bundles,
        },
        on_attach = function(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()
            -- require("jdtls").test_class()
            -- require("jdtls").test_nearest_method()
        end,
    })
end
local JdtlsHooks = vim.api.nvim_create_augroup("JdtlsHooks", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = JdtlsHooks,
    pattern = "java",
    callback = function()
        start_server_java()
    end,
})
vim.tbl_filter(function(buf)
    if
        vim.api.nvim_buf_is_valid(buf)
        and vim.api.nvim_buf_get_option(buf, "buflisted")
        and vim.api.nvim_buf_get_option(buf, "filetype") == "java"
    then
        vim.api.nvim_buf_set_option(buf, "filetype", "java")
    end
end, vim.api.nvim_list_bufs())
-- }}}
-- {{{ Typescript
local typescript = require("typescript")
typescript.setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false,         -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true,   -- fall back to standard LSP definition on failure
    },
    server = {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        on_attach = function(client, bufnr)
            M.on_attach(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = M.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    },
})
-- }}}
-- {{{ Rust
local rust_tools = require("rust-tools")
rust_tools.setup({
    tools = {
        inlay_hints = {
            auto = true,
        },
        hover_actions = {
            border = {
                { "┌", "FloatBorder" },
                { "─", "FloatBorder" },
                { "┐", "FloatBorder" },
                { "│", "FloatBorder" },
                { "┘", "FloatBorder" },
                { "─", "FloatBorder" },
                { "└", "FloatBorder" },
                { "│", "FloatBorder" },
            },
        },
    },
    server = {
        checkOnSave = "clippy",
        cargo = {
            allFeatures = true,
        },
        inlayHints = {
            lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
            },
        },
        assist = {
            importEnforceGranularity = true,
            importPrefix = true,
        },
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = { "rust" },
        on_attach = function(client, bufnr)
            -- languages_setup.keymaps(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = M.get_capabilities(),
        -- root_dir = function(fname)
        -- 	return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        -- end,
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            global.mason_path .. "/packages/codelldb/extension/adapter/codelldb",
            global.mason_path .. "/packages/codelldb/extension/adapter/libcodelldb.so"
        ),
    },
})
-- }}}

-- {{{ Mason setup
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
    return
end
mason.setup({
    ui = {
        icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
        },
    },
})

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
mason_lspconfig.setup_handlers({
    function(server_name)
        if funcs.has_value(servers, server_name) then
            require("lspconfig")[server_name].setup({
                capabilities = servers[server_name].capabilities,
                on_attach = servers[server_name].on_attach,
                settings = servers[server_name].settings,
                flags = servers[server_name].flags,
                root_dir = servers[server_name].root_dir,
            })
        end
    end,
})
-- }}}
