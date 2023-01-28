local global = require("rolfst.global")
local configs = require("rolfst.configs")
local M = {}
M.omni = function(client, bufnr)
	if client.server_capabilities.completionProvider then
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	end
end

M.tag = function(client, bufnr)
	if client.server_capabilities.definitionProvider then
		vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
	end
end

M.document_highlight = function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			command = "lua vim.lsp.buf.document_highlight()",
			group = "NvimIDE",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			command = "lua vim.lsp.buf.clear_references()",
			group = "NvimIDE",
		})
	end
end

M.document_formatting = function(client, bufnr)
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				if _G.LVIM_SETTINGS.autoformat == true then
					vim.lsp.buf.format()
				end
			end,
			group = "NvimIDE",
		})
	end
end

M.get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end
	return capabilities
end

M.get_cpp_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end
	capabilities.offsetEncoding = "utf-16"
	return capabilities
end

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end
local mason_registry = require("mason-registry")
M.packages_to_install = {}

M.check_proccess = function(k)
	print("should register")
	vim.defer_fn(function()
		if not mason_registry.is_installed(k) then
			vim.defer_fn(function()
				M.check_proccess(k)
			end, 100)
		else
			print("language server")
			print(k)
			local index = {}
			vim.defer_fn(function()
				for key, v in pairs(M.packages_to_install) do
					index[v] = key
					if index[v] ~= nil then
						null_ls.register({
							configs.null_ls_builtins[v],
						})
					end
				end
				M.packages_to_install[index[k]] = nil
			end, 3000)
		end
	end, 200)
end
M.install = function(nr_packages_to_install, packages)
	for i = 1, #packages do
		if not mason_registry.is_installed(packages[i]) then
			nr_packages_to_install = nr_packages_to_install + 1
			table.insert(M.packages_to_install, packages[i])
		end
	end
end
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

M.setup_languages = function(packages_data)
	-- local function install_package()
	--     if next(M.packages_to_install) ~= nil then
	--         if global.lvim_packages == false then
	--             vim.defer_fn(function()
	--                 select({
	--                     "Install packages for " .. M.current_language,
	--                     "Install packages for all languages",
	--                     "Don't ask me again",
	--                     "Cancel",
	--                 }, { prompt = "LVIM IDE need to install some packages" }, function(choice)
	--                     if choice == "Install packages for " .. M.current_language then
	--                         vim.defer_fn(function()
	--                             for i = 1, #M.packages_to_install do
	--                                 vim.cmd("MasonInstall " .. M.packages_to_install[i])
	--                                 M.check_proccess(M.packages_to_install[i])
	--                             end
	--                         end, 100)
	--                         vim.defer_fn(function()
	--                             if global.install_proccess then
	--                                 M.check_finish()
	--                             end
	--                         end, 100)
	--                     elseif choice == "Install packages for all languages" then
	--                         M.install_all_packages()
	--                     elseif choice == "Don't ask me again" then
	--                         local notify = require("lvim-ui-config.notify")
	--                         funcs.write_file(global.cache_path .. "/.lvim_packages", "")
	--                         notify.error("To enable ask again run command:\n:AskForPackagesFile\nand restart LVIM IDE", {
	--                             timeout = 10000,
	--                             title = "LVIM IDE",
	--                         })
	--                     elseif choice == "Cancel" then
	--                         local notify = require("lvim-ui-config.notify")
	--                         notify.error("Need restart LVIM IDE to install packages for this filetype", {
	--                             timeout = 10000,
	--                             title = "LVIM IDE",
	--                         })
	--                     end
	--                 end, "editor")
	--             end, 100)
	--         end
	--     end
	-- end
	local function init(packages)
		if global.install_proccess then
			vim.defer_fn(function()
				init(packages)
			end, 1000)
		else
			M.packages_to_install = {}
			M.lsp_to_start = {}
			M.ordered_keys = {}
			M.current_language = ""
			for k in pairs(packages) do
				table.insert(M.ordered_keys, k)
			end
			table.sort(M.ordered_keys)
			print("packages " .. vim.inspect(packages))
			for i = 1, #M.ordered_keys do
				local k, v = M.ordered_keys[i], packages[M.ordered_keys[i]]
				if k == "language" then
					M.current_language = v
				elseif k == "dependencies" then
					for a = 1, #v do
						if not mason_registry.is_installed(v[a]) then
							global.install_proccess = true
							M.dependencies_ready = false
							table.insert(M.packages_to_install, v[a])
						else
							if v[a] ~= nil then
								null_ls.register({
									configs.null_ls_builtins[v[a]],
								})
							end
						end
					end
				elseif k == "dap" then
					for a = 1, #v do
						if not mason_registry.is_installed(v[a]) then
							global.install_proccess = true
							table.insert(M.packages_to_install, v[a])
						end
					end
				else
					if not mason_registry.is_installed(k) then
						global.install_proccess = true
						table.insert(M.packages_to_install, k)
						if v[1] ~= nil and v[2] ~= nil then
							table.insert(M.lsp_to_start, { v[1], v[2] })
						end
					else
						if v[1] ~= nil and v[2] ~= nil then
							lspconfig[v[1]].setup(v[2])
							vim.cmd("LspStart " .. v[1])
						end
					end
				end
			end
			-- vim.schedule(function()
			--     vim.defer_fn(function()
			--         install_package()
			--     end, 3000)
			-- end)
		end
	end

	init(packages_data)
end
M.start_language = function(language)
	local project_root_path = vim.fn.getcwd()
	if global["languages"][language] ~= nil then
		if global["languages"][language]["project_root_path"] == project_root_path then
			return
		else
			M.pre_init_language(language, project_root_path, "global")
			M.init_language(language, project_root_path)
		end
	else
		M.pre_init_language(language, project_root_path, "global")
		M.init_language(language, project_root_path)
	end
end

M.pre_init_language = function(language, project_root_path, lsp_type)
	global["languages"][language] = {}
	global["languages"][language]["project_root_path"] = project_root_path
	global["languages"][language]["lsp_type"] = lsp_type
end

M.init_language = function(language)
	-- local lspconfig_util_ok, lspconfig_util = pcall(require, "lspconfig.util")
	-- if not lspconfig_util_ok then
	--     return
	-- end
	-- local neoconf_status_ok, neoconf = pcall(require, "neoconf")
	-- if not neoconf_status_ok then
	--     return
	-- end
	-- if #lspconfig_util.available_servers() == 0 then
	--     neoconf.setup()
	-- end
	local language_configs_global = dofile(global.nvim_path .. "/lua/rolfst/languages/" .. language .. ".lua")
	for _, func in pairs(language_configs_global) do
		if type(func) == "function" then
			func()
		end
	end
end

return M
