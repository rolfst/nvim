local languages_setup = require("rolfst.utils")
local emmet_ls_config = require("rolfst.languages._configs").without_winbar_config(
	{ "html", "css", "typescriptreact", "javascriptreact" },
	"emmet"
)

local language_configs = {}

language_configs["dependencies"] = { "emmet-ls" }

language_configs["lsp"] = function()
	return {
		["language"] = "emmet",
		["language-server"] = { "emmet_ls", emmet_ls_config },
	}
end

return language_configs
