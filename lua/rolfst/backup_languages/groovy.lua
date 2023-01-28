local languages_setup = require("rolfst.utils")
local clojure_lsp_config = require("rolfst.languages._configs").default_config({ "groovy" }, "groovy")

local language_configs = {}

language_configs["dependencies"] = { "groovy-language-server" }

language_configs["lsp"] = function()
    languages_setup.setup_languages({
        ["language"] = "groovy",
        ["groovy-language-server"] = { "groovyls", clojure_lsp_config },
    })
end

return language_configs
