local languages_setup = require("rolfst.utils")
local clojure_lsp_config = require("rolfst.languages._configs").default_config({ "clojure", "edn" }, "clojure")

local language_configs = {}

language_configs["dependencies"] = { "clojure-lsp" }

language_configs["lsp"] = function()
	return {
		["language"] = "clojure",
		["language-server"] = { "clojure_lsp", clojure_lsp_config },
	}
end

return language_configs
