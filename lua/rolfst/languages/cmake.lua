local languages_setup = require("rolfst.utils")
local cmake_config = require("rolfst.languages._configs").default_config({ "cmake" }, "cmake")

local language_configs = {}

language_configs["dependencies"] = { "cmake-language-server" }

language_configs["lsp"] = function()
	return {
		["language"] = "cmake",
		["language-server"] = { "cmake", cmake_config },
	}
end

return language_configs
