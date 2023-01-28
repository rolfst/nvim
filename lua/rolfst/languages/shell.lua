local languages_setup = require("rolfst.utils")
local bashls_config =
	require("rolfst.languages._configs").without_formatting({ "sh", "bash", "zsh", "csh", "ksh" }, "shell")

local language_configs = {}

language_configs["dependencies"] = { "bash-language-server", "shfmt", "shellcheck" }

language_configs["lsp"] = function()
	return {
		["language"] = "shell",
		["language-server"] = { "bashls", bashls_config },
		["dependencies"] = {
			"shfmt",
			"shellcheck",
		},
	}
end

return language_configs
