local global = require("rolfst.global")
local funcs = require("rolfst.funcs")
local icons = require("rolfst.icons")
local navic = require("nvim-navic")

-- {{{ Snippets setup
local blink_status_ok, blink = pcall(require, "blink.cmp")
if not blink_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

vim.api.nvim_create_augroup("Copilot", { clear = true })
local copilot_status_ok, copilot = pcall(require, "copilot")
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
        if copilot_status_ok then
            copilot.setup({
                suggestion = {
                    auto_trigger = true,
                    enabled = true,
                    keymap = {
                        accept = "<M-Space>",
                        next = "<C-j>",
                        prev = "<C-k>",
                    },
                },
            })
        end
    end,
    group = "Copilot",
})

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
require("luasnip.loaders.from_lua").lazy_load({
    paths = { global.snippets_path .. "/luasnippets" },
})

vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    "lua require'luasnip.loaders'.edit_snippet_files()",
    {}
)
vim.keymap.set(
    "n",
    "<space>se",
    ":LuaSnipEdit<cr>",
    { desc = "Edit lua snippet" }
)

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
    return col ~= 0
        and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
        == nil
end

blink.setup({
    appearance = { nerd_font_variant = "mono" },
    fuzzy = { implementation = "prefer_rust" },
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
})
-- }}}

vim.api.nvim_create_user_command("LspHover", "lua vim.lsp.buf.hover()", {})
vim.api.nvim_create_user_command("LspRename", "lua vim.lsp.buf.rename()", {})
vim.api.nvim_create_user_command(
    "LspAddToWorkspaceFolder",
    "lua vim.lsp.buf.add_workspace_folder()",
    {}
)
vim.api.nvim_create_user_command(
    "LspListWorkspaceFolders",
    "lua vim.lsp.buf.list_workspace_folders()",
    {}
)
vim.api.nvim_create_user_command(
    "LspRemoveWorkspaceFolder",
    "lua vim.lsp.buf.remove_workspace_folder()",
    {}
)
vim.api.nvim_create_user_command(
    "LspWorkspaceSymbol",
    "lua vim.lsp.buf.workspace_symbol()",
    {}
)
vim.api.nvim_create_user_command(
    "LspDocumentSymbol",
    "lua vim.lsp.buf.document_symbol()",
    {}
)
vim.api.nvim_create_user_command(
    "LspCodeAction",
    "lua vim.lsp.buf.code_action()",
    {}
)
vim.api.nvim_create_user_command(
    "LspCodeLensRefresh",
    "lua vim.lsp.codelens.refresh()",
    {}
)
vim.api.nvim_create_user_command(
    "LspCodeLensRun",
    "lua vim.lsp.codelens.run()",
    {}
)
vim.api.nvim_create_user_command(
    "LspDeclaration",
    "lua vim.lsp.buf.declaration()",
    {}
)
vim.api.nvim_create_user_command(
    "LspDefinition",
    "lua vim.lsp.buf.definition()",
    {}
)
vim.api.nvim_create_user_command(
    "LspTypeDefinition",
    "lua vim.lsp.buf.type_definition()",
    {}
)
vim.api.nvim_create_user_command(
    "LspReferences",
    "lua vim.lsp.buf.references()",
    {}
)
vim.api.nvim_create_user_command(
    "LspClearReferences",
    "lua vim.lsp.buf.clear_references()",
    {}
)
vim.api.nvim_create_user_command(
    "LspDocumentHighlight",
    "lua vim.lsp.buf.document_highlight()",
    {}
)
vim.api.nvim_create_user_command(
    "LspImplementation",
    "lua vim.lsp.buf.implementation()",
    {}
)
vim.api.nvim_create_user_command(
    "LspIncomingCalls",
    "lua vim.lsp.buf.incoming_calls()",
    {}
)
vim.api.nvim_create_user_command(
    "LspOutgoingCalls",
    "lua vim.lsp.buf.outgoing_calls()",
    {}
)
vim.api.nvim_create_user_command(
    "LspFormat",
    "lua vim.lsp.buf.format()",
    { desc = "Format current buffer with LSP" }
)
vim.api.nvim_create_user_command(
    "LspSignatureHelp",
    "lua vim.lsp.buf.signature_help()",
    {}
)
vim.api.nvim_create_user_command(
    "LspShowDiagnosticCurrent",
    "lua require('rolfst.utils.show_diagnostic').line()",
    {}
)

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
    if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true)
    end
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
    nmap("gI", vim.cmd.LspImplementation, "[G]oto [I]mplementation")
    nmap("dc", function()
        vim.diagnostic.open_float()
    end, "[d]iagnoti[c]s")
    nmap("ca", function()
        vim.lsp.buf.code_action()
    end, "[c]ode [a]ction")

    nmap("grn", vim.cmd.LspRename, "[r]e[n]ame")

    nmap("<space>f", vim.cmd.LspFormat, "Format")
    vim.keymap.set("v", "<space>f", function()
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
    nmap("<leader>i", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "Toggle inlay hints")

    nmap("cL", function()
        vim.lsp.codelens.refresh()
    end, "[c]ode [l]ens refresh")
    nmap("cl", function()
        vim.lsp.codelens.run()
    end, "[c]ode [l]ens run")

    nmap("K", function()
        vim.lsp.buf.hover()
    end, "Hover documentation")
    vim.keymap.set("i", "<c-k>", function()
        vim.lsp.buf.signature_help()
    end, describe("signature help"))

    nmap(
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        "[w]orkspace [a]dd Folder"
    )
    nmap(
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        "[w]orkspace [r]emove Folder"
    )
    nmap("<leader>wl", function()
        vim.lsp.buf.list_workspace_folders()
    end, "[w]orkspace [l]ist Folders")

    nmap("gr", function()
        require("fzf-lua").lsp_references()
    end, "[G]oto [R]eferences")
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

-- {{{ Null_ls setup
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end
local actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local u = require("null-ls.utils")
null_ls.register({
    name = "biome",
    method = methods.internalsLINT,
    filetypes = {
        "markdown",
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "yaml",
        "markdown",
        "graphql",
    },
    generator = {
        command = "biome",
        args = {
            "lint",
            "--stdin-file-path",
            "$FILENAME",
        },
        dynamic_command = cmd_resolver.from_node_modules(),
        cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern("rome.json", "biome.json", "biome.jsonc")(
                params.bufname
            )
        end),
        to_stdin = true,
    },
})
null_ls.setup({
    debug = false,
    sources = {
        require("none-ls.diagnostics.flake8"),
        require("none-ls.code_actions.eslint"),
        -- actions.eslint_d,
        actions.gitsigns,
        actions.refactoring,
        diagnostics.cfn_lint,
        -- diagnostics.deadnix,
        require("none-ls.diagnostics.eslint"),
        -- diagnostics.eslint_d,
        diagnostics.selene,
        diagnostics.markdownlint,
        diagnostics.stylelint,
        diagnostics.yamllint,
        diagnostics.zsh,
        -- completions.spell,
        formatting.alejandra,
        formatting.black,
        formatting.codespell.with({ filetypes = { "markdown" } }),
        formatting.biome,
        formatting.isort,
        -- formatting.dprint,
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
            env = {
                -- PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("$HOME/.config/nvim/.configs/formatters/.prettierrc.json"),
                PRETTIERD_DEFAULT_CONFIG = vim.fn.getcwd()
                    .. ".prettierrc.json",
            },
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
            M.on_attach(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = blink.get_lsp_capabilities(),
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
            M.on_attach(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = blink.get_lsp_capabilities(),
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
        init_options = {
            ["bem.enabled"] = true,
        },
    }
end

M.config_with_command = function(file_types, settings, command)
    return {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        command = command,
        filetypes = file_types,
        on_attach = function(client, bufnr)
            -- languages_setup.keymaps(client, bufnr)
            M.on_attach(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = blink.get_lsp_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = (settings == nil and {} or settings),
    }
end

local servers = {
    angularls = {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = {
            "typescript",
            "html",
            "typescriptreact",
            "typescript.tsx",
        },
        on_attach = function(client, bufnr)
            if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(true)
            end
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = blink.get_lsp_capabilities(),
        root_dir = nvim_lsp_util.root_pattern("angular.json"),
    },
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
    -- M.on_attach(client, bufnr)
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
    -- M.on_attach(client, bufnr)
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
    emmet_ls = M.without_winbar_config({
        "html",
        "css",
        "javascriptreact",
        "typescriptreact",
    }),
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
    -- M.on_attach(client, bufnr)
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
    -- capabilities = blink.get_lsp_capabilities(),
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
    marksman = M.config_with_command(
        { "markdown", "telekasten" },
        nil,
        "marksman"
    ),
    nil_ls = M.default_config("nix"),
    -- omnisharp = M.default_config({"cs", "vb"}),
    pyright = M.default_config("python"),
    -- rust_analyzer = { configured below servers },
    sqlls = M.default_config({ "sql", "mysql" }),
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
    local jdtls_launcher = vim.fn.glob(
        global.mason_path
        .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
    )
    local jdtls_bundles = {
        vim.fn.glob(
            global.mason_path
            .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
            1
        ),
    }
    vim.list_extend(
        jdtls_bundles,
        vim.split(
            vim.fn.glob(
                global.mason_path
                .. "/packages/java-test/extension/server/*.jar",
                1
            ),
            "\n"
        )
    )
    local jdtls_config = global.mason_path
        .. "/packages/jdtls/config_"
        .. global.os
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = global.cache_path
        .. "/workspace-root/"
        .. project_name
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
            M.on_attach(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            navic.attach(client, bufnr)
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()
            require("jdtls").test_class()
            require("jdtls").test_nearest_method()
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
local lspconfig = require("lspconfig")

-- {{{ Typescript
local typescript = lspconfig["ts_ls"]
typescript.setup({
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    on_attach = function(client, bufnr)
        M.on_attach(client, bufnr)
        M.omni(client, bufnr)
        M.tag(client, bufnr)
        M.document_highlight(client, bufnr)
        navic.attach(client, bufnr)
    end,
    capabilities = blink.get_lsp_capabilities(),
    root_dir = function(fname)
        return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false,            -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true,      -- fall back to standard LSP definition on failure
    },
    autostart = true,
    settings = {
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayfunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationtypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayfunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationtypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    },
    flags = {
        debounce_text_changes = default_debouce_time,
    },
})
-- }}}
-- {{{ haskell
-- local ht = require("haskell-tools")
-- ht.start_or_attach({
--     hls = {
--         on_attach = function(client, bufnr)
--             local opts = { buffer = bufnr, remap = false }
--             M.on_attach(client, bufnr)
--             nmap("<space>ghs", ht.hoogle.hoogle_signature, "Hoogle signature")
--             vim.keymap.set("n", "<space>gea", ht.lsp.buf_eval_all, "eval buff")
--             -- Toggle a GHCi repl for the current package
--             vim.keymap.set("n", "<leader>grr", ht.repl.toggle, "Start repl")
--             -- Toggle a GHCi repl for the current buffer
--             vim.keymap.set("n", "<leader>grf", function()
--                 ht.repl.toggle(vim.api.nvim_buf_get_name(0))
--             end, "Start repl from current buffer")
--             vim.keymap.set("n", "<leader>grq", ht.repl.quit, "Quit repl")
--         end,
--     },
-- })
-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
-- ht.dap.discover_configurations(bufnr)
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
            M.on_attach(client, bufnr)
            -- languages_setup.keymaps(client, bufnr)
            M.omni(client, bufnr)
            M.tag(client, bufnr)
            M.document_highlight(client, bufnr)
            M.document_formatting(client, bufnr)
            navic.attach(client, bufnr)
        end,
        capabilities = blink.get_lsp_capabilities(),
        -- root_dir = function(fname)
        -- 	return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        -- end,
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            global.mason_path .. "/packages/codelldb/extension/adapter/codelldb",
            global.mason_path
            .. "/packages/codelldb/extension/adapter/libcodelldb.so"
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
local declared = vim.tbl_keys(servers)
local ensured = funcs.filter(declared, function(v, _, _)
    if v == "markdown" then
        return false
    end
    -- if v == "lua_ls" then
    --     return false
    -- end
end)
mason_lspconfig.setup({ ensure_installed = ensured })
mason_lspconfig.setup_handlers({
    function(server_name)
        if funcs.has_value(servers, server_name) then
            local capabilities = blink.get_lsp_capabilities()
            lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = servers[server_name].on_attach,
                settings = servers[server_name].settings,
                flags = servers[server_name].flags,
                root_dir = servers[server_name].root_dir,
            })
        end
    end,
})
local capabilities = blink.get_lsp_capabilities()
lspconfig["lua_ls"].setup({
    -- capabilities = servers["lua_ls"].capabilities,
    capabilities = capabilities,
    on_attach = servers["lua_ls"].on_attach,
    settings = servers["lua_ls"].settings,
    flags = servers["lua_ls"].flags,
    root_dir = servers["lua_ls"].root_dir,
})
-- }}}
