local configs = require("rolfst.configs")
local M = {}

M.setup = function()
	local file_type = vim.bo.filetype
	local file_types = configs.file_types

	for language, v in pairs(file_types) do
		for _, v2 in pairs(v) do
			if v2 == file_type then
				M.start_language(language)
			end
		end
	end
end

M.start_language = function(language)
	local language_configs_global = dofile(global.nvim_path .. "/lua/rolfst/languages/" .. "lua" .. ".lua")
	for _, t in pairs(files) do
		lsp.configure(language_configs_global["language-server"][1], {
			on_attach = function(client, bufnr)
				print("hello from " .. t)
			end,
		})
		null_ls.register(configs.null_ls_builtins["lua"])
	end
end
return M
