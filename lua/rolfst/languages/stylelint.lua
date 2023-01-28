local languages_setup = require("rolfst.utils")
local stylelint_lsp_config = require("rolfst.languages._configs").without_winbar_config({
	"css",
	"less",
	"postcss",
	"sass",
	"scss",
	"sugarss",
}, "_stylelint")

local language_configs = {}

language_configs["dependencies"] = { "stylelint-lsp" }

language_configs["lsp"] = function()
	return {
		["language"] = "stylelint",
		["language-server"] = { "stylelint_lsp", stylelint_lsp_config },
	}
end

return language_configs
