local eslint_config = require("rolfst.languages._configs").without_winbar_config({
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
	"vue",
}, "_eslint")

local language_configs = {}

language_configs["dependencies"] = { "eslint-lsp" }

language_configs["lsp"] = function()
	return {
		["language"] = "eslint",
		["language-server"] = { "eslint", eslint_config },
	}
end

return language_configs
