local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local nvim_lsp_util = require("lspconfig/util")
local navic = require("nvim-navic")
local default_debouce_time = 150
local M = {}

M.default_config = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.without_formatting = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.without_winbar_config = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.cpp_config = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			client.offset_encoding = "utf-16"
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_cpp_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.omnisharp_config = function(file_types)
	return {
		cmd = { "dotnet", global.mason_path .. "/packages/omnisharp/OmniSharp.dll" },
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.elixir_config = function(file_types)
	return {
		cmd = { global.mason_path .. "/bin/elixir-ls" },
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.go = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.lua = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			navic.attach(client, bufnr)
		end,
		settings = {
			Lua = {
				format = {
					enable = false,
				},
				hint = {
					enable = true,
					arrayIndex = "All",
					await = true,
					paramName = "All",
					paramType = true,
					semicolon = "Disable",
					setType = true,
				},
				runtime = {
					version = "LuaJIT",
					special = {
						reload = "require",
					},
				},
				diagnostics = {
					globals = {
						"vim",
						"use",
						"packer_plugins",
						"NOREF_NOERR_TRUNC",
					},
				},
				telemetry = {
					enable = false,
				},
			},
		},
		capabilities = languages_setup.get_capabilities(),
		root_dir = function(fname)
			return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
	}
end

M.angular_config = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = nvim_lsp_util.root_pattern("angular.json"),
	}
end

M.ember_config = function(file_types)
	return {
		flags = {
			debounce_text_changes = default_debouce_time,
		},
		autostart = true,
		filetypes = file_types,
		on_attach = function(client, bufnr)
			-- languages_setup.keymaps(client, bufnr)
			languages_setup.omni(client, bufnr)
			languages_setup.tag(client, bufnr)
			languages_setup.document_highlight(client, bufnr)
			languages_setup.document_formatting(client, bufnr)
			navic.attach(client, bufnr)
		end,
		capabilities = languages_setup.get_capabilities(),
		root_dir = nvim_lsp_util.root_pattern("ember-cli-build.js"),
	}
end

return M
