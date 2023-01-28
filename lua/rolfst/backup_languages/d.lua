local languages_setup = require("languages.base.utils")
local serve_d_config = require("languages.base.languages._configs").default_config({ "d" }, "d")

local language_configs = {}

language_configs["dependencies"] = { "serve-d" }

language_configs["lsp"] = function()
    languages_setup.setup_languages({
        ["language"] = "d",
        ["serve-d"] = { "serve_d", serve_d_config },
    })
end

return language_configs
