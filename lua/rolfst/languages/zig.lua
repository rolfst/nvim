local languages_setup = require("languages.base.utils")
local zls_config = require("languages.base.languages._configs").default_config({ "zig", "zir" }, "zig")

local language_configs = {}

language_configs["dependencies"] = { "zls" }

language_configs["lsp"] = function()
	return {
		["language"] = "zig",
		["language-server"] = { "zls", zls_config },
	}
end

return language_configs
