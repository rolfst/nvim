local languages_setup = require("rolfst.utils")
local lemminx_config =
	require("rolfst.languages._configs").default_config({ "xml", "xsd", "xsl", "xslt", "svg" }, "xml")

local language_configs = {}

language_configs["dependencies"] = { "lemminx" }

language_configs["lsp"] = function()
	return {
		["language"] = "xml",
		["language-server"] = { "lemminx", lemminx_config },
	}
end

return language_configs
