local languages_setup = require("rolfst.utils")
local volar_config = require("rolfst.languages._configs").default_config({ "vue" }, "vue")

local language_configs = {}

language_configs["dependencies"] = { "vue-language-server" }

language_configs["lsp"] = function()
	return {
		["language"] = "vue",
		["language-server"] = { "volar", volar_config },
	}
end

return language_configs
