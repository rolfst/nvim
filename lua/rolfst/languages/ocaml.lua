local languages_setup = require("rolfst.utils")
local ocaml_config = require("rolfst.languages._configs").default_config(
	{ "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	"ocaml"
)

local language_configs = {}

language_configs["dependencies"] = { "ocaml-lsp" }

language_configs["lsp"] = function()
	return {
		["language"] = "ocaml",
		["language-server"] = { "ocamllsp", ocaml_config },
		["dependencies"] = {
			"ocamlformat",
		},
	}
end

return language_configs
