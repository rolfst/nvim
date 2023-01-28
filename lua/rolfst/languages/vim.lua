local languages_setup = require("rolfst.utils")
local vimls_config = require("rolfst.languages._configs").default_config({ "vim" }, "vim")

local language_configs = {}

language_configs["dependencies"] = { "vim-language-server", "vint" }

language_configs["lsp"] = function()
	return {
		["language"] = "vim",
		["language-server"] = { "vimls", vimls_config },
		["dependencies"] = {
			"vint",
		},
	}
end

return language_configs
