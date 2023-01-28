-- npm --save-dev install @angular/language-server @angular/language-service typescript
local languages_setup = require("rolfst.utils")
local angularls_config = require("rolfst.languages._configs").angular_config(
	{ "typescript", "html", "typescriptreact", "typescript.tsx" },
	"angular"
)

local language_configs = {}

language_configs["dependencies"] = { "angular-language-server" }

language_configs["lsp"] = function()
	return {
		["language"] = "angular",
		["language-server"] = { "angularls", angularls_config },
	}
end

return language_configs
