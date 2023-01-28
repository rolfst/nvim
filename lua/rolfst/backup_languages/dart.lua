local languages_setup = require("languages.base.utils")
local navic = require("nvim-navic")

local language_configs = {}

language_configs["lsp"] = function()
    local flutter_tools = require("flutter-tools")
    flutter_tools.setup({
        debugger = {
            enabled = true,
        },
        closing_tags = {
            prefix = " ",
        },
        lsp = {
            on_attach = function(client, bufnr)
                languages_setup.keymaps(client, bufnr)
                languages_setup.omni(client, bufnr)
                languages_setup.tag(client, bufnr)
                languages_setup.document_highlight(client, bufnr)
                languages_setup.document_formatting(client, bufnr)
                navic.attach(client, bufnr)
            end,
            capabilities = languages_setup.get_capabilities(),
        },
    })
end

return language_configs
